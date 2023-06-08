terraform {
  backend "s3" {
    bucket  =   "urbanpillar-bucket-cf"
    key     =   "terraform/state/terraform.tfstate"
    region  =   "ap-south-1"
    dynamodb_table = "terraform_state_lock_table"
  }
}
