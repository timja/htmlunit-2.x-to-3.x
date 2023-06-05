FROM maven:3.9-eclipse-temurin-11-alpine

COPY multi-gitter-config.yaml /work/
COPY replace.sh /work/
COPY run.sh /work/

WORKDIR /work

RUN apk update && \
    apk add bash curl git sudo && \
    curl -s https://raw.githubusercontent.com/lindell/multi-gitter/master/install.sh | sh && \
    chmod +x replace.sh run.sh

ENTRYPOINT [ "./run.sh" ]