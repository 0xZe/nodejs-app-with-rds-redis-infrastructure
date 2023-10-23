variable "vpc_cidr" {
  type = string

}
variable "public_subnets_cidr" {
  type = list(any)
}

variable "private_subnets_cidr" {
  type = list(any)
}

variable "subnets_az" {
  type = list(any)
}
