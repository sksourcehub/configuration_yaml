# Jenkins CI/CD pipeline with ansible

## Steps

### 1 - Build New Docker Image on every push to github repo

-  Create a pipeline 
-  Choose build trigger (poll SCM) and add * * * * * (for checking changes every min)
-  Now in Advance project Option choose pipeline script
-  Add the below:
```
pipeline{
    agent any
    environment {
        dockerImage = ''
        //once you sign up for Docker hub, use that user_id here
        registry = "<Docker_registry>"
        //- update your credentials ID after creating credentials for connecting to Docker Hub
        registryCredential = 'docker_id'
    }
    stages{
        stage('Cloning git'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/<Branch>']], extensions: [], userRemoteConfigs: [[credentialsId: 'github_id', url: '<Github_repo_url>']]])
            }
        }
        // Building Docker images
        stage('Building image') {
            steps{
                script {
                dockerImage = docker.build registry
                }
            }
        }
        // Uploading Docker images into Docker Hub
        stage('Upload Image') {
            steps{    
                script {
                    docker.withRegistry( '', registryCredential ) {
                    dockerImage.push()
                    }
                }
            }
        }
    }
}
```
-  Now create credential for docker(give docker_id as id of the credential)  to connect to the docker hub to access private registry
-  Also create credential for github (give github_id as id of the credential)

```
Note: Dont forget to change the Docker registry name, github repo URL and the branch
```

### 2 - Update the cluster using ansible playbook

-  Create another pipeline
-  For continues build, In build trigger choose < Build after other project are build >
-  Give the previous pipeline name and choose < Trigger only if build is stable >
-  Now in Advance project Option choose pipeline script
-  Add the below:

```
pipeline {
    agent any
   stages {
         stage('Cloning Git') {
            steps {
                checkout([
                    $class: 'GitSCM', branches: [[name: '*/<Branch_name>']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [], submoduleCfg: [], 
                    userRemoteConfigs: [[credentialsId: '', url: '<Github_repo_url>']]
                    ])       
            }
        }


        stage('trigger ansible'){
           steps{
                ansiblePlaybook credentialsId: '<ansiblePlaybook credentialsId>', disableHostKeyChecking: true, installation: 'myansible', inventory: 'hosts.inv', playbook: 'ansible.yaml'
           }
        }
   }

}
```

- Next step will be creating a github repo and push the content of ansible folder
- Create a ssh credential for the ansible (to ssh to the machine to rollout new deployment)

```
Note: Dont foget to change the git branch and repo in the cloning git step, also change the ansiblePlaybook credentialsId to you crediantial id 
```
