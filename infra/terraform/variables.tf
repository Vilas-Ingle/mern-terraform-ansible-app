variable "aws_region" {
  description = "AWS region for the assignment"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Prefix used for AWS resource names"
  type        = string
  default     = "travelmemory"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
  default     = "travelmemory"
}

variable "allowed_ssh_cidr" {
  description = "Your public IPv4 address in CIDR notation, for example 203.0.113.10/32"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.allowed_ssh_cidr))
    error_message = "Provide a valid IPv4 CIDR, ideally your public IP followed by /32."
  }
}
