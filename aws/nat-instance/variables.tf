variable vpc_id {}
variable vpc_cidr {}
variable subnet_id {}
variable key_pair_name {}
variable "nat_ami" {
    type = object({
      id = optional(string)
    })
}