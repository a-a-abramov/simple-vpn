# Simple Wireguard VPN on Linode VPC

## What this project does

  - Create Ubuntu 21.04 Linode instance
  - Install updates and Wireguard
  - Configures UFW
  - Setup automatic updates
  - Generate simple configuration files for peers (VPN clients)


## Why?

Everyone needs a VPN. Especially in countries where Internet is being actively controlled and VPN services being blocked. And, of course, for privacy. You know.


## Prerequisites

  - Linux or Mac OS. Windows WSL should be okay too, but it was not tested.
  - SSH key pair
  - [Terraform](https://www.terraform.io/downloads.html)
  - [Linode](https://linode.com/) account
  - [Linode CLI](https://www.linode.com/docs/guides/linode-cli/) (optional - only used to look up regions' ids)
  - Linode [Personal Access Token](https://cloud.linode.com/profile/tokens)
  - [Wireguard](https://www.wireguard.com/install/) client on your machine


## Guide

  - Clone this repo
  - `terraform init`
  - [Create private and public key pairs](https://www.wireguard.com/quickstart/) (Key Generation section) for server and for each client. **Keep them safe, treat them as passwords**
  - (optional) Choose [region](https://www.linode.com/global-infrastructure/) id using `linode-cli regions list`. Usually closest = fastest.
  - Copy `terraform.tfvars.example` into `terraform.tfvars` and fill in Linode token, path to *public* ssh key, server keys and client keys.
  - You may add more clients in the `clientconfigs` parameter
  - You may also change other parameters if you know what you're doing. They are pretty self-explanatory
  - `terraform apply`, confirm changes
  - Wait for a couple of minutes after `terraform apply` (initial configuration, package updates and installations, etc)
  - Your clients' configuration files are in `peer-configs` folder. Copy/import them to your client using either CLI or GUI.
  - (optional) You may access the server with ssh using keys (`ssh root@<server-ip>`). Root password wasn't set intentionally.


## How much does it cost?

Linode nanode type is more than enough for a couple of clients, so it will cost you $5/month if you don't exceed 1TB traffic limit. But if you don't use VPN frequently you may run `terraform destroy` to delete the server after you're done using it. In this case it would cost you substantially less. But keep in mind, that after you recreate the server when you need it again, it's IP address would change and you will need to update your clients accordingly. Or just delete the old config and load the new one from `peer-configs`. **Shutting server down is not an option - you would still be charged for it the same amount as if it was running**

## Bonus

Use QR-code to quickly import VPN configuration to your phone. Install `qrencode` tool using apt/yum/dnf/brew/pacman/etc, run `cat <your-configuration.conf> | qrencode -t ansiutf8` and scan it with Wireguard application for Android or iOS. 
