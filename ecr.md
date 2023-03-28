# ECR

Now that we have a working Docker image, let's tag and push the image to [Elastic Container Registry (ECR)](https://aws.amazon.com/ecr). ECR is a fully-managed Docker container registry that makes it easy to store, manage, and deploy Docker container images.

## Create an ECR Repository

1. In the AWS Management Console, navigate to Amazon ECR.

   ![assets](/assets/navigate-to-ecr.png)

   Click on **Get Started** to create a repository.

   ![assets](/assets/ecr.png)

2. Create an ECR repository `apprunner-hotel-app`. Under Image scan setting, _enable_ **Scan on push**, and _enable_ **KMS encryption**.

   ![assets](/assets/ecr-create-repository.png)

3. Once the repository is created, select the repository and click **View push commands**

   ![assets](/assets/ecr-select-repo.png)

   You'd see the commands to _authenticate_, _tag_, and _push_ your container immages to the ECR repository.

   ![assets](/assets/ecr-push-commands.png)


## Tag and push your container image to the ECR repository

In your Cloud9 environment, follow the instructions from the push commands.

1. Authenticate your Docker client to your registry

   ***Substitute the command below with the appropriate ECR repository in your account***

   ```sh
   aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 060162107818.dkr.ecr.ap-southeast-1.amazonaws.com
   ```

2. Tag your `apprunner-hotel` image built in the previous section

   ***Substitute the command below with the appropriate ECR repository in your account***

   ```sh
   docker tag apprunner-hotel:latest 060162107818.dkr.ecr.ap-southeast-1.amazonaws.com/apprunner-hotel-app:latest
   ```

3. Push the image to ECR

   ***Substitute the command below with the appropriate ECR repository in your account***

   ```sh
   docker push 060162107818.dkr.ecr.ap-southeast-1.amazonaws.com/apprunner-hotel-app:latest
   ```

   Here's sample output from these commands:
   ```
   TeamRole:~/environment/apprunner-hotel-app (main) $ docker tag apprunner-hotel:latest 060162107818.dkr.ecr.ap-southeast-1.amazonaws.com/apprunner-hotel-app:latest
   TeamRole:~/environment/apprunner-hotel-app (main) $ docker image ls
   REPOSITORY                                                              TAG         IMAGE ID       CREATED       SIZE
   060162107818.dkr.ecr.ap-southeast-1.amazonaws.com/apprunner-hotel-app   latest      cc7c0673d92e   7 hours ago   391MB
   apprunner-hotel                                                         latest      cc7c0673d92e   7 hours ago   391MB
   <none>                                                                  <none>      ad9f0ad927b1   7 hours ago   1.18GB
   public.ecr.aws/docker/library/node                                      19.8-slim   9fd6db1a78c9   4 days ago    249MB
   public.ecr.aws/docker/library/node                                      19.8        0e0ab07dbedd   4 days ago    999MB
   ```
   ```sh
   TeamRole:~/environment/apprunner-hotel-app (main) $ docker push 060162107818.dkr.ecr.ap-southeast-1.amazonaws.com/apprunner-hotel-app:latest
   The push refers to repository [060162107818.dkr.ecr.ap-southeast-1.amazonaws.com/apprunner-hotel-app]
   6627ef6cb229: Pushed 
   a2a9b56875d5: Pushed 
   17cd3fd68f26: Pushed 
   823df5be5df5: Pushed 
   4afc1da4fc0a: Pushed 
   ead72cea52d6: Pushed 
   aac612aafc21: Pushed 
   3af14c9a24c9: Pushed 
   latest: digest: sha256:0f3f92f3150e39cbddcc6f5f966317012049cd119a285d9706a049ff2c0049db size: 2001
   ```

   If you refresh the ECR repository page in the console, you'll see a new image uploaded and tagged as latest.

   ![assets](/assets/ecr-image.png)
