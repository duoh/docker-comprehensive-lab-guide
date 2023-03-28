# Start the Workshop

The first thing we need to do is get into an AWS account provided by AWS that will be used for the rest of the workshop.

This workshop creates an AWS account. You will need the Participant Hash provided upon entry, and your email address to track your unique session.
1. Go to url https://dashboard.eventengine.run, enter the hash on the textbox and sign in with your email address

   ![assets](/assets/dashboard-run.png)

2. After signin, click on **AWS Console** to access AWS console

   ![assets](/assets/team-dashboard.png)

3. Navigate to https://github.com/duoh/docker-comprehensive-lab-guide and download `apprunner-workshop.yaml` onto your laptop

4. Go to [CloudFormation](https://ap-southeast-1.console.aws.amazon.com/cloudformation/home) and click on **Create stack**

   ![assets](/assets/cloudformation-step1.png)

   Click on **Choose file** and select the previous saved file, `apprunner-workshop.yaml` then click **Next**

5. Enter a **Stack name**, for example `apprunner-workshop`. Under **Parameters**, enter your preferred _HotelName_ parameter, for example `AWS App Runner Hotel` (it can be any arbitrary text). Then click **Next**, and click **Next**

   ![assets](/assets/cloudformation-step2.png)

6. On the last step, scroll down to bottom of the page and _check all checkboxes_, then click **Next**

   ![assets](/assets/cloudformation-step4.png)

7. Wait until the CloudFormation stack is created _successfully_ as shown below

   ![assets](/assets/cloudformation-complete.png)

8. The below arechitecture is the AWS environment created, in which we are going to use throughout this workshop

   ![assets](/assets/aws-env-setup.png)

9. Go to [Cloud9](https://ap-southeast-1.console.aws.amazon.com/cloud9control/home), you will see **apprunnerworkshop**. Click on **Open** to access the Cloud9 IDE

   ![assets](/assets/cloud9-home.png)

10. Close the Welcome page then press the green plus **+** button and select **New Terminal**

    ![assets](/assets/cloud9-ide.png)

11. Click on _the gear icon_ to go to **Preferences**. Select **AWS Settings**, and _turn off_ **AWS managed temporary credentials**

    ![assets](/assets/cloud9-preference.png)

    ![assets](/assets/cloud9-aws-credentials.png)
