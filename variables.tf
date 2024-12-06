variable "vpc_cidr" {
  description = "The cidr block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The provided value is not a valid CIDR block."
  }
}

variable "subnet_az" {
  description = "The Availability zone of the subnet"
}

variable "key_name" {
  description = "Value of the key-pair name"
}

variable "sg_name" {
  description = "Name of the Security Group"
}


variable "instance_type" {
  description = "The type of instance"

  validation {
    condition     = var.instance_type == "t2.micro"
    error_message = "The instance type should only be 't2.micro'"
  }
}
