# CI/CD Pipeline Project

This project demonstrates a complete CI/CD pipeline setup using Jenkins, Docker, and Kubernetes. The pipeline is divided into two main parts: Continuous Integration (CI) and Continuous Deployment (CD).

## Tools and Technologies Used

- **GitHub**: Version control and source code repository.
- **Maven**: Build automation tool for Java projects.
- **Docker**: Containerization platform.
- **Docker Hub**: Docker image repository.
- **Kubernetes**: Container orchestration platform.
- **Jenkins**: Automation server for CI/CD.

## CI Pipeline

The CI pipeline performs the following steps:
1. Cloning the Git repository.
2. Building the project using Maven.
3. Creating a Docker image.
4. Pushing the Docker image to Docker Hub.
5. Triggering the CD pipeline.

## CD Pipeline

The CD pipeline performs the following steps:
1. Cloning the Git repository.
2. Deploying the application using Kubernetes.

## Setup Instructions

### Jenkins Server Setup (Ubuntu EC2 Instance)

1. **Launch an Amazon EC2 Instance**
    - Instance Type: `t2.medium`
    - Connect to the instance using Mobaxterm/Putty

2. **Install Java**
    ```bash
    sudo apt install fontconfig openjdk-17-jre
    ```

3. **Install Jenkins**
    ```bash
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt-get install jenkins
    ```

4. **Start Jenkins**
    ```bash
    sudo systemctl start jenkins
    ```

5. **Install Maven**
    ```bash
    sudo apt install maven -y
    ```

6. **Setup Docker in Jenkins**
    ```bash
    curl -fsSL get.docker.com | /bin/bash
    sudo usermod -aG docker jenkins
    sudo systemctl restart jenkins
    ```

### Kubernetes Setup

1. **Create EKS Management Host**
    - Launch a new EC2 instance (`t2.micro`)
    - Install kubectl
    ```bash
    curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin
    ```
    - Install AWS CLI
    - Install eksctl

2. **Create IAM Role with the following permissions and Attach it to EKS Host**
    - IAM - full Access
    - VPC - full Access
    - EC2 - full Access
    - CloudFormation - full Access
    - Administrator - full Access

3. **Copy EKS Cluster Config File to Jenkins EC2 Instance**
    This is required to allow Jenkins to access our Kubernetes cluster.
    - Execute the following command on the EKS management host and copy the contents:
    ```bash
    cat .kube/config
    ```
    - Execute the following commands on the Jenkins server and paste the copied contents:
    ```bash
    cd ~
    ls -la
    sudo vi .kube/config
    ```

## Jenkins Pipeline Configuration

### CI Pipeline Job

1. Go to Jenkins dashboard, click on "New Item", and select "Pipeline".
2. Name the job `JAVA_WEB_APP_CI_JOB`.
3. Configure Git and Docker credentials as variables to ensure credentials are not exposed in the pipeline script.
4. In the pipeline script section, use the following script:
    ```groovy
    pipeline {
        agent any

        stages {
            stage('Git Clone') {
                steps {
                    git credentialsId: 'GIT-CREDENTIALS', url: 'https://github.com/asishpa/MAVEN-WEB-APP.git'
                }
            }
            stage('Maven Build') {
                steps {
                    sh 'mvn clean package'
                }
            }
            stage('Create Image') {
                steps {
                    sh "docker build -t asishdevops/maven-web-app ."
                }
            }
            stage('Push Image') {
                steps {
                    withCredentials([string(credentialsId: 'Docker-Acc-Pwd', variable: 'dockerpwd')]) {
                        sh "docker login -u <username> -p ${dockerpwd}"
                        sh "docker push asishdevops/maven-web-app"
                    }
                }
            }
            stage('Trigger CD') {
                steps {
                    build 'JAVA_WEB_APP_CD_JOB'
                }
            }
        }
    }
    ```

### CD Pipeline Job

1. Go to Jenkins dashboard, click on "New Item", and select "Pipeline".
2. Name the job `JAVA_WEB_APP_CD_JOB`.
3. In the pipeline script section, use the following script:
    ```groovy
    pipeline {
        agent any

        stages {
            stage('Git Clone') {
                steps {
                    git credentialsId: 'GIT-CREDENTIALS', url: 'https://github.com/asishpa/MAVEN-WEB-APP.git'
                }
            }
            stage('Deploy') {
                steps {
                    sh 'kubectl apply -f Deployment.yml'
                }
            }
        }
    }
    ```

### Running the CI Job

1. Go to the Jenkins dashboard and select `JAVA_WEB_APP_CI_JOB`.
2. Click on "Build Now".
3. The CI job will trigger the CD job upon successful completion.

## Conclusion

This setup provides a comprehensive CI/CD pipeline using Jenkins, Docker, and Kubernetes. The steps outlined above cover the process from setting up the Jenkins server to deploying the application on a Kubernetes cluster, ensuring a seamless integration and deployment process.
