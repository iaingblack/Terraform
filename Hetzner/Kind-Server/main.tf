
# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

#resource "hcloud_ssh_key" "this" {
#  name       = "MyKey"
#  public_key = file("~/.ssh/ib.pub")
#}

resource "hcloud_network" "network" {
  name     = "network"
  ip_range = "10.0.0.0/16"
}
resource "hcloud_network_subnet" "network-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.network.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

# Create a server
resource "hcloud_server" "this" {
  name        = "kind-server"
  image       = "ubuntu-22.04"
  server_type = var.size
  datacenter  = "fsn1-dc14"
  ssh_keys    = ["IB SSH"]

  provisioner "file" {
    source = "scripts/setup-kind.sh"
    destination = "/tmp/script.sh"
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(pathexpand("${var.ssh_private_key}"))
      host        = hcloud_server.this.ipv4_address
    }
  }
  provisioner "remote-exec" {
    inline = [
      "apt update -y",
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh"
    ]
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(pathexpand("${var.ssh_private_key}"))
      host        = hcloud_server.this.ipv4_address
    }
  }

  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.1.5"
    alias_ips = [
      "10.0.1.6",
      "10.0.1.7"
    ]
  }

  depends_on = [
    hcloud_network_subnet.network-subnet
  ]
}

resource "local_file" "connect" {
  filename = "connect.sh"
  content  = "ssh -i ~/.ssh/ib.ppk root@${hcloud_server.this.ipv4_address}"
}
