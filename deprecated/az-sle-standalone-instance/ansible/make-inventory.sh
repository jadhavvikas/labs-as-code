#!/bin/bash

terraform output -state=../terraform/terraform.tfstate -json \
    | python -m create-inventory ansible_inventory.j2 \
    > hosts.yaml
