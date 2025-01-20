FROM jenkins/jenkins:lts-jdk17
USER root
RUN apt-get update && apt-get install -y sudo
RUN echo 'root:root' | chpasswd
RUN echo 'jenkins:jenkins' | chpasswd
RUN usermod -u 1000 jenkins && groupmod -g 1000 jenkins
RUN mkdir -p /var/jenkins_home/workspace && \
    chown -R jenkins:jenkins /var/jenkins_home
USER jenkins
ENTRYPOINT ["/bin/bash", "-c", "chown -R jenkins:jenkins /var/jenkins_home && exec java -jar /usr/share/jenkins/jenkins.war --httpPort=8085"]
