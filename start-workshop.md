The first thing we need to do is get into an AWS account provided by AWS that will be used for the rest of the workshop.

This workshop creates an AWS account. You will need the Participant Hash provided upon entry, and your email address to track your unique session.
1. Go to url https://dashboard.eventengine.run, enter the hash on the textbox and sign in with your email address
[dashboard-run]

2. After signin, click on **AWS Console** to access AWS console
[team-dashboard]

3. Navigate to https://github.com/duoh/docker-comprehensive-lab-guide and download `apprunner-workshop.yaml` onto your laptop

4. Go to [CloudFormation](https://ap-southeast-1.console.aws.amazon.com/cloudformation/home) and click on **Create stack**
[cloudformation-step1]

Click on **Choose file** and select the previous saved file, `apprunner-workshop.yaml` then click **Next**

5. Input text as follows (it can be any arbitrary text) then click **Next** and click **Next**
[cloudformation-step2]

6. Last step scroll down to bottom page and click all checkboxes then click **Next**
[cloudformation-step4]

7. Wait until it shows successfully as below
[cloudformation-complete]

8. The below arechitecture is AWS environment we are going used through this workshop.
[aws-env-setup]

9. Go to [Cloud9](https://ap-southeast-1.console.aws.amazon.com/cloud9control/home), you would see **apprunnerworkshop**.
Click on **Open** to access Cloud9 IDE
[cloud9-home]

10. Close the Welcome page then press the green plus **+** button and select **New Terminal**
[cloud9-ide]
