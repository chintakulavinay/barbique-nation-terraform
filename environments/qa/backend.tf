terraform{
    backend "s3" {
        bucket = "test-terraform-bucket89782683"
        key = "qa/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "terraform-lock"
    }
}