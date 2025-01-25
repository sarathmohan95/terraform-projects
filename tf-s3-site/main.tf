provider "aws" {
  region = "ap-south-1"  
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = "msarathkumar-site"

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket_website_configuration.static_website.bucket
  key    = "index.html"
  source = "./src/index.html" 
  acl    = "public-read"
}

resource "aws_s3_object" "supporting_files" {
  bucket = aws_s3_bucket_website_configuration.static_website.bucket
  key    = "img/picture.JPEG"
  source = "./src/img/picture.JPEG" 
  acl    = "public-read"
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.static_website.website_endpoint
}
