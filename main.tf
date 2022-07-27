locals {
  user_data = <<-EOT
  #!/bin/bash
  git clone https://github.com/pprometey/wireguard_aws.git
  cd wireguard_aws
  sed -z -i "$(echo s/read/#read/{4..1}\;)" install.sh
  sed -i '8i ENDPOINT=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):55444' install.sh
  sudo ./install.sh
  sudo ./add-client.sh vadim
  EOT
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  name = var.name

  ami           = data.aws_ami.ubuntu_2004.id
  instance_type = "t2.micro"
  key_name      = "aws"

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true

  # select availability zone
  subnet_id              = element(module.vpc.public_subnets, 1)
  vpc_security_group_ids = [module.security_group.security_group_id]

}

resource "aws_eip" "elastic_ip" {
  instance = module.ec2_instance.id
  vpc      = true
}

resource "null_resource" "download_wireguard_config" {
  provisioner "remote-exec" {
    connection {
      host        = aws_eip.elastic_ip.public_ip
      user        = "ubuntu"
      private_key = file("~/.ssh/aws.pem")
    }

    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"
    ]
  }

  provisioner "local-exec" {
    command = <<-EOT
      rsync -e 'ssh -o StrictHostKeyChecking=no -i ~/.ssh/aws.pem' --rsync-path='sudo rsync' \
      ubuntu@${aws_eip.elastic_ip.public_ip}:/etc/wireguard/clients/vadim/vadim.conf ~/wireguard.conf
    EOT
  }

  depends_on = [
    module.ec2_instance,
  ]

}
