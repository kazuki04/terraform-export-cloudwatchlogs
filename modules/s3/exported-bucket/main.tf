data "aws_canonical_user_id" "this" {}

resource "aws_s3_bucket" "this" {
  bucket        = var.bucket
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket                = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3_get_bucket_acl.json
}

data "aws_iam_policy_document" "s3_get_bucket_acl" {

  statement {
    sid = "AWSS3GetBucketAcl"

    principals {
      type        = "Service"
      identifiers = ["logs.ap-northeast-1.amazonaws.com"]
    }

    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "${aws_s3_bucket.this.arn}",
    ]
  }

  statement {
    sid = "AWSS3PutObject"

    principals {
      type        = "Service"
      identifiers = ["logs.ap-northeast-1.amazonaws.com"]
    }

    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}
