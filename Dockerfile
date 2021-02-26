# use a node base image
FROM node:15.10.0-alpine3.10

# run as my_user
RUN yum -y install python3 python3-pip shadow-utils
RUN useradd my_user
USER my_user

# set a health check
HEALTHCHECK --interval=5s --timeout=5s CMD curl -f http://127.0.0.1:3000 || exit 1

# tell docker what port to expose
EXPOSE 3000
