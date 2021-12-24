# Define VPC Variable
variable "aws_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# Create VPC
resource "aws_vpc" "dfsc_vpc" {
  cidr_block       = var.aws_vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name      = "DFSC VPC"
    Terrafrom = "True"
  }
}
