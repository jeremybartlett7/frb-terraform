locals {
  timestamp     = timestamp()
  now           = replace(local.timestamp, "/[- TZ:]/", "")
  base_sg_mssql = local.squash[var.engine] == "mssql" ? [data.terraform_remote_state.vpc.outputs.base_sg_mssql] : []
  base_sg_pgsql = local.squash[var.engine] == "pgsql" ? [data.terraform_remote_state.vpc.outputs.base_sg_postgresql] : []
  base_sg_oracle = local.squash[var.engine] == "oracle" ? [data.terraform_remote_state.vpc.outputs.base_sg_oracle] : []
  # As of this writing, there is no dataguise base SG in the stg VPCs.
  # That being the case, the below checks whether local.vpc_name contains the regex "stg$".
  # If it does, the regexall count will be > 0, which means that we need to ignore the dataguise base SG in concatting
  # the list of SGs for a new RDS instance.
  security_groups = concat(
    length(regexall("stg$", local.vpc_name)) == 0 ? [data.terraform_remote_state.dataguise.outputs.base_sg] : [],
    local.base_sg_mssql,
    local.base_sg_pgsql,
    local.base_sg_oracle,
    var.security_groups
  )


  replicate_source_db_arn  = var.replicate_source_db != null ? split(":", var.replicate_source_db) : []
  _replicate_source_region = length(local.replicate_source_db_arn) > 4 ? local.replicate_source_db_arn[3] : local.region
  replicate_source_region  = local.replicate_source_db_arn != [] ? local._replicate_source_region : null

  replicate_subnet = local.region != local.replicate_source_region ? data.terraform_remote_state.vpc.outputs.db_subnetgroup : null

  max_alloc_storage     = local.acct == "prod" ? var.allocated_storage * 2 : var.allocated_storage + 10
  max_allocated_storage = var.max_allocated_storage != "" ? var.max_allocated_storage : local.max_alloc_storage

  identifier_prefix = var.use_identifier ? null : "${local.vpc_name}-${var.name}-rds-"
  identifier        = var.use_identifier ? "${local.vpc_name}-${var.name}" : null

  final_snapshot_identifier = var.replicate_source_db != null ? null : local.final_snapshot
  final_snapshot            = var.promote ? null : "${local.vpc_name}-${var.name}-rds-final-snapshot-${local.now}"
  snapshot_identifier       = var.replicate_source_db != null ? null : var.snapshot_identifier
  backup_retention_period   = var.replicate_source_db != null ? null : var.backup_retention_period
}

resource "aws_db_instance" "this" {
  identifier          = local.identifier
  identifier_prefix   = local.identifier_prefix
  snapshot_identifier = var.promote ? null : local.snapshot_identifier

  engine         = var.replicate_source_db != null ? null : var.engine
  engine_version = var.replicate_source_db != null ? null : var.engine_version

  license_model                   = local.license_model
  instance_class                  = var.instance_class
  vpc_security_group_ids          = compact(local.security_groups)
  port                            = local.port
  enabled_cloudwatch_logs_exports = local.log_types[local.log_enabled]

  # Use null value to make primary, or specify replicate source identifier(arn for cross-region)
  replicate_source_db  = var.replicate_source_db
  db_subnet_group_name = var.replicate_source_db == null ? data.terraform_remote_state.vpc.outputs.db_subnetgroup : local.replicate_subnet

  db_name      = var.replicate_source_db != null ? null : var.database_name
  username     = var.replicate_source_db != null ? null : local.username
  password     = var.replicate_source_db != null ? null : var.initial_password
  storage_type = var.storage_type
  iops         = var.iops

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.replicate_source_db != null ? null : local.max_allocated_storage

  multi_az             = var.multi_az
  apply_immediately    = var.apply_immediately
  storage_encrypted    = var.storage_encrypted
  kms_key_id           = data.aws_kms_key.rds_kms.arn
  publicly_accessible  = false
  parameter_group_name = local.parameter_group_name

  timezone = local.squash[var.engine] == "mssql" ? var.mssql_timezone : null

  backup_window             = var.backup_window
  backup_retention_period   = var.promote ? null : local.backup_retention_period
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot
  delete_automated_backups  = var.delete_automated_backups
  final_snapshot_identifier = var.promote ? null : local.final_snapshot_identifier

  maintenance_window = var.maintenance_window

  domain               = var.ds_enable ? local.domain : ""
  domain_iam_role_name = var.ds_enable ? data.terraform_remote_state.managed_ad.outputs.mad_rds_role_name : ""

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_role_arn != "" ? var.monitoring_role_arn : local.monitoring_role_arn

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id != "" ? var.performance_insights_kms_key_id : local.perf_insights_kms_key_id
  performance_insights_retention_period = local.perf_insights_retention_period

  deletion_protection = var.deletion_protection

  allow_major_version_upgrade = var.allow_major_version_upgrade

  tags = merge(var.data_tags, {
    Name            = "${local.vpc_name}-${var.name}-rds"
    ApplicationName = var.app
    ApplicationRole = var.role
    Environment     = local.env

    RDSBackupPlan = local.rds_backup_plan
  }, var.tags)

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      identifier,
      identifier_prefix,
      db_name,
      db_subnet_group_name,
      username,
      password
    ]
  }
}

moved {
  from = aws_db_instance.main[0]
  to   = aws_db_instance.this
}
