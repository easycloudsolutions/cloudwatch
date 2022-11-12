provider aws {
    region = "us-west-1"
    access_key = ""
    secret_key = ""
}

resource "aws_cloudwatch_dashboard" "EC2_Dashboard" {
  dashboard_name = "EC2-Dashboard"

  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "explorer",
            "width": 24,
            "height": 15,
            "x": 0,
            "y": 0,
            "properties": {
                "metrics": [
                    {
                        "metricName": "CPUUtilization",
                        "resourceType": "AWS::EC2::Instance",
                        "stat": "Maximum"
                    }
                ],
                "aggregateBy": {
                    "key": "InstanceType",
                    "func": "MAX"
                },
                "labels": [
                    {
                        "key": "State",
                        "value": "running"
                    }
                ],
                "widgetOptions": {
                    "legend": {
                        "position": "bottom"
                    },
                    "view": "timeSeries",
                    "rowsPerPage": 8,
                    "widgetsPerRow": 2
                },
                "period": 60,
                "title": "Running EC2 Instances CPUUtilization"
          }
        }
      ]
}
EOF
}

# resource "aws_cloudwatch_composite_alarm" "EC2_and_EBS" {
#   alarm_description = "Composite alarm that monitors CPUUtilization and EBS Volume Write Operations"
#   alarm_name        = "EC2_&EBS_Composite_Alarm"
#   alarm_actions = [aws_sns_topic.EC2_and_EBS_topic.arn]

#   alarm_rule = "ALARM(${aws_cloudwatch_metric_alarm.EC2_CPU_Usage_Alarm.alarm_name}) OR ALARM(${aws_cloudwatch_metric_alarm.EBS_WriteOperations.alarm_name})"


#   depends_on = [
#     aws_cloudwatch_metric_alarm.EC2_CPU_Usage_Alarm,
#     aws_cloudwatch_metric_alarm.EBS_WriteOperations,
#     aws_sns_topic.EC2_and_EBS_topic,
#     aws_sns_topic_subscription.EC2_and_EBS_Subscription
#   ]
# }


resource "aws_cloudwatch_metric_alarm" "EC2_CPU_Usage_Alarm" {
  alarm_name          = "EC2_CPU_Usage_Alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors ec2 cpu utilization exceeding 70%"
}


resource "aws_cloudwatch_metric_alarm" "EBS_WriteOperations" {
  alarm_name          = "EBS_WriteOperations"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "VolumeReadOps"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "1000"
  alarm_description   = "This monitors the average read operations on EBS Volumes in a specified period of time"
}


resource "aws_cloudwatch_log_group" "ebs_log_group" {
  name = "ebs_log_group"
}

resource "aws_cloudwatch_log_stream" "ebs_log_stream" {
  name           = "ebs_log_stream"
  log_group_name = aws_cloudwatch_log_group.ebs_log_group.name
}


data "aws_iam_policy_document" "route53-logging-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["rn:aws:logs:us-east-2:585584209241:log-group:route53_logs:*"]

    principals {
      identifiers = ["route53.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "route53-logging-policy" {
  policy_document = data.aws_iam_policy_document.route53-logging-policy.json
  policy_name     = "route53-logging-policy"
}
