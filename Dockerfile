FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="America/Sao_Paulo"

RUN apt update && apt install -y sudo xz-utils tzdata && sudo apt clean

RUN useradd -m -s /bin/bash test && \
    echo "test ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER test
ENV USER=test

WORKDIR /home/test/.dotfiles

COPY --chown=test:test . .

RUN chmod +x ./install.sh

ENTRYPOINT ["bash", "-lc", "./install.sh || true; bash"]
