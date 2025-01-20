FROM jenkins/jenkins:lts-jdk17
USER root

RUN apt-get update && \
    apt-get install -y sudo curl lsb-release apt-transport-https gnupg2 && \
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft-prod.list && \
    sudo apt-get update && \
    sudo apt-get install -y blobfuse

RUN mkdir /mnt/blob

# Add jenkins user to sudo group
RUN usermod -aG sudo jenkins
# Allow jenkins to use sudo without password
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set passwords
RUN echo 'root:root' | chpasswd
RUN echo 'jenkins:jenkins' | chpasswd

# Create an entrypoint script to handle permissions
RUN echo '#!/bin/bash\n\
sudo chown -R jenkins:jenkins /var/jenkins_home\n\
exec /sbin/tini -- /usr/local/bin/jenkins.sh' > /usr/local/bin/jenkins-entrypoint.sh && \
    chmod +x /usr/local/bin/jenkins-entrypoint.sh

    # Dockerfile: You already have blobfuse installed
RUN apt-get update && \
apt-get install -y blobfuse

USER jenkins
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]