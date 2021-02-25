# anchore-jenkins-example

This is an example for building a Node application using Jenkins. It includes

- A simple Hello World HTTP server in Node
- `Dockerfile` for building the Docker image with the application
- `Jenkinsfile` that defines the pipeline for the build process and analysis of the Docker image using Anchore plugin

Configure

- Anchore authentication to your Dockerhub repository as Anchore Registry Credentials
- A Jenkins pipeline with this Github repo as a source
- Run the pipeline
- When paused, provide the Dockerhub repository to which the container image will be pushed, Docker credentials, the Anchore endpoint and Anchore credentials.
