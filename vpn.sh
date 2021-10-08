#!/bin/sh

case $1 in
  "apply" )
    terraform apply -auto-approve ;;
  "destroy" )
    terraform destroy -auto-approve ;;
  "ssh" )
    ssh root@`terraform show -json | jq '.values.root_module.resources[] | select (.name == "simple-wg-vpn") | .values.ip_address' | sed 's/"//g'` ;;
  "recreate" )
    terraform destroy -auto-approve && terraform apply -auto-approve ;;
  *) echo >&2 "Invalid option: $@. Valid options are: apply, destroy, recreate, ssh"; exit 1;;
esac

