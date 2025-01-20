FROM jenkins/jenkins:lts-jdk17

USER root

RUN apt-get update && \
    apt-get install -y sudo curl lsb-release apt-transport-https gnupg2 git && \
    mkdir /mnt/blob

# Install Go
RUN curl -OL https://golang.org/dl/go1.18.8.linux-amd64.tar.gz && \
    tar -C /usr/local -xvzf go1.18.8.linux-amd64.tar.gz && \
    rm go1.18.8.linux-amd64.tar.gz && \
    echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile

RUN git clone https://github.com/Azure/azure-storage-fuse /mnt/blob/azure-storage-fuse && \
    cd /mnt/blob/azure-storage-fuse && \
    sudo apt install fuse3 libfuse3-dev gcc -y && \
    go build -o blobfuse2

RUN usermod -aG sudo jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN echo 'root:root' | chpasswd
RUN echo 'jenkins:jenkins' | chpasswd

COPY jenkins-entrypoint.sh /usr/local/bin/jenkins-entrypoint.sh

RUN chmod +x /usr/local/bin/jenkins-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/jenkins-entrypoint.sh"]

WORKDIR /var/jenkins_home

USER jenkins

EXPOSE 8080
