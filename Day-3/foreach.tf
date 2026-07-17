locals {
  servers = toset([
    "web",
    "app",
    "db"
  ])
}

resource "aws_security_group" "foreach_demo" {
  for_each = local.servers

  name   = "${each.key}"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = each.key
  }
}