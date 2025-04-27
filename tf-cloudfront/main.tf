provider "aws" {
  region = "ap-south-1"
}

resource "aws_cloudfront_distribution" "my_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases = ["sarathmohan.work", "www.sarathmohan.work"]
  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:065715357946:certificate/f00d278e-ec77-45b9-a219-108671049a04"       
    cloudfront_default_certificate = false
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    domain_name              = "sarathmohan.work.s3-website.ap-south-1.amazonaws.com"
    origin_id                = "sarathmohan.work.s3-website.ap-south-1.amazonaws.com"

    custom_origin_config {
        http_port                = 80
        https_port               = 443
        origin_keepalive_timeout = 5
        origin_protocol_policy   = "http-only"
        origin_read_timeout      = 30
        origin_ssl_protocols     = [
            "SSLv3",
            "TLSv1",
            "TLSv1.1",
            "TLSv1.2",
          ]
      }
  }

  default_cache_behavior {
    target_origin_id = "sarathmohan.work.s3-website.ap-south-1.amazonaws.com"
    compress = true
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string            = false

      cookies {
          forward           = "none"
        }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }
}
