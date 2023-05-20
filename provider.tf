provider "aws" {
}

terraform {
  backend "s3" {
    bucket = "axny-terraform-state"
    key    = "wordpress"
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

provider "random" {
}
