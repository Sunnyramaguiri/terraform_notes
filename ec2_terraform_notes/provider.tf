# AWS provider block: connects Terraform to your AWS account
provider "aws" {
  access_key =          # (Sensitive) AWS access key — usually stored in environment variables or a credentials file
  secret_key =   # (Sensitive) AWS secret key — never commit this in code
  region     = "us-east-1"                         # Specifies the AWS region where resources will be created
}

# Generate a new private key using RSA algorithm with 4096-bit encryption
resource "tls_private_key" "new_key" {
  algorithm = "RSA"        # Cryptographic algorithm used to generate the key
  rsa_bits  = 4096         # Key size (4096 bits is strong encryption)
}

# Create an AWS EC2 key pair using the public part of the generated TLS key
resource "aws_key_pair" "generated_key" {
  key_name   = "unik"                                  # Name of the key pair in AWS
  public_key = tls_private_key.new_key.public_key_openssh # Public key in OpenSSH format used for EC2 login
}

# Save the private key locally to a .pem file
resource "local_file" "private_key" {
  content  = tls_private_key.new_key.private_key_pem   # PEM-formatted private key
  filename = "${path.module}/unik.pem"                 # Save file in the current Terraform module folder as "unik.pem"
}
