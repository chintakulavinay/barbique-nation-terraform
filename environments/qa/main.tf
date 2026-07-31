module "ec2" {
  source = "../../modules/ec2"

  name          = "qa-server"
  ami           = var.ami
  instance_type = var.instance_type
}