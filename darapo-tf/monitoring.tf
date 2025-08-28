# CloudWatch 로그 그룹 (애플리케이션 로그용)
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "darapo-${var.env}-app-logs"
  retention_in_days = 7

  tags = {
    Name = "darapo-${var.env}-app-logs"
  }
}

# SNS 토픽 for 알람
resource "aws_sns_topic" "alarms" {
  name = "darapo-${var.env}-alarms"
}

# SNS 구독 (이메일)
resource "aws_sns_topic_subscription" "alarms_email" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# CloudWatch 알람들
resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  alarm_name          = "darapo-${var.env}-status-check-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "EC2 Status Check Failed"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    InstanceId = aws_instance.app.id
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = "darapo-${var.env}-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "CPU Utilization > 80%"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    InstanceId = aws_instance.app.id
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization" {
  alarm_name          = "darapo-${var.env}-memory-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Memory Utilization > 80%"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    InstanceId = aws_instance.app.id
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_utilization" {
  alarm_name          = "darapo-${var.env}-disk-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  alarm_description   = "Disk Utilization > 85%"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    InstanceId   = aws_instance.app.id
    path         = "/"
    device       = "xvda1"
    fstype       = "ext4"
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance" {
  alarm_name          = "darapo-${var.env}-cpu-credit-balance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "10"
  alarm_description   = "CPU Credit Balance < 10"
  alarm_actions       = [aws_sns_topic.alarms.arn]

  dimensions = {
    InstanceId = aws_instance.app.id
  }
}
