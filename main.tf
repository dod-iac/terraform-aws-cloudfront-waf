/**
 * ## Usage
 *
 * Creates an WAF Web ACL for use with CloudFront.  Since this is a global resource, you can use any provider region.
 *
 *
 * ```hcl
 * module "cloudfront_waf" {
 *   source = "dod-iac/cloudfront-waf/aws"
 *
 *   name = format("app-%s-%s", var.application, var.environment)
 *
 *   metric_name = format("app%s%s", title(var.application), title(var.environment))
 *
 *   allowed_hosts = [var.fqdn]
 *
 *   tags = {
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 * You can then add the WAF to a CloudFront Distribution with `web_acl_id = module.cloudfront_waf.web_acl_id`.
 *
 * ## Terraform Version
 *
 * Terraform 0.12. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * Terraform 0.11 is not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

# The aws_waf_byte_match_set used by the rule used for filtering by host header.
resource "aws_waf_byte_match_set" "allowed_hosts" {
  name = length(var.aws_waf_byte_match_set_allowed_hosts_name) > 0 ? var.aws_waf_byte_match_set_allowed_hosts_name : format("%s-allowed-hosts", var.name)

  dynamic "byte_match_tuples" {
    for_each = var.allowed_hosts
    content {
      # Even though the AWS Console web UI suggests a capitalized "host" data,
      # the data should be lower case as the AWS API will silently lowercase anyway.
      field_to_match {
        type = "HEADER"
        data = "host"
      }

      target_string = byte_match_tuples.value

      # See ByteMatchTuple for possible variable options.
      # See https://docs.aws.amazon.com/waf/latest/APIReference/API_ByteMatchTuple.html#WAF-Type-ByteMatchTuple-PositionalConstraint
      positional_constraint = "EXACTLY"

      # Use COMPRESS_WHITE_SPACE to prevent sneaking around regex filter with
      # extra or non-standard whitespace
      # See https://docs.aws.amazon.com/sdk-for-go/api/service/waf/#RegexMatchTuple
      text_transformation = "COMPRESS_WHITE_SPACE"
    }
  }
}

# The rule used for filtering by host header.
resource "aws_waf_rule" "allowed_hosts" {
  name        = length(var.aws_waf_rule_allowed_hosts_name) > 0 ? var.aws_waf_rule_allowed_hosts_name : format("%s-allowed-hosts", var.name)
  metric_name = length(var.aws_waf_rule_allowed_hosts_metric_name) > 0 ? var.aws_waf_rule_allowed_hosts_metric_name : format("%sAllowedHosts", var.metric_name)

  predicates {
    type    = "ByteMatch"
    data_id = aws_waf_byte_match_set.allowed_hosts.id
    negated = true
  }

  tags = var.tags
}

resource "aws_waf_web_acl" "main" {
  depends_on = [
    aws_waf_rule.allowed_hosts,
  ]

  name        = var.name
  metric_name = var.metric_name

  default_action {
    type = "ALLOW"
  }

  rules {
    action {
      type = "BLOCK"
    }
    priority = 1
    rule_id  = aws_waf_rule.allowed_hosts.id
    type     = "REGULAR"
  }

  tags = var.tags
}
