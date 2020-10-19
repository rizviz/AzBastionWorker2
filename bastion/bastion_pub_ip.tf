# Create a public IP address for bastion host VM in public subnet.
resource "azurerm_public_ip" "public_ip" {
    name                         = "${var.resource_prefix}-ip"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.resource_group.name}"
    allocation_method            = "Dynamic"

    tags = "${var.tags}"
}

# Create network interface for bastion host VM in public subnet.
resource "azurerm_network_interface" "bastion_nic" {
    name                      = "${var.resource_prefix}-bstn-nic"
    location                  = "${var.location}"
    resource_group_name       = "${azurerm_resource_group.resource_group.name}"
    network_security_group_id = "${azurerm_network_security_group.public_nsg.id}"

    ip_configuration {
        name                          = "${var.resource_prefix}-bstn-nic-cfg"
        subnet_id                     = "${azurerm_subnet.public_subnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.public_ip.id}"
    }

    tags = "${var.tags}"
}
