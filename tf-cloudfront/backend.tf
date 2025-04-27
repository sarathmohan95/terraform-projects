terraform {
  backend "s3" {
    bucket = "msarathkumar-terraform"
    key    = "statefiles/mysite-cdn.tfstate"
    region = "ap-south-1"
    dynamodb_table = "tf-state-lock"
  }
}
