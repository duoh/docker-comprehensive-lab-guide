# Deploy Infrastructure
While we can deploy simple applications directly to AWS App Runner, most practical applications would require some additional infrastructure to be setup. For example, the hotel application we are using today would at least require the network Infrastructure, security and access management, a database, and _a VPC Connector_
between the App Runner service and the database.

## Infrastructure overview

In this part of the workshop, we will setup the following infrastructure:
- A VPC with
  + Two Public subnets
  + Size Private subnets
  + An Internet Gateway
  + A NAT GAteway
- Security Groups
  + For the App Runner service allowing _egress traffic to the RDS database Security Group_
  + For the RDS database allowing _ingress traffic from the App Runner service Security Group_
  + For the Secret Manager rotation Lambda to connect to RDS
- A private RDS Aurora database
  + RDS database username & password stored in Secrets Manager with rotation enabled
- IAM Roles
  + ECR Access Role
  + App Runner Instance Role

We will walk you through the steps to create the _VPC Connector_ for App Runner and the RDS database later.

## Infrastructure as Code

For this workshop, we have prepared a CloudFormation Template _apprunner-workshop.yaml_ to create the infrastructure above. We will deploy it using AWS CLI in our Cloud9 Environment.

***_TODO_*** update repo / CFN template (we want to use our template)

```sh
cd ~/environment/apprunner-hotel-app

aws cloudformation deploy --template-file apprunner-workshop.yaml --stack-name app-runner-hotel --region ap-southeast-1 --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND
```

The deployment will begin and you will receive a confirmation when the deployment completes.

### Get the RDS secret ARN from Secret Manager

Once the deployment has completed, run the following command to retrieve the secret ARN:

```sh
aws secretsmanager list-secrets --output json --query 'SecretList[0].ARN' --output text
```

You should see an output similar to `arn:aws:secretsmanager:ap-southeast-1:667868124044:secret:AuroraDBSecret-XXXXXXXX`. Save the output in a safe place as we will need the value later.
