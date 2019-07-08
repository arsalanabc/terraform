variable "server_port" {
  description = "Port to allow income/outgoing requests"
  default     = "8080"
}

variable "server_port_lb_http" {
  description = "Port to allow income/outgoing request to lb"
  default     = "80"
}

variable "region" {
  description = "region to launch the server"
  default = "eu-west-1"
}

variable "ami" {
  description = "default ami"
  default     = "ami-ee0b0688"
}