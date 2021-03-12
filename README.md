<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Usage

Creates an WAF Web ACL for use with CloudFront.  Since this is a global resource, you can use any provider region.

```hcl
module "cloudfront_waf" {
  source = "dod-iac/cloudfront-waf/aws"

  name = format("app-%s-%s", var.application, var.environment)

  metric_name = format("app%s%s", title(var.application), title(var.environment))

  allowed_hosts = [var.fqdn]

  tags = {
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}
```

You can then add the WAF to a CloudFront Distribution with `web_acl_id = module.cloudfront_waf.web_acl_id`.

## Terraform Version

Terraform 0.12. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.

Terraform 0.11 is not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_waf_byte_match_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_byte_match_set) |
| [aws_waf_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_rule) |
| [aws_waf_web_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/waf_web_acl) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allowed\_hosts | List of allowed values for the host header. | `list(string)` | n/a | yes |
| aws\_waf\_byte\_match\_set\_allowed\_hosts\_name | The name of the aws\_waf\_byte\_match\_set used by the rule used for filtering by host header.  Defaults to "[name]-allowed-hosts". | `string` | `""` | no |
| aws\_waf\_rule\_allowed\_hosts\_metric\_name | The metric name of the rule used for filtering by host header.  Defaults to "[metric\_name]AllowedHosts". | `string` | `""` | no |
| aws\_waf\_rule\_allowed\_hosts\_name | The name of the rule used for filtering by host header.  Defaults to "[name]-allowed-hosts". | `string` | `""` | no |
| metric\_name | The name or description for the Amazon CloudWatch metric of this web ACL. | `string` | n/a | yes |
| name | The name or description of the web ACL. | `string` | n/a | yes |
| tags | A mapping of tags to assign to the WAF Web ACL Resource and WAF Rules. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| web\_acl\_id | The ID of the WAF WebACL. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
