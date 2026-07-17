resource "aws_security_group" "count_demo" {
  count = 2

  name   = "count-demo-${count.index}"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "count-demo-${count.index}"
  }
}