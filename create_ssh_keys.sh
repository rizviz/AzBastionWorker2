#!/bin/bash
# Adding syntax checking and user input
if [ -z "$1" ]
  then
    echo
    echo " No username provided"
    echo " Usage : create_ssh_keys.sh \"username\" "
    exit
fi

# Create for bastion host VM.
ssh-keygen -t rsa -b 4096 -C "$1" -f $HOME/.ssh/id_rsa_azurebstn -N ''

# Create for worker host VM.
ssh-keygen -t rsa -b 4096 -C "$1" -f $HOME/.ssh/id_rsa_azurewrkr -N ''

# Get the SSH public key value for bastion host.
cat ~/.ssh/id_rsa_azurebstn.pub

# Get the SSH public key value for worker host.
cat ~/.ssh/id_rsa_azurewrkr.pub
