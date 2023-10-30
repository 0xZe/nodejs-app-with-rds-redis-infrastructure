# nodejs-app-with-rds-redis-infrastructure
# The idea of the project is: 

The project is about:

      ➡️Creating an infrastructure pipeline to provision the project infrastructure modules 
         (vpc-network,instances,RDS-redis,load balancer) on AWS.

      ➡️Creating a jenkins pipeline to deploy a nodejs application in a private instance.

      ➡️The nodejs application is connected to a RDS to store data and 
         ElastiCache(redis) to provide managed in-memory caching for the application.

Because the application is on a private instance:

      ✅I used a bastion as a proxy (by creating ~/.ssh/config file) to run an ansible playbook which configures 
         the instance to work as a slave to the jenkins master.

      ✅I used JNLP(JAVA NETWORK LAUNCH PROTOCOL) to connect master with slave through execution of command 
         on the controller.

      ✅I used an application load balancer to expose the application.

# Project diagram

![nodejs-infra vpd (1)](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/120332c1-3c6e-4ae5-a750-3860fb196a7c)

# Steps:

## Step 1: Prerequisites

- `I customed jenkins image with terraform cause we will make an infrastructure pipeline by jenkins`
- `Jenkins image Docerfile is in`  `jenkins-Dockerfile`

## Step 2: Run container from the customed image to create the pipelines

![1](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/c713ff05-c747-40f5-9b76-6b5f8fb4fa5d)

## Step 3: Create a pipeline to provision the infrastructure

- `Infrastructure is provisioned through a parameterized jenkins pipeline to facilitate build and destroy the infrastructure`

![2](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/07242f24-4f8a-4543-a597-e58d4ce0e258)

## Infrastructure files consists of 4 modules:

  - `vpc-network module that provision vpc and subnets`
  - `instnces module that provision bastion and private application instance`
  - `rds-redis module that provision RDS and ElastiCache`
  - `load-balancer module that provision the load balancer`

- `Infrastructure Jenkinsfile is in` `terraform-modules-Jenkinsfile`

![3](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/22f9411a-d7fe-4df8-b69c-35cb04ace8c2)
![4](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/409a4320-c16d-4181-b257-58fc784080d6)

- `Infrastructure is provisioned and resources are created`

## Step 4: Install slave prerequisites and docker on the private instance

- `Private instance will be slave to the jenkins master so we will need install slave prerequisites(like jave) and make jenkins directory on it`
- `Also We will need docker on the private instance so we can deploy our nodejs application on it`

### A) Configure bastion

- `Because of application instance is private, we can't connect to it directly and install prerequisites on it`
- `So we must first configure a bastion or jump host to act as a proxy to run our commands on the instance through that bastion`
- `We will do that through creating a` `~/.ssh/config file` `in our master machine and put connection information in it`

![8](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/fd536bee-5d69-4a6f-a7a5-995e43959c3b)
![9](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/22f0a5bd-9a8c-46a8-9c90-13f5898cd3a1)

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

![5](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/16c52e07-53b5-40b6-87d8-f2507be6e122)

- `agent.jar is a java executable archive which contains procedure, library and utility for building a bridge between the layers`

- `Second, Run agent.jar on the slave(the private instance)`

![6](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/e23c94e6-1f21-4cac-a9c6-643aa06ddd5b)

- `Now the private instance is configured as a slave to the jenkins master and ready to run pipeline on it`

![7](https://github.com/0xZe/nodejs-application-with-rds-redis-infrastructure/assets/81789671/904fa7d2-a09d-47b1-866c-d9d2840152df)

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
