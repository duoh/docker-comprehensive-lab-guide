# Observability with AWS X-Ray and Cloud Watch
[AWS X-Ray](https://aws.amazon.com/xray) is a distributed tracing service that helps you trace the lifecycle of a transaction as it flows through your application code, from incoming request, to downstream API calls, to returning a response to clients.

We already configured AWS X-Ray in the previous segment when we created our App Runner Hotel Service.

Open up the X-Ray service map to see traces that have been collected.

[AWS X-Ray Service Map](https://console.aws.amazon.com/cloudwatch/home?#xray:service-map/map)

You should see something like this on the service map:

![assets](/assets/xray.png)

Congratulations! You now have configured observability for your App Runner service using AWS X-Ray and Cloud Watch!
