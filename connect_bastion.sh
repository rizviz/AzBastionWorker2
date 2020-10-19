# Get IP addresses of all hosts, public and private.
az vm list-ip-addresses \
    --ids $(az vm list --resource-group zeushighcharity-rg --query "[].id" --output tsv)

# Copy worker host VM SSH private key to bastion host for connecting later to worker hosts.
scp -i ~/.ssh/id_rsa_azurebstn \
    ~/.ssh/id_rsa_azurewrkr fireteamosiris@<bastion_public_ip>:~/.ssh/id_rsa_azurewrkr

# Connect to bastion host in public subnet.
ssh fireteamosiris@<bastion_public_ip> -i ~/.ssh/id_rsa_azurebstn

# Check connectivity to worker host in private subnet.
ping zeushighcharity-wrkr-vm001
ping <worker_private_ip>

# Connect to worker host in private subnet from bastion host in public subnet.
ssh fireteamosiris@zeushighcharity-wrkr-vm001 -i ~/.ssh/id_rsa_azurewrkr
