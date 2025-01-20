FROM jenkins/jenkins:lts-jdk17

USER root

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sudo curl lsb-release apt-transport-https gnupg2 \
        && rm -rf /var/lib/apt/lists/*

# Copy the blobfuse2 deb file into the image
COPY blobfuse2*.deb /tmp/


RUN apt-get update && apt-get install -y sudo curl lsb-release apt-transport-https gnupg2 fuse3 && \
    mkdir /mnt/blob

RUN dpkg -i /tmp/blobfuse2*.deb \
    && apt-get install -y -f \
    && rm -rf /tmp/blobfuse2*.deb


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
