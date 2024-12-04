resource "aws_launch_template" "main" {
  name = var.auto_scaler.name
  image_id        = "ami-016bf72b6069c1527"
  instance_type   = "t3.nano"
 // user_data       = templatefile("./data/amazon2.sh.tftpl")
  lifecycle {
      create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {
  depends_on = [ aws_launch_template.main ]
  min_size = var.auto_scaler.min_size
  desired_capacity = 1
  max_size  = var.auto_scaler.max_size
  launch_template {
    name = aws_launch_template.main.name
    version = "$Latest"
  }
  vpc_zone_identifier  = [for i in var.auto_scaler.subnet: var.subnet_ids[i]]
}
/*
resource "aws_autoscaling_attachment" "main" {
  count = length(var.auto_scaler.attachment)
  autoscaling_group_name = aws_autoscaling_group.main.id
  lb_target_group_arn   = var.target_group_arns[var.auto_scaler.attachment[count.index]]
}*/

resource "aws_autoscaling_policy" "bad" {
  depends_on = [ aws_autoscaling_group.main ]
  count = length(var.auto_scaler.bad_policies)
  name                   =var.auto_scaler.bad_policies[count.index] < 0 ? "scale_down_${aws_autoscaling_group.main.id}_${count.index}" : "scale_up_${aws_autoscaling_group.main.id}_${count.index}"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = var.auto_scaler.bad_policies[count.index]
  cooldown               = 60
}
resource "aws_autoscaling_policy" "ok" {
  depends_on = [ aws_autoscaling_group.main ]
  count = length(var.auto_scaler.ok_policies)
  name                   =var.auto_scaler.ok_policies[count.index] < 0 ? "scale_down_${aws_autoscaling_group.main.id}_${count.index}" : "scale_up_${aws_autoscaling_group.main.id}_${count.index}"
  autoscaling_group_name = aws_autoscaling_group.main.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = var.auto_scaler.ok_policies[count.index]
  cooldown               = 60
}

resource "aws_cloudwatch_metric_alarm" "main" {
  alarm_actions       = [ aws_autoscaling_policy.bad[0].arn]
  ok_actions = [aws_autoscaling_policy.ok[0].arn]
  depends_on = [aws_autoscaling_group.main]
  alarm_name          = "cpu_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 10
  statistic           = "Average"
  threshold           = 10
  treat_missing_data = "notBreaching"  
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }
}


#VARIABILI
variable "auto_scaler" {
  description = "variabile auto scaler"
  type = object({
    name = string
    min_size = number
    max_size = number
    security_group = list(string)
    subnet = list(string)
    attachment = list(string)
    bad_policies = list(number)
    ok_policies = list(number)
    cloud_watch_alarm = list(number)
  })
  default = {
    name = ""
    min_size =  0
    max_size = 0
    subnet = [""]
    security_group = [""]
    attachment = [ "" ]
    bad_policies = [0]
    ok_policies = [0]
    cloud_watch_alarm = [ 0 ]
  }
}

variable "security_group_ids" {
    description = "security_group_arns"
    type = map(string)
    default = {
      security_group = ""
    }
}

variable "target_group_arns" {
    description = "target_grop_arns"
    type = map(string)
    default = {
      target_grop_arns = ""
    }
}

variable "subnet_ids" {
    description = "subnet_ids"
    type = map(string)
    default = {
      subnet_id = ""
    }
}