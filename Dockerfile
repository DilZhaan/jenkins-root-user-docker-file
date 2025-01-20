FROM jenkins/jenkins:lts-jdk17
USER root

RUN apt-get update && \
    apt-get install -y sudo curl lsb-release apt-transport-https gnupg2 && \
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft-prod.list && \
    sudo apt-get update && \
    sudo apt-get install -y blobfuse

RUN mkdir /mnt/blob

RUN echo 'root:root' | chpasswd
RUN echo 'jenkins:jenkins' | chpasswd
USER jenkins
