variable "appvpc_id" {
  type = string
}

variable "public_subnets_id" {
  type = list(any)
}

variable "private_subnets_id" {
  type = list(any)
}