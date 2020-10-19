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
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCfDfs/Q+wMLKKxkfKK2TbsJrSvnOV3G/dNoTPcQyq96gEpP7wOoy4++1hkeYhKZEkE+Ni6A6KId8KzTQlbtgnXMyoKwbNDFFJMzAIyZdFHeuRBLxenWK01SKWLL6N8KQ0aFz0d8hUXMhJODCyRZdZHT4u/2v1CI4g1br503Aqo3c2O+uBPhUIM0xJZAG8d+F83QlQZHr07XjdIAKx5KOgoLX6XB/OWZ+YEIlITatYX5mHOcujv1CwcytVeMfDg8x5VHhHTDipjKX/ikROqq0iAng1voTtuz4CDXMckUuaI7k9KTGnhumBzcTYArFMUZWFqJZax8m5y2oI2VHMvGMjzk680Y5VGIbboRi2PbrAbmWTn7SpTJF5One6Y8PBXOLIju7IO/rUAPstwXm/gEXswFSsU6pI/ol/s4JdD2Xx3n9o+ObVafAQwQl9scabpdXJkfjkLrqvZOCR1//FjgktVXNYI+XbAkyBA3pR/jWa2aWYuLYHArQp/NG9aCDGdZjGdlrkSNm/y29rzVN6H7cXSLYG7te3NEAJehARLLVqon0mdfpYGluhYxBwC8pxJHi9sew0n0gVM4kjIjvrapFVBfX9BzQKrZMkXLi6bt2rx6ktgWUSLcmak7Du5JzQZaJnTkEpHxK52NvqIQo0Nziq7gWeBm6KMxp1B5fuVRNZNPw=="
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.storage_account.primary_blob_endpoint}"
    }

    tags = "${var.tags}"
}
