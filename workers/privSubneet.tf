# Create private subnet for hosting worker VMs.
resource "azurerm_subnet" "private_subnet" {
  name                      = "${var.resource_prefix}-prvt-sn001"
  resource_group_name       = "${azurerm_resource_group.resource_group.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  address_prefix            = "10.0.2.0/24"
  network_security_group_id = "${azurerm_network_security_group.private_nsg.id}"

  # List of Service endpoints to associate with the subnet.
  service_endpoints         = [
    "Microsoft.Sql",
    "Microsoft.ServiceBus"
  ]
}

# Create network security group and SSH rule for private subnet.
resource "azurerm_network_security_group" "private_nsg" {
  name                = "${var.resource_prefix}-prvt-nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"

  # Allow SSH traffic in from public subnet to private subnet.
  security_rule {
    name                       = "allow-ssh-public-subnet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

  # Block all outbound traffic from private subnet to Internet.
  security_rule {
    name                       = "deny-internet-all"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = "${var.tags}"
}

# Associate network security group with private subnet.
resource "azurerm_subnet_network_security_group_association" "private_subnet_assoc" {
  subnet_id                 = "${azurerm_subnet.private_subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.private_nsg.id}"
}
