output "wireguard_public_ip" {
  value = aws_eip.elastic_ip.public_ip
}

output "wireguard_client_config" {
  value = data.local_file.wireguard_config.content
}
