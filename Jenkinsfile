def dockerRegistryUrl = 'https://index.docker.io/v1/'
def dockerRegistryHostname = 'docker.io'

stage('Configure') {
    abort = false
    inputConfig = input id: 'InputConfig', message: 'Docker registry and Anchore Engine configuration', parameters: [ string(defaultValue: '', description: 'Name of the docker repository', name: 'dockerRepository', trim: true), string(defaultValue: '', description: 'Anchore Engine API endpoint', name: 'anchoreEngineUrl', trim: true), credentials(credentialType: 'com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl', defaultValue: '', description: 'Credentials for interacting with Anchore Engine', name: 'anchoreEngineCredentials', required: true)]

    for (config in inputConfig) {
        if (null == config.value || config.value.length() <= 0) {
          echo "${config.key} cannot be left blank"
          abort = true
        }
    }

    if (abort) {
        currentBuild.result = 'ABORTED'
        error('Aborting build due to invalid input')
    }
}

node {
  def app
  def dockerfile
  def anchorefile
  def repotag

  try {
    stage('Checkout') {
      // Clone the git repository
      checkout scm
      def path = sh returnStdout: true, script: "pwd"
      path = path.trim()
      dockerfile = path + "/Dockerfile"
      anchorefile = path + "/anchore_images"
    }

    stage('Build') {
      // Build the image and push it to a staging repository
      repotag = inputConfig['dockerRepository'] + ":${BUILD_NUMBER}"
      withCredentials([string(credentialsId: 'dockerhub-larentis-ottavia', variable: 'DOCKER_CRED')]) {
          docker.withRegistry(dockerRegistryUrl, ${DOCKER_CRED}) {
            app = docker.build(repotag)
            app.push()
          }
      }    
    }

    stage('Parallel') {
      parallel Test: {
        app.inside {
            sh 'echo "Dummy - tests passed"'
        }
      },
      Analyze: {
        //withCredentials([string(credentialsId: 'ecr-repo-arn', variable: 'REGISTRY_ARN')]) {
            writeFile file: anchorefile, text:  dockerRegistryHostname + "/" + repotag + " " + dockerfile
            anchore name: anchorefile, engineRetries: "1000", engineurl: inputConfig['anchoreEngineUrl'], engineCredentialsId: inputConfig['anchoreEngineCredentials'], annotations: [[key: 'added-by', value: 'jenkins']]
        //}
      }
    }
  } finally {
    stage('Cleanup') {
      // Delete the docker image and clean up any allotted resources
      sh script: "docker rmi " + repotag
    }
  }
}
