module "ec2" {
  source = "../../modules/ec2"

  name          = var.Name
  ami           = var.ami
  instance_type = var.instance_type
}