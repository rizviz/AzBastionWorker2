# Create network interface for worker host VM in private subnet.
resource "azurerm_network_interface" "worker_nic" {
    name                      = "${var.resource_prefix}-wrkr-nic"
    location                  = "${var.location}"
    resource_group_name       = "${azurerm_resource_group.resource_group.name}"
    network_security_group_id = "${azurerm_network_security_group.private_nsg.id}"

    ip_configuration {
        name                          = "${var.resource_prefix}-wrkr-nic-cfg"
        subnet_id                     = "${azurerm_subnet.private_subnet.id}"
        private_ip_address_allocation = "Dynamic"
    }

    tags = "${var.tags}"
}
