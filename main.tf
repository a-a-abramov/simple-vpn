terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

provider "linode" {
  token = var.linode.token
}

resource "linode_stackscript" "wireguard_prep" {
  label       = "wireguard_prep"
  description = "Prepare Ubuntu to be used as Wireguard VPN server"
  script      = templatefile("templates/stackscript.tmpl", { clientconfigs = var.clientconfigs })
  images      = ["linode/ubuntu21.04"]
}


resource "linode_instance" "simple-wg-vpn" {
  label           = "simple-wg-vpn"
  image           = "linode/ubuntu21.04"
  region          = var.linode.region
  type            = var.linode.type
  authorized_keys = [chomp(file(var.ssh_pubkey_path))]
  stackscript_id  = linode_stackscript.wireguard_prep.id
  stackscript_data = merge(
    {
      "SERVER_PRIVATEKEY" = var.serverconfig.private_key
      "SERVER_VPN_ADDR"   = var.serverconfig.vpn_addr
      "SERVER_PORT"       = var.serverconfig.port
    },
    { for i in range(length(var.clientconfigs)) : "CLIENT_${i}_PUBLICKEY" => var.clientconfigs[i].public_key },
    { for i in range(length(var.clientconfigs)) : "CLIENT_${i}_VPN_ADDR" => var.clientconfigs[i].vpn_addr }
  )

}

resource "local_file" "peer_configs" {
  for_each = { for c in var.clientconfigs : c.name => c }
  sensitive_content = templatefile(
    "templates/client.tmpl",
    {
      server = merge(var.serverconfig, { "public_addr" : linode_instance.simple-wg-vpn.ip_address }),
      client = each.value
    }
  )
  filename        = "peer-configs/${each.key}.conf"
  file_permission = "0600"
}
