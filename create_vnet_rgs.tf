# Create a resource group if it doesn’t exist.
resource "azurerm_resource_group" "resource_group" {
    name     = "${var.resource_prefix}-rg"
    location = "${var.location}"

    tags = "${var.tags}"
}

# Create virtual network with public and private subnets.
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.resource_prefix}-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"

    tags = "${var.tags}"
}
