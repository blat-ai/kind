VERSION 0.8
FROM docker:27.0.3-dind

RUN apk --no-cache add curl
RUN wget "https://golang.org/dl/go1.22.5.linux-amd64.tar.gz" && tar -xf "go1.22.5.linux-amd64.tar.gz" && mv -v go /usr/local
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

ENV GOPATH /root/go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
ENV DOCKER_HOST tcp://localhost:2376
ENV DOCKER_TLS 1
ENV DOCKER_TLS_VERIFY 1

RUN go install sigs.k8s.io/kind@v0.23.0
COPY bin/entrypoint.sh /usr/local/bin/kind-entrypoint.sh
COPY kind.yaml /etc/kind/config.yaml

build:
    ARG IMAGE_TAG=latest
    ENTRYPOINT ["kind-entrypoint.sh"]
    SAVE IMAGE blat/kind:$IMAGE_TAG

test:
    FROM earthly/dind:alpine-3.20-docker-26.1.3-r1
    COPY ./docker-compose.yaml ./
    WITH DOCKER --compose docker-compose.yaml --load blat/kind:latest=+build
        RUN docker-compose run kubectl get nodes
    END
