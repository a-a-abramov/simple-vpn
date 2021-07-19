variable "linode" {
  type = object({
    token  = string,
    image  = string,
    type   = string,
    region = string
  })
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
