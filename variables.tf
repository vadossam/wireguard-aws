variable "region" {
  default = "eu-central-1"
}

variable "name" {
  type        = string
  description = "Wireguard service name"
  default     = "wireguard"
}

variable "port" {
  type        = number
  description = "Port for wireguard server"
  default     = "55444"
}

variable "username" {
  type        = string
  description = "Client username for wireguard server"
  default     = "vadim"
}
