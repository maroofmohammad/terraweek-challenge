resource "aws_s3_bucket" "backup_bucket" {
}

import {
  to = aws_s3_bucket.imported
  id = "maroof-import-demo-2026-001"
}