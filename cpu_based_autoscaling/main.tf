resource "aws_autoscaling_policy" "scale_out" {
  autoscaling_group_name = "${var.autoscaling_group_name}"
  name                   = "${var.autoscaling_group_name}-scale-out"
  scaling_adjustment     = "${var.scale_out_adjustment}"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
}

resource "aws_autoscaling_policy" "scale_in" {
  autoscaling_group_name = "${var.autoscaling_group_name}"
  name                   = "${var.autoscaling_group_name}-scale-in"
  scaling_adjustment     = "${var.scale_in_adjustment}"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name        = "${var.autoscaling_group_name}-cpu-utilization-high"
  alarm_description = "High CPU utilization on ${var.autoscaling_group_name}"

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  statistic   = "Average"

  dimensions {
    "AutoScalingGroupName" = "${var.autoscaling_group_name}"
  }

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "${var.scale_out_threshold}"
  period              = "${var.scale_out_period}"
  evaluation_periods  = "${var.scale_out_evaluation_periods}"

  ok_actions                = []
  alarm_actions             = ["${aws_autoscaling_policy.scale_out.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_utilization" {
  alarm_name        = "${var.autoscaling_group_name}-cpu-utilization-low"
  alarm_description = "Low CPU utilization on ${var.autoscaling_group_name}"

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  statistic   = "Average"

  dimensions {
    "AutoScalingGroupName" = "${var.autoscaling_group_name}"
  }

  comparison_operator = "LessThanOrEqualToThreshold"
  threshold           = "${var.scale_in_threshold}"
  period              = "${var.scale_in_period}"
  evaluation_periods  = "${var.scale_in_evaluation_periods}"

  ok_actions                = []
  alarm_actions             = ["${aws_autoscaling_policy.scale_in.arn}"]
  insufficient_data_actions = []
}
