# CloudWatch Deployment
Testing the automated deployment of cloudwatch with Terraform

Automatically deploys an explorer widget on the CloudWatch dashboard, a log group, and different metric alarms. Some of these do not show up in the dashboard widgets,
but show up on the separate tabs.

### TESTING

1. Write in access key and secret key from Security Credentials in AWS under providers.
2. Create test ec2 instance to see data on CloudWatch Dashboard.
3. In console where the code is type: <br>
  terraform init <br>
  terraform apply --auto-approve
4. When finished: <br>
  terraform destroy --auto-approve
