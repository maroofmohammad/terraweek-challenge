data "aws_region" "current" {}

data "aws_region" "virginia" {
  provider = aws.virginia
}