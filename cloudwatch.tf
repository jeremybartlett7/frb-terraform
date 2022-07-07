/*
 * Subscription Filters
 */

locals {
  # Map of engines and their cloudwatch logs.
  log_types = {
    pgsql    = ["postgresql"]
    mssql    = ["agent", "error"]
    oracle   = ["oracle"]
    disabled = []
  }

  log_enabled = var.enable_cloudwatch ? local.squash[var.engine] : "disabled"

  subscription_filter = {
    pgsql = local.log_enabled == "pgsql" ? 1 : 0
    mssql = local.log_enabled == "mssql" ? 1 : 0
    oracle = local.log_enabled == "oracle" ? 1 : 0
  }
}


resource "aws_cloudwatch_log_subscription_filter" "export_postgres_rds" {
  count = local.subscription_filter["pgsql"]

  name            = "rds_log_export_postgres"
  role_arn        = data.terraform_remote_state.apollo.outputs.role
  log_group_name  = "/aws/rds/instance/${aws_db_instance.this.identifier}/postgresql"
  filter_pattern  = ""
  destination_arn = data.terraform_remote_state.apollo.outputs.arn
}

moved {
  from = aws_cloudwatch_log_subscription_filter.log_export_postgres_rds[0]
  to   = aws_cloudwatch_log_subscription_filter.export_postgres_rds[0]
}

resource "aws_cloudwatch_log_subscription_filter" "export_agent_rds" {
  count = local.subscription_filter["mssql"]

  name            = "rds_log_export_agent"
  role_arn        = data.terraform_remote_state.apollo.outputs.role
  log_group_name  = "/aws/rds/instance/${aws_db_instance.this.identifier}/agent"
  filter_pattern  = ""
  destination_arn = data.terraform_remote_state.apollo.outputs.arn
}

moved {
  from = aws_cloudwatch_log_subscription_filter.log_export_agent_rds[0]
  to   = aws_cloudwatch_log_subscription_filter.export_agent_rds[0]
}

resource "aws_cloudwatch_log_subscription_filter" "export_error_rds" {
  count = local.subscription_filter["mssql"]

  name            = "rds_log_export_error"
  role_arn        = data.terraform_remote_state.apollo.outputs.role
  log_group_name  = "/aws/rds/instance/${aws_db_instance.this.identifier}/error"
  filter_pattern  = ""
  destination_arn = data.terraform_remote_state.apollo.outputs.arn
}

moved {
  from = aws_cloudwatch_log_subscription_filter.log_export_error_rds[0]
  to   = aws_cloudwatch_log_subscription_filter.export_error_rds[0]
}

resource "aws_cloudwatch_log_subscription_filter" "export_oracle_rds" {
  count = local.subscription_filter["oracle"]

  name            = "rds_log_export_oracle"
  role_arn        = data.terraform_remote_state.apollo.outputs.role
  log_group_name  = "/aws/rds/instance/${aws_db_instance.this.identifier}/oracle"
  filter_pattern  = ""
  destination_arn = data.terraform_remote_state.apollo.outputs.arn
}

moved {
  from = aws_cloudwatch_log_subscription_filter.log_export_oracle_rds[0]
  to   = aws_cloudwatch_log_subscription_filter.export_oracle_rds[0]
}
