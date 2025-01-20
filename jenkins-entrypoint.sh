#!/bin/bash

# Ensure the Blob mount directory exists
mkdir -p /mnt/blob

# Mount the Azure Blob Storage using blobfuse
# The SAS token is passed as an environment variable BLOB_SAS_TOKEN
blobfuse /mnt/blob --container-name="<your-container-name>" \
  --sas-token="$BLOB_SAS_TOKEN" \
  --tmp-path=/mnt/resource/blobfuse

# Change ownership of the mounted Blob directory to the Jenkins user
chown -R jenkins:jenkins /mnt/blob

# Change ownership of the Jenkins home directory to the Jenkins user (if needed)
chown -R jenkins:jenkins /var/jenkins_home

# Finally, start Jenkins using the official Jenkins start command
exec /sbin/tini -- /usr/local/bin/jenkins.sh
