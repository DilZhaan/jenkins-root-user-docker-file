FROM jenkins/jenkins:lts-jdk17
USER root
RUN apt-get update && apt-get install -y ruby make more-thing-here
USER jenkins