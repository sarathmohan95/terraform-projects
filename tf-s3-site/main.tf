module "s3_site" {
  source = "git::https://github.com/sarathmohan95/terraform-modules.git//s3-site?ref=v0.0.2"
  region = "ap-south-1"
  bucket = "msarathkumar-site"
  index_key = "index.html"
  index_location = "${path.root}/src/index.html"
  index_object_acl = "public-read"
  supporting_file_key = "img/picture.jpeg"
  supporting_file_location = "${path.root}/src/img/picture.jpeg"
  supporting_file_object_acl = "public-read"
}
