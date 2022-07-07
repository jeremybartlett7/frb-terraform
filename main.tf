/*
 *
 * # FRB module to create AWS Relational Database Services Instances
 *
 * https://aws.amazon.com/rds/
 * https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html
 *
 * The current FRB guidelines are to only use postgres or ms-sql (sqlserver).
 *
 * ## Usage
 *
 * ### Examples
 *
 * ## Notes
 *
 *
 * ## Regenerating docs
 * ```bash
 * $ terraform-docs md . >README.md
 * ```
 */

locals {
  env = coalesce(var.env, local.acct)

  # Squash multiple MS SQL Server editions into mssql, and also postgres into pgsql.
  squash = {
    postgres      = "pgsql"
    sqlserver-ee  = "mssql"
    sqlserver-se  = "mssql"
    sqlserver-ex  = "mssql"
    sqlserver-web = "mssql"
    oracleserver-ee = "oracle"
    oracleserver-se = "oracle"
    oracleserver-se1 = "oracle"
    oracleserver-xe = "oracle"
  }

  mssql_port = local.squash[var.engine] == "mssql" ? "1433" : ""
  pgsql_port = local.squash[var.engine] == "pgsql" ? "5432" : ""
  oracle_port = local.squash[var.engine] == "oracle" ? "1521" : ""
  port       = coalesce(var.port, local.mssql_port, local.pgsql_port, local.oracle_port)

  user     = var.database_name != "" ? "z_rds_${var.database_name}" : "db_admin"
  username = coalesce(var.initial_username, local.user)

  pgsql_license = var.engine == "postgres" ? "postgresql-license" : ""
  license_model = coalesce(var.license_model, local.pgsql_license)

  domain = data.terraform_remote_state.managed_ad.outputs.mad_ds_id

  monitoring_role_arn = var.monitoring_interval > 0 ? data.aws_iam_role.monitoring.arn : ""

  perf_insights_kms_key_id       = var.performance_insights_enabled ? data.aws_kms_key.p-i_kms.arn : var.performance_insights_kms_key_id
  perf_insights_retention_period = var.performance_insights_enabled && var.performance_insights_retention_period == 0 ? 7 : var.performance_insights_retention_period

  bak             = "${lookup(var.tags, "LOB", "IS")}-${var.cron_schedule_time}"
  rds_backup_plan = var.rds_backup_plan != "" ? var.rds_backup_plan : "${local.env}-${local.region_abbr[local.region]}-${local.bak}"
}
