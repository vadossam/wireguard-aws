data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu_2004" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*20*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "local_file" "wireguard_config" {
  filename = pathexpand("~/wireguard.conf")

  depends_on = [
    null_resource.download_wireguard_config
  ]
}
