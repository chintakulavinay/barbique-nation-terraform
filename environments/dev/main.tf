module "ec2" {
  source = "../../modules/ec2"

  name          = "dev-server"
  ami           = var.ami
  instance_type = var.instance_type
}