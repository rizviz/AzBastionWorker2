# Create bastion host VM.
resource "azurerm_virtual_machine" "bastion_vm" {
    name                  = "${var.resource_prefix}-bstn-vm001"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.resource_group.name}"
    network_interface_ids = ["${azurerm_network_interface.bastion_nic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "${var.resource_prefix}-bstn-dsk001"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "${var.resource_prefix}-bstn-vm001"
        admin_username = "${var.username}"
        custom_data =  "${file("${path.module}/files/nginx.yml")}"
    }

    os_profile_linux_config {
        disable_password_authentication = true

        # Bastion host VM public key.
        ssh_keys {
            path     = "/home/${var.username}/.ssh/authorized_keys"
            key_data = ""
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.storage_account.primary_blob_endpoint}"
    }

    tags = "${var.tags}"
}
