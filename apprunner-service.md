# Deploy to AWS App Runner

In this lab, we will deploy our containerized Hotel App to App Runner.

## Create a new App Runner Service

We start by creating a new App Runner service.

1. Navigate to the App Runner console to create a new service

   ![assets](/assets/navigate-to-apprunner.png)

2. Select **Create an App Runner Service**

   ![assets](/assets/apprunner-start.png)

3. Under, "Source and Deployment", select **Container registry** as the "Repository Type" and **ECR** as the "Provider"

   ![assets](/assets/apprunner-source-and-deployment.png)

   From there, click **Browse** to locate the "Container image URI"

   ![assets](/assets/apprunner-image-uri.png)

   Enter `apprunner-hotel-app` for the "Image repository" and `latest` for the "Image tag", and click **Continue**

4. Under "Deployment settings", select **Use existing service role** and select the pre-created `AppRunnerHotelAppECRAccessRole-ap-southeast-1`

   ![assets](/assets/apprunner-ecr-access-role.png)

   Then click **Next** to configure to the next screen.

5. On the Configure service screen, enter `apprunner-hotel-app` for the **Service name**

   ![assets](/assets/apprunner-service-name.png)

6. Enter two "Environment variables"

   - The first variable, select **Secrets Manager** as "Source" type.

     ![assets](/assets/apprunner-env-source-type.png)

     For "Environment variable name", enter `MYSQL_SECRET` and the _Secrets Manager secret ARN_ for the "Environment variable value" The _ARN_ can be retrieved from either:

     * On the secrets dettail screen in Secrets Manager

        ![assets](/assets/secrets-manager-secret.png)

     * From the Output of the CloudFormation stack we deployed

        ![assets](/assets/cfn-output-mysql-secret.png)

   - The secend variable, select **SSM Parameter Store** as "Source" type, enter `HOTEL_NAME` as the "Environment variable name", and the _SSM Parameter ARN_ for the "Environment variable value". The _ARN_ can be retrieved from the CloudFormation stack output

     ![assets](/assets/cfn-output-hotel-name.png)

   Here's the configured environment variables

   ![assets](/assets/apprunner-env-vars.png)

7. You can leave the default configuration under "Auto Scaling" and "Health check".

8. Under "Security", select `AppRunnerHotelAppRole-ap-southeast-1` as the **Instance role**

   ![assets](/assets/apprunner-instance-role.png)

## Create a VPC Connector

We will create a VPC endpoint for our App Runner service, called a _VPC Connector_ to associate our service with a VPC, and allow the hotel service to connect to its RDS instance.

9. Expand the "Networking section, select **Custom VPC** for "Outgoing network traffic", and click to **Add new** "VPC connector"

   ![assets](/assets/apprunner-custom-vpc.png)

10. Select our App Runner VPC.

    ![assets](/assets/vpc-connector-vpc.png)

    Select the VPC we created from the CloudFormation stack output

    ![assets](/assets/vpc-id.png)

11. Select the _Private Subnets_ in our App Runner VPC

    ![assets](/assets/vpc-connector-subnets.png)

    The private subnet IDs can be found in the VPC _Subnets_ console

    ![assets](/assets/vpc-subnets.png)

12. Select the `AppRunnerHotelApp-Service-SG` Security Group

    ![assets](/assets/vpc-connector-sg.png)

    Once done, click **Add** to add the VPC Connector

    ![assets](/assets/vpc-connector-add.png)

    And select the newly created VPC Connector for our App Runner service

    ![assets](/assets/vpc-connector.png)

## Turn on X-Ray and deploy App Runner Service

Next, we will enable X-Ray tracing before reviewing and deploying our service.

13. Under "Observability", turn on **Tracing with AWS X-Ray**

    ![assets](/assets/apprunner-x-ray.png)

    Then click **Next**

14. On the next screen, review and click **Create & deploy**

Once the service is deployed, we can click on the "Default Domain" to explore our service.

![assets](/assets/apprunner-deployed.png)

## Explore the deployed hotel app

Navigate to the hotel app.

![assets](/assets/hotel-app.png)

Click on **Create** to create the application schema in our RDS database. This also confirms that our application can successfully connect to its database.

![assets](/assets/hotel-app-create-schema.png)

Congratulation! We've successfully deployed our Hotel application on App Runner.
