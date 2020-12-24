variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block of the VPC"
  default     = "10.0.0.0/22"
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "http_range" {
  description = "Source from which media wiki URL to be access.Dafault accessible from everywhere"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_range" {
  description = "Source from which SSH access to be enabled for the EC2. Dafault accessible from everywhere"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_key" {
  description = "The public key material. For more details abpout generation of public key ,refer Readme file"
  type        = string
}

variable "wiki_db_user" {
  description = "Wiki DB user name"
  type        = string
}

variable "db_root_pwd" {
  description = "DB root user password"
  type        = string
}

variable "wiki_db_pwd" {
  description = "Wiki DB user password"
  type        = string
}

variable "wiki_db" {
  description = "Wiki db name"
  type        = string
}


variable "wiki_user" {
  description = "Wiki user name"
  type        = string
}

variable "wiki_pwd" {
  description = "Wiki user password . PS : Min length 10"
  type        = string
}

variable "wiki_name" {
  description = "Wiki name"
  type        = string
}

variable "ec2_ami" {
  description = "The AMI to use for the instance . PS : select Red Hat Enterprise Linux 8  AMI "
  type        = string
}

variable "ec2_instance_type" {
  description = "The type of instance"
  type        = string
  default     = "t2.micro"
}