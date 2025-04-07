variable "region" {
  default = "eu-central-1"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  default = "my-key"  # Update with your actual key pair name
}

variable "ami_id" {
  # Ubuntu 22.04 LTS AMI for eu-central-1
  default = "ami-04a5bacc58328233d"
}
