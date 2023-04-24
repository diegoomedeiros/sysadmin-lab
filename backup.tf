#Selecionar Backup Vault Default (Ja existente)
data "aws_backup_vault" "default" {
  name = "Default"
}

# Criar Plano de Backup
resource "aws_backup_plan" "lab_backup_plan" {
  name = "lab_backup_plan"

  rule {
    rule_name         = "once-a-day-${var.backup_retention}-day-retention"
    target_vault_name = data.aws_backup_vault.default.id
    schedule          = var.backup_schedule
    start_window      = 60
    completion_window = 300

    lifecycle {
      delete_after = var.backup_retention
    }

    recovery_point_tags = {
      env     = var.env
      Role    = "backup"
      Creator = "aws-backups"
    }
  }
  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }
  tags = {
    env  = var.env
    Role = "backup"
  }
}

#Especifica a Role para o Terraform
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#Altera a Policy para formato JSON
resource "aws_iam_role" "example" {
  name               = "example"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

#Especifica a ARN da Role para o Terraform
resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.example.name
}

#Especifica o criterio de selecao dos recursos com base no Plano informando a Role de acesso. 
resource "aws_backup_selection" "lab_server_backup_selection" {
  iam_role_arn = aws_iam_role.example.arn
  name         = "lab-server-resources"
  plan_id      = aws_backup_plan.lab_backup_plan.id

  # Seleção por TAG - o plano fara backup apenas dos compentes com a tag "Backup = true"
  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}
