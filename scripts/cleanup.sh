#!/bin/bash

cleanupCopilot() {
    cd ~/environment/apprunner-copilot-example
    copilot app delete
}

cleanupAppRunner() {
    getServiceArn=$(aws apprunner list-services --query 'ServiceSummaryList[*].ServiceArn' --output text)

    for arn in $getServiceArn 
    do
        if [[ $arn =~ "simple-express" || $arn =~ "apprunner-hotel-app" ]];
        then
            aws apprunner delete-service --service-arn $arn >/dev/null && echo "$arn deleted"
        else
            echo "$arn untouched"
        fi
    done
}

cleanupInfra() {
    aws cloudformation delete-stack --stack-name app-runner-hotel
}

cleanupECR() {
    aws ecr delete-repository --repository-name simple-express-repository --force >/dev/null && echo "$repo deleted"
}

cleanupCloudwatch() {
    getLogGroupName=$(aws logs describe-log-groups --query 'logGroups[*].logGroupName' --output text)

    for logs in $getLogGroupName
    do
        if [[ $getLogGroupName =~ "/aws/apprunner/simple-express" || "/aws/apprunner/apprunner-hotel-app" || "/aws/apprunner/hit-counter-app-test-hit-counter-service" ]];
        then
            aws logs delete-log-group --log-group-name $logs >/dev/null && echo "$logs deleted"
        else
            echo "$logs untouched"
        fi
    done
}

cleanupCopilot
cleanupAppRunner
cleanupInfra
cleanupECR
cleanupCloudwatch
