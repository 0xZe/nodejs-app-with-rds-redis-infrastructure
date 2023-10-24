#custom jenkins image with terraform, docker client, AWS CLI, Ansible and kubectl
FROM jenkins/jenkins:lts
USER root

#install terraform
RUN curl -O https://releases.hashicorp.com/terraform/0.15.0/terraform_0.15.0_linux_amd64.zip && unzip terraform_0.15.0_linux_amd64.zip -d /usr/local/bin/
USER ${user}

#install ssh
RUN apt-get update -qq
RUN apt-get install openssh-client -qq