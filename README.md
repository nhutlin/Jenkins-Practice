# E-Commerce Web Application using MERN Stack and Microservices Architecture

## Description
This is a web application for an e-commerce store that sells games. It is built using the MERN stack and Microservices Architecture. It has a user interface for the customers to view the products and add them to their cart. The application is built using the Microservices Architecture, where each service is a separate Node.js application.

## Before go to next step
Use this command to generate private and public key
```bash
ssh-keygen -t ed25519
```
Then fill the access key and secret key of AWS account to path `.aws/credentials` (profile default)
```bash
[default]
aws_access_key_id=
aws_secret_access_key=
aws_session_token=
```
## Usage

### Create Jenkins Master-Slave server and SonarQube server

1. Go to terraform folder and run terraform command below:
```bash
# At Jenkins root folder
cd terraform/jenkins
terraform init
terraform plan
terraform apply
cd ../sonarqube/
terraform init
terraform plan
terraform apply

# 3 instance will be created: Jenkins-Server, Jenkins-Slave, SonarQube
```

2. Create Jenkins Master-Slave connection
    - Go to the dashboard Jenkins Server and install plugin. This URL seem will be: http://<IP_of_Jenkins_Server>:8080
    - Click to Manage Jenkins -> Nodes -> New Node, create name node and config as below then click `Save`.
    - Jenkins will create a script which run at Jenkins Slave.
```bash
echo <key> > secret-file
curl -sO http://<IP_of_Jenkins_Server>:8080/jnlpJars/agent.jar
java -jar agent.jar -url http://<IP_of_Jenkins_Server>:8080/ -secret @secret-file -name node -webSocket -workDir "/opt/build"
```
After run this script, Jenkins Slave will be connected to Jenkins Master.

3. Create webhook
    - Go to GitHub and click to `Settings` -> `Developer Settings` -> `Personal access tokens` -> `Tokens` -> `Generate new token` or use the already exist token.
    - Then go to the Jenkins repository -> `Settings` -> `Webhooks` -> `Add webhook`. Then use this url to connect Jenkins: `http://<IP_of_Jenkins_Server>:8080/github-webhook/`.
    - Go to SonarQube server with url: `http://<IP_of_SonarQube_Server>:9000`. Login and create new project (This step will create a token, use it later).
    - At SonarQube, go to `Administration` -> `Configuration` -> `Webhooks`. Then create a webhook with url: `http://<IP_of_Jenkins_Server>:8080/sonarqube-webhook/`.
    - Go to Jenkins and create crendential with username and password. Username is username GitHub account and password is token of GitHub account.

### Create resource for application
1. Create MongoDB Atlas
    - Log in to MongoDB Atlas
    - Deploy a New Cluster
        + Within your project, click the `Build a Database` button.
        + Select the `Shared Clusters option` (free tier) or other plans depending on your needs.
        + Choose the following settings:
        ```bash
        Cloud Provider & Region: Select the provider (AWS, GCP, or Azure) and region closest to your application or user base.
        Cluster Tier: Select a cluster tier (e.g., M0 Sandbox for free tier).
        Additional Settings: Configure storage and backup settings if needed.
        ```
    - Name your cluster (default: Cluster0).
    - Click `Create Cluster`.
    - Modify source code to connect MongoDB at file `config/db_conn.js` at each service folder:

```bash
mongoose.connect(`mongodb+srv://${mongo_username}:${mongo_password}@${mongo_cluster}/${mongo_database}?retryWrites=true&w=majority`
, { useNewUrlParser: true, useUnifiedTopology: true })
.then(() => console.log(`Connected to: ${mongoose.connection.name}`))
.catch(err => console.log(err));
```

2. Create repository on AWS ECR
    - Login to AWS Console.
    - Go to Elastic Container Registry service.
    - Click `Create` and named new repository.
    - Then put the Access Key and Secret Key to Jenkins AWS Credential Plugin (named `ecr-demo-credential`) 

### Create connections
1. Connect GitHub to Jenkins
    - At Jenkins, click `New item` to create new pipeline. Create name of pipeline and click `Pipeline` option then click `OK`
    - Next step, choose `GitHub hook trigger for GITScm polling` at `Build Triggers`
    - Select `Pipeline script from SCM` then fill Repository URL with Jenkins repository link. Example: `https://github.com/nhutlin/Jenkins-Practice.git`
    - Credentials: use credential at previous step.
    - Choose the branch to run pipeline. Then click `Save` and new pipeline will be created.
    - Click `Build Now` at the first build. After that, when the code push to GitHub, Jenkins will build automatically.

2. Connect Jenkins to SonarQube
    - At Jenkins, click `Manage Jenkins` -> `Tools`. At `SonarQube Scanner installations`, click `Install automatically`.
    - Go to `Manage Jenkins` -> `System`. At `SonarQube servers`, fill `Name` (named `Sonar`), `Server URL` (http://<IP_of_SonarQube_Server>:9000), `Server authentication token` (use token of project that created in previous step).

3. Create Trivy credential

Go to Credential at Jenkins, create new credential with secret text type, then paste the GitHub access token to this credential (named `github-trivy`).

### Create Environment

Go to `Manage Jenkins` -> `System`. At `Environment variables`, list key-value of enviroment that services are using. (`ACCESS_TOKEN`, `AWS_ACCOUNT_ID`, `MONGO_CLUSTER`, `MONGO_DBNAME_CART`, `MONGO_DBNAME_PRODUCT`, `MONGO_DBNAME_USER`, `MONGO_PASSWORD`, `MONGO_USERNAME`).

### Run pipeline
1. Push code to GitHub. Then the pipeline will run automatically.
2. Jenkins will test code, build images, push images and scan images.
3. After `SUCCESS`, go to the service front-end with URL: http://<IP_of_Jenkins_Server>:5173/login to check or use command `docker ps` on Jenkins Server.

## Reference

Fork from: https://github.com/Andrewaziz99/E-Commerce_Web_Application.git 

https://www.jenkins.io/doc/book/installing/

https://github.com/tuan-devops/awesome-compose

https://docs.sonarsource.com/sonarqube-server/10.4/setup-and-upgrade/install-the-server/installing-sonarqube-from-docker/

https://medium.com/@dksoni4530/jenkins-master-slave-architecture-setup-f0486fba8039 

https://achraf-nhaila.medium.com/boosting-devops-security-a-beginners-guide-to-integrating-trivy-with-jenkins-3c25e44bad06 

https://registry.terraform.io/providers/hashicorp/aws/latest/docs

## Products json file
- [Products json file](https://github.com/Andrewaziz99/E-Commerce_Web_Application/blob/main/products.json)

## Technologies
- [React vite](https://vitejs.dev/)
- [Node.js](https://nodejs.org/en/)
- [Express](https://expressjs.com/)
- [MongoDB](https://www.mongodb.com/)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Microservices Architecture]()
