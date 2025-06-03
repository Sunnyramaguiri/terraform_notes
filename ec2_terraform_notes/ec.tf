# EC2 Instance Resource Block
resource "aws_instance" "new_sel" {
  ami                    = "ami-084568db4383264d4"             # Specifies the Amazon Machine Image (AMI) ID to use for the instance
  instance_type          = "t2.micro"                          # Sets the instance type; t2.micro is Free Tier eligible
  key_name               = aws_key_pair.generated_key.key_name # Associates the instance with the previously created key pair (unik)
  vpc_security_group_ids = [aws_security_group.ssh_access.id]  # Attaches the specified security group to allow SSH access

  tags = {
    Name = "myins"                                              # Adds a tag to the instance for easy identification
  }
}

# Explanation:
# resource "aws_instance" "new_sel"
# Creates a new EC2 instance resource named new_sel.

# ami = "ami-084568db4383264d4"
# Specifies the Amazon Machine Image (AMI) ID to use for the instance.
# This ID points to the OS image, like Ubuntu or Amazon Linux, in the specified AWS region.

# instance_type = "t2.micro"
# Sets the instance size/type. t2.micro is a small, low-cost instance type eligible for the AWS free tier.

# key_name = aws_key_pair.generated_key.key_name
# Associates the instance with the AWS key pair created earlier (named unik).
# This enables SSH access using the private key you saved locally.

# vpc_security_group_ids = [aws_security_group.ssh_access.id]
# Attaches the security group called ssh_access (created separately).
# This security group controls network traffic rules, e.g., allowing SSH access on port 22.

# tags = { Name = "myins" }
# Adds a tag named Name with the value "myins" to help identify this instance in the AWS console or when managing resources.


# Security Group Resource Block
resource "aws_security_group" "ssh_access" {
  name        = "allow_ssh"                            # Assigns a human-readable name to this security group
  description = "Allow SSH inbound traffic"            # Description to explain the purpose of the security group

  ingress {
    from_port   = 22                                   # Starting port for SSH
    to_port     = 22                                   # Ending port for SSH
    protocol    = "tcp"                                # Protocol type
    cidr_blocks = ["0.0.0.0/0"]                        # Allows SSH access from any IP address (use your IP for better security)
  }

  egress {
    from_port   = 0                                    # Start of the port range for outgoing traffic
    to_port     = 0                                    # End of the port range for outgoing traffic
    protocol    = "-1"                                 # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]                        # Allows outbound traffic to anywhere
  }
}

# Explanation:
# resource "aws_security_group" "ssh_access"
# Creates a security group named allow_ssh.
# Security groups act like virtual firewalls controlling inbound and outbound traffic for your instance.

# name = "allow_ssh"
# Assigns a human-readable name to this security group.

# description = "Allow SSH inbound traffic"
# A simple description of what this security group is for.

# Ingress Rule:
# Allows inbound TCP traffic on port 22 (SSH).
# cidr_blocks = ["0.0.0.0/0"] means from any IP address (all IPv4 internet).
# ⚠️ For production, replace with your IP or IP range for security, e.g., "203.0.113.10/32"

# Egress Rule:
# Allows all outbound traffic on any port and any protocol (-1 means all protocols).
# This is typical so your instance can reach the internet or other AWS services as needed.
