FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
        python3 \
        python3-pip \
        openssh-server \
        sudo \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/sshd

CMD ["tail", "-f", "/dev/null"]
