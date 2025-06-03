resource "aws_s3_bucket" "my_bucket1" {
  bucket = "ansible.co.in"
  tags = {
    Name = "pract"
  }
}

resource "aws_s3_object" "terraform_state" {
  bucket = aws_s3_bucket.my_bucket1.id
  key    = "terraform.tfstate.backup"  
  source = "C:/Users/Acer/Desktop/terraform/s3bucket/"
  acl    = "private"
}


resource "aws_s3_object" "cover_letter" {
  bucket = aws_s3_bucket.my_bucket1.id
  key    = "coverletter.txt"
  source = "C:/Users/Acer/Desktop/terraform/s3bucket/covelatter.txt"
  acl    = "private"
}


# IAM policy for admin access to the S3 bucket (you can attach this to a user, group, or role)

resource "aws_iam_policy" "s3_admin_policy" {
  name        = "S3BucketAdminPolicy"
  description = "Full admin access to the ansible.co.in bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.my_bucket1.arn,
          "${aws_s3_bucket.my_bucket1.arn}/*"
        ]
      }
    ]
  })
}

# Example: attach policy to an IAM user (create user first)

resource "aws_iam_user" "admin_user" {
  name = "admin-user"
}

resource "aws_iam_user_policy_attachment" "admin_attach" {
  user       = aws_iam_user.admin_user.name
  policy_arn = aws_iam_policy.s3_admin_policy.arn
}