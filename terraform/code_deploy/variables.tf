variable "ssh_key" {
  type        = string
  description = "Name of AWS keypair to use."
}

variable "code_bucket" {
  type        = string
  description = "Name of the bucket storing the code."
}
