output "web_acl_id" {
  description = "The ID of the WAF WebACL."
  value       = aws_waf_web_acl.main.id
}
