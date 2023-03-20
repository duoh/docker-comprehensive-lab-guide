A Dockerfile is a text file containing a list of commands that the Docker client calls while creating an image. It helps automate the image creation. 
1. To start creating a sample-nodejs container using a Dockerfile, let's create a new directory containing `index.js, package.json and Dockerfile`.
```sh
mkdir ~/environment/sample-nodejs
cd ~/environment/sample-nodejs
touch index.js package.json Dockerfile
```
Open each newly created empty file on Cloud9 and copy/paste in the following code to the corresponding files:

```index.js```
```
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello using dockerfile\n');
});

app.listen(port, () => {
  console.log(`Sample app listening at http://localhost:${port}`);
});
```

```package.json```
```
{
  "name": "sample_nodejs",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {},
  "author": "",
  "license": "ISC"
}
```

```Dockerfile```
```
FROM public.ecr.aws/docker/library/node:19.8
WORKDIR /srv
COPY . .
RUN npm install
EXPOSE 3000
CMD ["node", "index.js"]
```

>From the dockerfile, it starts with **FROM** instruction to specify a base image.
>
>The next instruction is **WORKDIR** to set a working directory on a container.
>
>**COPY** instruction is to copy specified files or directories to the container at target path.
>
>**RUN** instruction is used to execute a command on a container in this case to install packages defined in package.json.
>
>**EXPOSE** instruction informs Docker that a container listens on the specified network port.
>
>**CMD** instruction defines what command gets executed when running a container.
>
>There are few more instructions that can be used in Dockerfile, please refer to [Dockerfile reference](https://docs.docker.com/engine/reference/builder/).

2. Next we are going to build container image using the dockerfile created in the previous step.
```sh
docker build -t sample-nodejs .
```
##### Result Output
```
Sending build context to Docker daemon  4.096kB
Step 1/7 : FROM public.ecr.aws/docker/library/node:19.8
19.8: Pulling from docker/library/node
32fb02163b6b: Pull complete 
167c7feebee8: Pull complete 
d6dfff1f6f3d: Pull complete 
e9cdcd4942eb: Pull complete 
ca3bce705f6c: Pull complete 
4f4cf292bc62: Pull complete 
6fefd22bacd9: Pull complete 
b29db415cb2e: Pull complete 
adc76471ff8a: Pull complete 
Digest: sha256:2405a991a6d9f6ac1d991feefc0a4539d5187abd2ca532fd18f7185c98b32a45
Status: Downloaded newer image for public.ecr.aws/docker/library/node:19.8
 ---> ac779c6d4c57
Step 2/7 : WORKDIR /srv
 ---> Running in 9cfaa65f7ab7
Removing intermediate container 9cfaa65f7ab7
 ---> 6e2d191644ce
Step 3/7 : ADD package.json ./
 ---> 2447fd5f9aad
Step 4/7 : RUN npm install
 ---> Running in c67c64884ce5

added 57 packages, and audited 58 packages in 3s

7 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
npm notice 
npm notice New minor version of npm available! 9.5.1 -> 9.6.2
npm notice Changelog: <https://github.com/npm/cli/releases/tag/v9.6.2>
npm notice Run `npm install -g npm@9.6.2` to update!
npm notice 
Removing intermediate container c67c64884ce5
 ---> ba67efa99a79
Step 5/7 : ADD . .
 ---> 2ba9c940064a
Step 6/7 : EXPOSE 3000
 ---> Running in 23a013724713
Removing intermediate container 23a013724713
 ---> 81d1397f99a1
Step 7/7 : CMD ["node", "index.js"]
 ---> Running in 33c5dd10414b
Removing intermediate container 33c5dd10414b
 ---> a8a07af3f729
Successfully built a8a07af3f729
Successfully tagged sample-nodejs:latest
```
Check `sample-nodejs` image if it is avaiable
```sh
docker image ls
```
##### Result Output
```
REPOSITORY                           TAG       IMAGE ID       CREATED          SIZE
sample-nodejs                        latest    a8a07af3f729   21 seconds ago   1.01GB
public.ecr.aws/docker/library/node   19.8      ac779c6d4c57   2 days ago       999MB
```

Test if the containerized nodejs is working
```sh
docker run -d -p 8080:3000 sample-nodejs
curl localhost:8080
```
##### Result Output
```
Hello using dockerfile
```

3. As you can observe the image size of *sample-nodejs* is up to **1.01GB**, this is not suitable for running on production. In this step we are going to write a docker file applied best practices from [Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/).

Let's create a dockerfile
```sh
cd ~/environment/sample-nodejs
touch Dockerfile.prod
```
Open the newly created file
```Dockerfile.prod```
```sh
FROM public.ecr.aws/docker/library/node:19.8 AS build
WORKDIR /srv
ADD package.json ./
RUN npm install

FROM public.ecr.aws/docker/library/node:19.8-slim
RUN apt-get update && apt-get install -y \
  curl \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* && apt-get clean
COPY --from=build /srv .
ADD . .
EXPOSE 3000
CMD ["node", "index.js"]
```
Run docker build with the specified file.
```sh
docker build -f Dockerfile.prod -t sample-nodejs-prod .
```
After built successfully, check if `sample-nodejs-prod/latest` image is created.
```sh
docker image ls
```
##### Result Output
```
REPOSITORY                           TAG         IMAGE ID       CREATED          SIZE
sample-nodejs-prod                   latest      97a75a765809   2 seconds ago    255MB
<none>                               <none>      7c24918169fc   19 seconds ago   1.01GB
sample-nodejs                        latest      7da06b2e8498   53 seconds ago   1.01GB
public.ecr.aws/docker/library/node   19.8-slim   4cbcf0c0618a   3 days ago       249MB
public.ecr.aws/docker/library/node   19.8        ac779c6d4c57   3 days ago       999MB
```
> You could see the size of `sample-nodejs-prod` image is 4 times smaller than `sample-nodejs` one

Verify if the application is working
```sh
docker run -d -p 8090:3000 sample-nodejs-prod
curl localhost:8090
```
##### Result Output
```
Hello using dockerfile
```
Clean up all containers and images
```sh
docker stop $(docker ps -a -q -f status=running)
docker container prune
docker image prune -a
```
4. In this step we are going to use source code from (apprunner-hotel-app repository)[https://github.com/aws-samples/apprunner-hotel-app] to build a container image and push it onto (Amazon ECR)[https://aws.amazon.com/ecr/] for further use.

Clone repository onto Cloud9
```sh
cd ~/environment
git clone https://github.com/aws-samples/apprunner-hotel-app.git
cd apprunner-hotel-app/
touch Dockerfile
```
Open the newly created Dockerfile
`Dockerfile`
```
FROM public.ecr.aws/docker/library/node:19.8
WORKDIR /srv
COPY . .
RUN npm install
EXPOSE 8080
CMD ["npm", "start"]
```
Or use a lean version
```
FROM public.ecr.aws/docker/library/node:19.8 AS build
WORKDIR /srv
ADD package.json ./
RUN npm install

FROM public.ecr.aws/docker/library/node:19.8-slim
RUN apt-get update && apt-get install -y \
  curl \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* && apt-get clean
COPY --from=build /srv .
ADD . .
EXPOSE 8080
CMD ["npm", "start"]
```
