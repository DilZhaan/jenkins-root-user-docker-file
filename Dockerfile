FROM jenkins/jenkins:lts-jdk17
USER root
RUN apt-get update && apt-get install -y sudo
RUN echo 'root:root' | chpasswd
RUN echo 'jenkins:jenkins' | chpasswd
