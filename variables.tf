variable "token" {
  type = string
}

variable "image" {
  type = string
  default = "linode/ubuntu21.04"
}

variable "type" {
  type = string
  default = "g6-nanode-1"
}

variable "region" {
  type = string
  default = "eu-central"
}

variable "ssh_pubkey_path" {
  type = string
}

# TODO cidr validation maybe?
variable "serverconfig" {
  type = object({
    name        = string,
    vpn_addr    = string,
    port        = number,
    private_key = string,
    public_key  = string
  })
}

variable "clientconfigs" {
  type = list(object({
    name        = string,
    vpn_addr    = string,
    private_key = string,
    public_key  = string
  }))
}
