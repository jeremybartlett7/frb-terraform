locals {
  _pgsql_parameter_group_enable = local.squash[var.engine] == "pgsql" ? true : false
  pgsql_parameter_group_enable  = var.parameter_group_name == "" ? local._pgsql_parameter_group_enable : false

  _mssql_parameter_group_enable = local.squash[var.engine] == "mssql" ? true : false
  mssql_parameter_group_enable  = var.parameter_group_name == "" ? local._mssql_parameter_group_enable : false

  mssql_pg_name        = local.mssql_parameter_group_enable ? join("", aws_db_parameter_group.mssql.*.name) : ""
  pgsql_pg_name        = local.pgsql_parameter_group_enable ? join("", aws_db_parameter_group.pgsql.*.name) : ""
  parameter_group_name = coalesce(var.parameter_group_name, local.mssql_pg_name, local.pgsql_pg_name)

  pgaudit_log = var.data_tags["ContainsPCI"] == "N" && var.data_tags["ContainsPII"] == "N" ? "all" : "ddl,misc_set,read,role"

  sqlserver_parameters = concat(
    local.common_parameters,
    local.mssql_parameters,
    var.additional_parameters,
  )

  postgresql_parameters = concat(
    local.common_parameters,
    local.pgsql_parameters,
    contains(var.pgsql_shared_preload_libraries, "pgaudit") ? local.pgaudit_parameters : [],
    var.additional_parameters,
  )

  common_parameters = [
    {
      name         = "rds.force_ssl"
      value        = var.rds_force_ssl
      apply_method = "pending-reboot"
    },
  ]

  mssql_parameters = [
    {
      name         = "rds.sqlserver_audit"
      value        = "fedramp_hipaa"
      apply_method = "pending-reboot"
    },

    {
      name         = "remote access"
      value        = 0
      apply_method = "pending-reboot"
    },
    {
      name         = "ad hoc distributed queries"
      value        = 0
      apply_method = "immediate"
    },
    {
      name         = "clr enabled"
      value        = var.mssql_clr_enable
      apply_method = "immediate"
    },
    {
      name         = "cross db ownership chaining"
      value        = 0
      apply_method = "immediate"
    },
    {
      name         = "default trace enabled"
      value        = 1
      apply_method = "immediate"
    }
  ]

  pgsql_parameters = [
    {
      name         = "shared_preload_libraries"
      value        = join(",", var.pgsql_shared_preload_libraries)
      apply_method = "pending-reboot"
    },
    {
      name         = "log_destination"
      value        = "csvlog"
      apply_method = "pending-reboot"
    },
    {
      name         = "log_error_verbosity"
      value        = "verbose"
      apply_method = "pending-reboot"
    },
    {
      name         = "log_filename"
      value        = "postgresql.log.%y-%m-%d"
      apply_method = "pending-reboot"
    },
    {
      name         = "debug_pretty_print"
      value        = 1
      apply_method = "immediate"
    },
    {
      name         = "debug_print_parse"
      value        = 0
      apply_method = "immediate"
    },
    {
      name         = "debug_print_plan"
      value        = 0
      apply_method = "immediate"
    },
    {
      name         = "debug_print_rewritten"
      value        = 0
      apply_method = "immediate"
    },
    {
      name         = "log_checkpoints"
      value        = 1
      apply_method = "pending-reboot"
    },
    {
      name         = "log_connections"
      value        = 1
      apply_method = "pending-reboot"
    },
    {
      name         = "log_disconnections"
      value        = 1
      apply_method = "pending-reboot"
    },
    {
      name         = "log_duration"
      value        = 1
      apply_method = "pending-reboot"
    },
    {
      name         = "log_executor_stats"
      value        = 0
      apply_method = "immediate"
    },
    {
      name         = "log_hostname"
      value        = 0
      apply_method = "immediate"
    },
    {
      name         = "log_lock_waits"
      value        = 0
      apply_method = "immediate"
    },
    {
      name         = "log_min_duration_statement"
      value        = -1
      apply_method = "immediate"
    },
    {
      name         = "log_parser_stats"
      value        = 0
      apply_method = "immediate"
    },
    {
      name         = "log_planner_stats"
      value        = 0
      apply_method = "immediate"
    },
    {
      name         = "log_rotation_age"
      value        = 60
      apply_method = "pending-reboot"
    },
    {
      name         = "log_rotation_size"
      value        = 1000000
      apply_method = "pending-reboot"
    },
    {
      name         = "log_statement"
      value        = "ddl"
      apply_method = "pending-reboot"
    },
    {
      name         = "log_statement_stats"
      value        = 0
      apply_method = "immediate"
    },
    {
      name         = "log_temp_files"
      value        = 0
      apply_method = "pending-reboot"
    }
  ]

  pgaudit_parameters = [
    {
      name         = "pgaudit.log"
      apply_method = "pending-reboot"
      value        = local.pgaudit_log
    },
    {
      name         = "pgaudit.log_catalog"
      value        = 1
      apply_method = "pending-reboot"
    },
    {
      name         = "pgaudit.log_level"
      value        = "warning"
      apply_method = "pending-reboot"
    },
    {
      name         = "pgaudit.log_parameter"
      value        = 1
      apply_method = "pending-reboot"
    },
    {
      name         = "pgaudit.log_relation"
      value        = 0
      apply_method = "pending-reboot"
    },
    {
      name         = "pgaudit.log_statement_once"
      value        = 0
      apply_method = "pending-reboot"
    },
    {
      name         = "pgaudit.role"
      value        = "rds_pgaudit"
      apply_method = "pending-reboot"
    }
  ]

  # Get either the first 3 or 2 chars of the engine version, depending on the number of digits. (PGSQL & MSSQL Parameter Group)
  engine_ver = replace(var.engine_version, "/^(\\d{2}?|\\d\\.\\d).*/", "$1")
}


resource "aws_db_parameter_group" "mssql" {
  count = local.mssql_parameter_group_enable ? 1 : 0

  name_prefix = var.use_identifier ? null : "${local.vpc_name}-${var.name}-rds-pg-"
  name        = var.use_identifier ? "${local.vpc_name}-${var.name}-rds-pg" : null

  family = "${var.engine}-${local.engine_ver}.0"

  description = "FRB parameter group for MS-SQL RDS DBs implemented for (${var.name})"

  dynamic "parameter" {
    for_each = local.sqlserver_parameters

    content {
      name         = lookup(parameter.value, "name", null)
      value        = lookup(parameter.value, "value", null)
      apply_method = lookup(parameter.value, "apply_method", "pending-reboot")
    }
  }

  tags = merge({
    Name            = "${local.vpc_name}-${var.name}-rds-pg"
    ApplicationName = var.app
    ApplicationRole = var.role
    Environment     = local.env
  }, var.tags)

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      name,
      name_prefix
    ]
  }
}

resource "aws_db_parameter_group" "pgsql" {
  count = local.pgsql_parameter_group_enable ? 1 : 0

  name_prefix = var.use_identifier ? null : "${local.vpc_name}-${var.name}-rds-pg-"
  name        = var.use_identifier ? "${local.vpc_name}-${var.name}-rds-pg" : null

  family = "postgres${local.engine_ver}"

  description = "FRB parameter group for PostgreSQL RDS DBs implemented for (${var.name})"

  dynamic "parameter" {
    for_each = local.postgresql_parameters

    content {
      name         = lookup(parameter.value, "name", null)
      value        = lookup(parameter.value, "value", null)
      apply_method = lookup(parameter.value, "apply_method", "pending-reboot")
    }
  }

  tags = merge({
    Name            = "${local.vpc_name}-${var.name}-rds-pg"
    ApplicationName = var.app
    ApplicationRole = var.role
    Environment     = local.env
  }, var.tags)

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      name,
      name_prefix
    ]
  }
}
