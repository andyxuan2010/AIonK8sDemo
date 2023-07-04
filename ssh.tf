resource "tls_private_key" "global-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "ssh-private-key-pem" {
  filename        = "${path.module}/id_rsa"
  content         = tls_private_key.global-key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "ssh-public-key-openssh" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.global-key.public_key_openssh
}