# Autoscaling on AWS App Runner
AWS App Runner service comes with autoscaling out of the box. This lab will show how to configure autoscaling, test it out, and observe the results.

## Autoscaling settings
In the AWS App Runner console click on the `apprunner-hotel-app` service

   ![assets](/assets/apprunner-hotel-service.png)

   select the "Configuration" tab

   ![assets](/assets/apprunner-hotel-config.png)

   and scroll down to view the default autoscaling settings:

   ![assets](/assets/apprunner-autoscaling.png)

A few things to note here:

- By default App Runner will send up to 100 concurrent requests to a single App Runner service instance. If concurrent traffic rises too high, then App Runner will automatically add new instances to distribute the traffic across.
- By default the service will scale all the way down to one instance, and all the way up to 25 instances.

You can select the "Edit" button at the top of the section to adjust these scaling behaviors.

Let's test out scaling now.

## Install hey

`hey` is a tiny program for sending load to a web server. We can plug in the URL of an AWS App Runner service and generate enough load to force it to scale up.

Run the following instructions to install hey in your Cloud9 environment:

```sh
curl https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64 -o hey
chmod +x hey
sudo mv hey /usr/bin/hey
```

## Run the load test
The following hey command maintains 200 concurrent HTTP requests for a 5 minute period. Find the URL of your service in the App Runner console.

```sh
hey -c 200 -z 5m https://xxxxxxxxxx.region.awsapprunner.com/
```
* `-c 200` - Send up to 200 concurrent requests
* `-z 5m` - Send requests for 5 minutes
* `https://xxxxxxxxxx.region.awsapprunner.com/` - The URL to send requests to

Once you press enter the program will start sending requests to your App Runner service.

## Check the service metrics.
Open the Metrics tab of your App Runner service, while hey is still running. The metric resolution is one minute, so you will need to wait a minute or two for any metrics to show up on this screen.

Two graphs to look out for are the "request count" graph and the "active instances" count.

The request count graph shows how many requests per minute the service handled: 

   ![assets](/assets/autoscale-req-count.png)

The active instances graph shows how many copies of the service spun up to handle that traffic. 

   ![assets](/assets/autoscale-instances.png)

Feel free to explore the metrics UI by clicking on the three dots next to a metric field and select “Enlarge” to view the metric in a larger window, or click “View in metrics” to explore the metrics in the Cloudwatch console.

## Ending the test
Make sure the hey command terminated in your terminal, cancel it with `Ctrl+C` if it is still running.

In the metrics tab of our App Runner service, the request count and the number of active instances should decrease in the next couple of minutes.

You can also review the output of hey to see how the service performed. For example:
```
Summary:
  Total:        301.9473 secs
  Slowest:      19.9923 secs
  Fastest:      0.0008 secs
  Average:      0.0596 secs
  Requests/sec: 4368.9313
  
  Total data:   203263502 bytes
  Size/request: 203 bytes

Response time histogram:
  0.001 [1]     |
  2.000 [992711]|■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
  3.999 [4014]  |
  5.998 [1708]  |
  7.997 [595]   |
  9.997 [482]   |
  11.996 [292]  |
  13.995 [67]   |
  15.994 [65]   |
  17.993 [9]    |
  19.992 [56]   |

```

From the summary we can see that the service handled 4368 requests per second, and the response time histogram shows that response times stayed low for most requests. There were a few outliers as the service scaled out.

You can try running an extended load test to see how response time stabilizes even further as the service operates at a steady state without needing to scale out on the fly.
