resource "tls_private_key" "admin_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "admin_private_key" {
  filename = "admin_private_key.pem"
  content = tls_private_key.admin_ssh.private_key_pem
  file_permission = "0600"
}