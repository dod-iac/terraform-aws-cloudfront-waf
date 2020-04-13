variable "allowed_hosts" {
  description = "List of allowed values for the host header."
  type        = list(string)
}

variable "aws_waf_byte_match_set_allowed_hosts_name" {
  description = "The name of the aws_waf_byte_match_set used by the rule used for filtering by host header.  Defaults to \"[name]-allowed-hosts\"."
  type        = string
  default     = ""
}

variable "aws_waf_rule_allowed_hosts_name" {
  description = "The name of the rule used for filtering by host header.  Defaults to \"[name]-allowed-hosts\"."
  type        = string
  default     = ""
}

variable "aws_waf_rule_allowed_hosts_metric_name" {
  description = "The metric name of the rule used for filtering by host header.  Defaults to \"[metric_name]AllowedHosts\"."
  type        = string
  default     = ""
}

variable "name" {
  description = "The name or description of the web ACL."
  type        = string
}

variable "metric_name" {
  description = "The name or description for the Amazon CloudWatch metric of this web ACL."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the WAF Web ACL Resource and WAF Rules."
  default     = {}
}
