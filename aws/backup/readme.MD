## Usage:

```tf
module "backup" {
  source = "../../../../modules/aws_backup"

  key               = var.key
  value             = var.value
  backup_vault_name = var.backup_vault_name
  rules             = var.rules
  sns_topic_arn     = var.sns_topic_arn
}

```