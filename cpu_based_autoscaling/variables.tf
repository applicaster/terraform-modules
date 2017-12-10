variable "autoscaling_group_name" {}

variable "scale_out_threshold" {
  description = "Average CPU (precent) afterwhich a scale out will happen"
  default     = 70
}

variable "scale_out_adjustment" {
  description = "Number of instances to open when scaling out"
  default     = 6
}

variable "scale_out_period" {
  description = "Time period in second for scale out checks"
  default     = 60
}

variable "scale_out_evaluation_periods" {
  description = "Number of evaluation periods in order for scale out to kick"
  default     = 2
}

variable "scale_in_threshold" {
  description = "Average CPU (precent) afterwhich a scale in will happen"
  default     = 50
}

variable "scale_in_adjustment" {
  description = "Number of instances to close when scaling in"
  default     = -3
}

variable "scale_in_period" {
  description = "Time period in second for scale in checks"
  default     = 60
}

variable "scale_in_evaluation_periods" {
  description = "Number of evaluation periods in order for scale in to kick"
  default     = 5
}
