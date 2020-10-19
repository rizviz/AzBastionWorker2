# Create public subnet for hosting bastion/public VMs.
resource "azurerm_subnet" "public_subnet" {
  name                      = "${var.resource_prefix}-pblc-sn001"
  resource_group_name       = "${azurerm_resource_group.resource_group.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  address_prefix            = "10.0.1.0/24"
  network_security_group_id = "${azurerm_network_security_group.public_nsg.id}"

  # List of Service endpoints to associate with the subnet.
  service_endpoints         = [
    "Microsoft.ServiceBus",
    "Microsoft.ContainerRegistry"
  ]
}

# Create network security group and SSH rule for public subnet.
resource "azurerm_network_security_group" "public_nsg" {
  name                = "${var.resource_prefix}-pblc-nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"

  # Allow SSH traffic in from Internet to public subnet.
  security_rule {
    name                       = "allow-ssh-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = "${var.tags}"
}

# Associate network security group with public subnet.
resource "azurerm_subnet_network_security_group_association" "public_subnet_assoc" {
  subnet_id                 = "${azurerm_subnet.public_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.public_nsg.id}"
}
