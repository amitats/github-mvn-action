pg.tf


provider "aws" {
  region = "eu-central-1"
}


resource "aws_db_instance" "mydb1" {
  allocated_storage        = 256 # gigabytes
  backup_retention_period  = 0   # in days
 // db_subnet_group_name     = "${var.rds_public_subnet_group}"
  engine                   = "postgres"
  engine_version           = "11.17"
  identifier               = "mydb1"
  instance_class           = "db.m4.10xlarge"
  license_model            = "postgresql-license"
  multi_az                 = false
#  name                    = "mydb1"
#   identifier              = "mydb1"
//  parameter_group_name     = "mydbparamgroup1" # if you have tuned it
  password                 = "password"
  port                     = 5432
  publicly_accessible      = true
  storage_encrypted        = true # you should always do this
  storage_type             = "gp2"
  username                 = "mydb1"
  vpc_security_group_ids   = ["${aws_security_group.mydb1.id}"]
  skip_final_snapshot      = true
  availability_zone        = "eu-central-1b"
}



resource "aws_security_group" "mydb1" {
  name = "mydb1"

  description = "RDS postgres servers (terraform-managed)"
  vpc_id = "${var.rds_vpc_id}"

  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}





cat variable.tf
variable "rds_vpc_id" {
  default = "vpc-011e99dc2dd5f84f7"
  description = "Our default RDS virtual private cloud (rds_vpc)."
}

variable "rds_public_subnets" {
  default = "subnet-02dbd5c0c8cb5f2d5,subnet-01ecfdfc3351c5ccf,subnet-0e5717d5d1c913f43"
  description = "The public subnets of our RDS VPC rds-vpc."
}
