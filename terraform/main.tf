terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc01"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = "https://pve.home.lab:8006/api2/json"
  pm_password     = var.password
  pm_user         = "root@pam"
}

#определяем id, имя ВМ, целевой сервер и ресурсы ВМ.
resource "proxmox_vm_qemu" "monitoring" {
  name             = "monitoring"
  target_node      = "pve"
  agent            = 1
  cpu {
   cores = 2
  }         
  memory           = 2048
  boot             = "order=scsi0"
  clone            = "ubuntu-24.04-template" #выбираем, с какого темплейта клонируем
  full_clone       = true
  scsihw           = "virtio-scsi-single"
  vm_state         = "running"
  automatic_reboot = true

  nameserver = "192.168.1.170" # dns сервер
  ipconfig0  = "ip=192.168.1.199/24,gw=192.168.1.1"
  skip_ipv6  = true
  ciuser     = "max" # пользователь
  cipassword = "" # пароль
  sshkeys    = var.ssh_key # ssh-key берез из переменных
 
#Диски
 serial {
   id = 0
 }

 disks {
   scsi {
     scsi0 {
       disk {
         storage = "local-lvm"
         size    = "50G"
       }
     }
   }
   ide {
     ide2 {
       cloudinit {
         storage = "local-lvm"
       }
     }
   }
 }

#Сеть
 network {
   id     = 0
   bridge = "vmbr0"
   model  = "virtio"
 }
}


