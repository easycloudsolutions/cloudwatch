# CloudWatch Deployment
Testing the automated deployment of cloudwatch with Terraform

Automatically deploys an explorer widget on the CloudWatch dashboard, a log group, and different metric alarms. Some of these do not show up in the dashboard widgets,
but show up on the separate tabs.

### Testing

1. Write in access key and secret key from Security Credentials in AWS under providers.
2. Create test ec2 instance to see data on CloudWatch Dashboard.
3. In console where the code is type: <br>
  terraform init <br>
  terraform apply --auto-approve
4. When finished: <br>
  terraform destroy --auto-approve

## From ChatGPT
This Terraform configuration creates several AWS resources:

An Amazon CloudWatch dashboard named "EC2-Dashboard" with a single widget that displays the maximum CPU utilization of running EC2 instances, grouped by instance type.

Two Amazon CloudWatch metric alarms:

"EC2_CPU_Usage_Alarm" which triggers when the average CPU utilization of EC2 instances is greater than or equal to 70% over a period of 2 evaluation periods (2 * 60 seconds).
"EBS_WriteOperations" which triggers when the average number of read operations on EBS volumes is greater than or equal to 1000 over a period of 2 evaluation periods (2 * 120 seconds).
A CloudWatch log group named "ebs_log_group" and a log stream named "ebs_log_stream" within that log group.

An IAM policy document named "route53-logging-policy" that allows logging to the specified CloudWatch log group.

An IAM policy named "route53-logging-policy" that is created from the policy document above.

An IAM role named "route53-logging-role" that is associated with the IAM policy above.

A Route 53 hosted zone named "example.com".

An SNS topic named "EC2_and_EBS_topic" that will be used as an alarm action for the CloudWatch metric alarms.

An SNS subscription named "EC2_and_EBS_Subscription" that subscribes to the SNS topic above and sends notifications to an email address.

An S3 bucket named "route53-logging-bucket" that is used to store logs.

An S3 bucket policy named "route53-logging-bucket-policy" that allows the specified IAM role to access the S3 bucket for logging.

A Route 53 query logging configuration that enables logging of DNS queries for the hosted zone and stores logs in the specified S3 bucket.

Note: The code block for the aws_cloudwatch_composite_alarm resource is commented out and is not being used in this configuration. A composite alarm is a single CloudWatch alarm that is based on the result of one or more other CloudWatch alarms. It allows you to set a single alarm that monitors multiple resources or metrics and that sends a notification when any of the alarms are in a breached state.
