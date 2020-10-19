# Create worker host VM.
resource "azurerm_virtual_machine" "worker_vm" {
    name                  = "${var.resource_prefix}-wrkr-vm001"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.resource_group.name}"
    network_interface_ids = ["${azurerm_network_interface.worker_nic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "${var.resource_prefix}-wrkr-dsk001"
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
        computer_name  = "${var.resource_prefix}-wrkr-vm001"
        admin_username = "${var.username}"
    }

    os_profile_linux_config {
        disable_password_authentication = true

        # Worker host VM public key.
        ssh_keys {
            path     = "/home/${var.username}/.ssh/authorized_keys"
            key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCyhfsGKt4FF5bIxdIDkBANxivJ9BI/H2UQEUPKYjZh0GDCWyYEPBKYhIGD4OvibdrA/4fFi7tGs3QEvMBju8hZ86iWxpU1cy3JXw6XxLgrhufYpWw2XG6hHfbcJ4wpFwQ1GvwnI52K+BErCcTzqa6JBQGVf1O57lWHXTsGa9WEMwKCza+8JZdckfXUbztO1jYQ+dEi3Uh0ANyGEC+qHRoKcmJKxMDBZMt4lIhkFsApPeg7w1/CdFZCI42+V/xQYB3yn7pgae9NTXgVE40h0pMEkgaDqonc60DJthNb5l81PmshOjttEkHh4TTA4jv2fyDammt5Krl+9k57f3iKTh7VCGPVc/UkMJ1L+nDfOFP5nEuyh+vtuNCZs0iBdumf6MrShN+KyoodDhyd3w3Nx/e7M1iyLLYjNRT+gaHG1xXuYrSE0NM41lCgynDttML2rrPiLdm/l7jEkFJNSXXd57IUaHNV44L5xaRtyVJv+j79JXM2Ds5p2RN0vS8mtqh3g6UOGHPAWC5IKAsU8xXR+N3jvajwUoV5VQGOxRqpkN+litJGQkiFgjd/aqd0jLCd5MGRbk63TL/YssHlR5vya5Fo9kFGPocYnyiqB/VSMPH6mZDorfaWlV3mdR3ocK01DdcmiKPETYpmNRvmT/GIEjlpRT+hlE11prd9rA9Kmw6E7w=="
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.storage_account.primary_blob_endpoint}"
    }

    tags = "${var.tags}"
}
