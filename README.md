# nodejs-app-with-rds-redis-infrastructure
# The idea of the project is: 
- `Create jenkins infrastructure pipeline to provision infrastructure (RDS-redis) on AWS` 
- `Create another pipeline to Deploy a nodejs application which connect to RDS and redis on a private instance`
- `Expose the nodejs application from the private instance by a load balancer`

# Project diagram

![nodejs-infra vpd (1)](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/120332c1-3c6e-4ae5-a750-3860fb196a7c)

# Steps:

## Step 1: Prerequisites

- `I customed jenkins image with terraform cause we will make an infrastructure pipeline by jenkins`
- `Jenkins image Docerfile is in`  `jenkins-Dockerfile`

## Step 2: Run container from the customed image to create the pipelines

![1](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671c0e8f359-b27a-41e1-83a6-70a085ea3345)

## Step 3: Create a pipeline to provision the infrastructure

- `Infrastructure is provisioned through a parameterized jenkins pipeline to facilitate build and destroy the infrastructure`

![2](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/817896710c4061da-c489-4c45-bc7c-7e4dcf0396fb)

## Infrastructure files consists of 4 modules:

 - `vpc-network module that provision vpc and subnets`
 - `instnces module that provision bastion and private application instance`
 - `rds-redis module that provision RDS and ElastiCache`
 - `load-balancer module that provision the load balancer`

- `modules Iac files is in` `modules` 
- `Infrastructure Jenkinsfile is in` `modules-Jenkinsfile`

![3](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671260e48e1-f077-4e15-b1a0-3ce481c104f4)
![4](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/817896714a960549-0a86-4dda-a75b-edfce2a1f0f1)

- `Infrastructure is provisioned and resources are created`

## Step 4: Install slave prerequisites and docker on the private instance

- `Private instance will be slave to the jenkins master so we will need install slave prerequisites(like jave) and make           jenkins directory on it`
- `Also We will need docker on the private instance so we can deploy our nodejs application on it`

### A) Configure bastion

- `Because of application instance is private, we can't connect to it directly and install prerequisites on it`
- `So we must first configure a bastion or jump host to act as a proxy to run our commands on the instance through that bastion`
- `We will do that through creating a` `~/.ssh/config file` `in our master machine and put connection information in it`

![8](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/817896718df3c1c4-b45d-4e67-bd40-6f6e5e56c2c6)
![9](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/8178967135061440-39c8-4bef-bf0b-2a54219bd6ee)

- `Now We can run any commands in the private instance through the bastion`

### b) Install slave prerequisites and docker 

- `I made ansible playbook to install slave prerequisites and docker on the instance`
- `inventory file contains private ip of the instance`
- `slave-playbook.yml playbook` `is in` `Ansible-slave-playbook`

![10](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/04203cd5-294f-4f58-9ea8-642ede87f001)
![11](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/17366d75-ee7c-4d21-b524-ead141ea5df7)

## Step 5: Configure the private instance as a slave in the jenkins dashboard to run pipeline on it
## LAUNCH AGENT VIA EXECUTION OF COMMAND ON THE CONTROLLER

- `Because of our instance is private we can't connect it to the master using ssh directly`
- `Another way to connect Master with Slave is using JNLP(JAVA NETWORK LAUNCH PROTOCOL) protocol which makes allow the communication between two nodes`

- `To use this method we need: `

- `First, Download the agent.jar file from the Jenkins master machine to the slave machine`
![5](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/8178967181789090-5675-44a7-9629-1f1cf1f8b2ed)
- `agent.jar is a java executable archive which contains procedure, library and utility for building a bridge between the layers`

- `Second, Run agent.jar on the slave(the private instance)`
![6](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671048ff891-636c-4bc9-a977-3408188c5ae6)

- `Now the private instance is configured as a slave to the jenkins master and ready to run pipeline on it`
![7](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/817896714308dd63-0cfb-4a56-8fc9-b8f989396043)

## Step 6: Create a pipeline on the private instance to Deploy the nodejs application on it

- `nodejs application files is on` [Project](https://github.com/mahmoud254/jenkins_nodejs_example/tree/rds_redis) 
- `We will create a pipeline to build our application and deploy it on the private instance(slave)`

![12](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/fa275b9d-047d-4cbf-93f2-58df85a99288)

- `application Jenkinsfile is on` `nodejs-app-Jenkinsfile`

- `Stages of application pipeline is:`
    - `login to dockerhub to push nodejs application image after build it`
    - `Pull project files from the github repo`
    - `Build the aplication image then push it to dockerhub`
    - `Deploy the application image and pass RDS and redis environmental variables to it`
  
![13](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/4de0268d-bbcc-4a65-921f-aeff6264e762)
![14](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/adb7ee33-e2b2-4607-8367-cab320ea166a)

## Step 7:  Test application by calling loadbalancer_url/db and loadbalancer_url/redis

![16](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/016f9003-3550-4137-be15-df53615d8d94)
![15](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/aa412031-4db1-4eb0-932b-09adeabe1ae7)