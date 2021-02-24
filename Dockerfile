# use a node base image
FROM node:15.10.0-alpine3.10

#Add a user with userid 8877 and name nonroot
RUN ln -sf /bin/bash /bin/sh
RUN useradd -ms /bin/bash  nonroot

#Run Container as nonroot
USER nonroot

# set a health check
HEALTHCHECK --interval=5s --timeout=5s CMD curl -f http://127.0.0.1:3000 || exit 1

# tell docker what port to expose
EXPOSE 3000
