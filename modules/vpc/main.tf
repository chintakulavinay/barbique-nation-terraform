resource "aws_vpc" "abs" {
    cidr_block = ""
    enable_dns_support = false
    enable_dns_hostnames = true
  

tags ={
    Name = "abs-vpc"
}
}