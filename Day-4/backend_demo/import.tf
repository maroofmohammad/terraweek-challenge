resource "aws_s3_bucket" "imported" {
}

import {
  to = aws_s3_bucket.imported
  id = "maroof-import-demo-2026-001"
}