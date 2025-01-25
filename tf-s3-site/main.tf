provider "aws" {
  region = "ap-south-1"  
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = "msarathkumar-profile-site"

  index_document {
    suffix = "./src/index.html"
  }
}

resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket_website_configuration.static_website.bucket
  key    = "index.html"
  source = "path/to/your/local/index.html" 
  acl    = "public-read"
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.static_website.website_endpoint
}
