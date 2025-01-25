provider "aws" {
  region = "ap-south-1"  
}

resource "aws_s3_bucket" "static_website" {
  bucket = "my-static-website-bucket"

  website {
    index_document = "./src/index.html"
  }

  tags = {
    Name = "Sarathkumar Site"
  }
}

resource "aws_s3_bucket_object" "index_html" {
  bucket = aws_s3_bucket.static_website.bucket
  key    = "index.html"
  source = "path/to/your/local/index.html" 
  acl    = "public-read"
}

output "website_url" {
  value = aws_s3_bucket.static_website.website_endpoint
}
