FROM ubuntu:24.04

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
                curl \
                sudo \
                ca-certificates

ARG DOCKER_VERSION="28.5.2"

RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt install -y --no-install-recommends \
                   containerd.io \
                   docker-buildx-plugin \
                   docker-ce=5:${DOCKER_VERSION}-1~ubuntu.24.04~noble \
                   docker-ce-cli=5:${DOCKER_VERSION}-1~ubuntu.24.04~noble \
                   docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL --retry 3 "https://github.com/moby/moby/raw/v${DOCKER_VERSION}/hack/dind" -o /usr/local/bin/dind \
  && chmod a+x /usr/local/bin/dind

RUN useradd -m runner && \
    usermod -aG docker runner && \
    usermod -aG sudo runner && \
    echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers

ARG TARGETARCH
ARG RUNNER_VERSION="2.334.0"

RUN ARCH=$([ "$TARGETARCH" = "amd64" ] && echo x64 || echo arm64) && \
    cd /home/runner && \
    mkdir actions-runner && \
    cd actions-runner && \
    curl -o actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz

# Install the dependencies required to run the runner
RUN /home/runner/actions-runner/bin/installdependencies.sh

USER runner

# Copy the script and make it executable
COPY start.sh /start.sh
RUN sudo chmod +x /start.sh

# Without this volume docker can't mount and use the overlay2 storage-driver, and will instead use the slower VFS
# Also without this volume and overlay2, errors occur when creating a cluster using kind
VOLUME /var/lib/docker

ENTRYPOINT ["/start.sh"]
