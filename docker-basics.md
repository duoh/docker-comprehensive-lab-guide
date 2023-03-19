The first step checks if Docker is installed on the AWS Cloud9 workspace, download and run a standard container image of busybox.

1. Since Cloud9 already has docker engine installed, let's confirm if it is installed and working.
```sh
docker --version
```
##### Result Output
```
Docker version 20.10.17, build 100c701
```
Pull hello-world image and run it as a container instance
```sh
docker run hello-world
```
##### Result Output
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

>In case you would like to install Docker engine on other platforms, please refer to the [official guide](https://docs.docker.com/engine/install/).

2. Since Docker containers are built using images, let's run the command docker pull to fetch [BusyBox image](https://hub.docker.com/_/busybox) from Docker Hub.
```sh
docker pull busybox
```
##### Result Output
```
Using default tag: latest
latest: Pulling from library/busybox
4b35f584bb4f: Pull complete 
Digest: sha256:b5d6fe0712636ceb7430189de28819e195e8966372edfc2d9409d79402a0dc16
Status: Downloaded newer image for busybox:latest
docker.io/library/busybox:latest
```
Check if images that we pull in previous steps exist on local
```sh
docker images
```
##### Result Output
```
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
busybox       latest    7cfbbec8963d   2 days ago      4.86MB
hello-world   latest    feb5d9fea6a5   18 months ago   13.3kB
```

3. Let's run a Docker container based on Busybox image by the following command.
```sh
docker run busybox echo "hello from busybox"
```
##### Result Output
```
hello from busybox
```
Run the command with `-it` flags to attach an interactive tty in the container
```sh
$ docker run -it busybox sh
/ # ls
bin    dev    etc    home   lib    lib64  proc   root   sys    tmp    usr    var
/ # uptime
 07:54:00 up  2:26,  0 users,  load average: 0.06, 0.01, 0.00
```

4. After running docker run many times, it leaves stray containers and eats up disk space. So we can check local containers by running the following command.
```sh
docker ps -a
```
##### Result Output
```
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                       PORTS     NAMES
8c96a5104df9   busybox       "sh"                     5 minutes ago    Exited (127) 4 minutes ago             wonderful_shannon
0cc0275ba77c   busybox       "echo 'hello from bu…"   50 minutes ago   Exited (0) 50 minutes ago              optimistic_wing
cc377cbe6163   hello-world   "/hello"                 3 hours ago      Exited (0) 3 hours ago                 relaxed_hoover
```
Let's delete containers whose status is **Exited**. Copy the container IDs from *your recent output* and paste them alongside the following command

Ex.
```sh
docker rm 8c96a5104df9 0cc0275ba77c cc377cbe6163
```
Or use the following command to delete all stopped containers
```sh
docker rm $(docker ps -a -q -f status=exited)
```
Optionally, `docker container prune` can be used to acheive the same result
```sh
docker container prune
```

5. Typically a docker container is used to run as a long-running application like web application, reverse-proxy and etc. In this step we use nginx as a  static site.
```sh
docker run -d -p 8080:80 --name nginx nginx:latest
```
>The above command contains additional options as follows:
>-d option is to run a container in backgroup.
>
>-p option is to publish a container port(80) to the host(8080).
>
>--name option is to assign a name to a container.
>
>You can check further options by running `docker run --help`

Check if nginx is running by running
```sh
curl http://localhost:8080
```
Or clicking on Preview Running Application on Cloud9

[image]

To stop the running nginx container and delete the container, run the following command
```sh
docker stop nginx && docker rm nginx
```

6. Docker container can use [Volumes](https://docs.docker.com/storage/volumes/) to persist data. While bind mounts are dependent on the directory structure and OS of the host machine, volumes are completely managed by Docker.
We are going to create `index.html` to replace the default page of nginx.
```sh
echo "<h1>Hello from the host index file</h1>" > /home/ec2-user/environment/index.html
```
Run the following command to mount the index file from the host into the container 
```sh
docker run -d -p 8080:80 -v /home/ec2-user/environment/index.html:/usr/share/nginx/html/index.html:ro --name nginx nginx:latest
```
Verify if the result reflects from the previous change
```sh
curl http://localhost:8080
```
##### Result Output
```
<h1>Hello from the host index file</h1>
```
Let's clean up the first lab by stopping and deleting local containers.
```sh
docker stop nginx && docker rm nginx
```
Also delete local images by finding local images first
```sh
docker image ls
```
##### Result Output
```
REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
busybox       latest    7cfbbec8963d   2 days ago      4.86MB
nginx         latest    904b8cb13b93   2 weeks ago     142MB
hello-world   latest    feb5d9fea6a5   18 months ago   13.3kB
```
Then remove images on local
```sh
docker rmi nginx:latest hello-world:latest busybox:latest
```
Optionally, `docker image prune -a` can be used to acheive the same result
```sh
docker image prune -a
```
> -a option is to remove all unused images not just dangling ones.
