module "s3_site_1" {
  source = "git::https://github.com/sarathmohan95/terraform-modules.git//acm/public?ref=v0.0.3"
  validation_method = "DNS"
  domain_name = "sarathmohan.work"
}
