FROM mcr.microsoft.com/powershell:lts-ubuntu-22.04
# FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TARGETARCH="linux-x64"
# Also can be "linux-arm", "linux-arm64".

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt update
RUN apt upgrade -y
RUN apt install -y ca-certificates curl git jq iputils-ping libicu70 libcurl4 libunwind8 netcat ruby unzip dnsutils

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

USER agent
# Another option is to run the agent as root. If so comment out the line above and uncomment the line below.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./start.sh" ]