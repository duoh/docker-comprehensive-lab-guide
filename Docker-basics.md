In this step, you check if Docker is installed on the AWS Cloud9 workspace, and download and run a standard container image of busybox.

1. Since Cloud9 already has docker engine installed, let's confirm if it is installed and working.
```sh
$ docker --version
```
###### Result Output
```
Docker version 20.10.17, build 100c701
```
Pull hello-world image and run it as an instance
```sh
$ docker run hello-world
```
###### Result Output
```
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
2db29710123e: Pull complete 
Digest: sha256:ffb13da98453e0f04d33a6eee5bb8e46ee50d08ebe17735fc0779d0349e889e9
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

In case you would like to install Docker engine on other platforms, please refer to the [official guide](https://docs.docker.com/engine/install/).

2. Docker containers are built using images. Let's run the command docker pull to fetch [BusyBox image](https://hub.docker.com/_/busybox) from Docker Hub.
```sh
$ docker pull busybox
```
###### Result Output
```
Using default tag: latest
latest: Pulling from library/busybox
4b35f584bb4f: Pull complete 
Digest: sha256:b5d6fe0712636ceb7430189de28819e195e8966372edfc2d9409d79402a0dc16
Status: Downloaded newer image for busybox:latest
docker.io/library/busybox:latest
```
Check if images that we pull in previous steps exist on local.
```sh
$ docker images
```
###### Result Output
```
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
busybox       latest    7cfbbec8963d   2 days ago      4.86MB
hello-world   latest    feb5d9fea6a5   18 months ago   13.3kB
```

3. Let's now run a Docker container based on Busybox image. To do that we are going to use the almighty docker run command.
```sh
$ docker run busybox echo "hello from busybox"
```
###### Result Output
```
hello from busybox
```
Running `run` command with `-it` flags attach
