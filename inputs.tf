variable "vpc_name" {
  description = "VPC name the stack will be deployed in."
}

variable "app" {
  description = "Name of the application"
}

variable "role" {
  description = "Tag, role used for application"
  default     = "database"
}

variable "env" {
  description = "The environment the application is deployed in."
  default     = ""
}

variable "tags" {
  description = "TFE Workspace tags to be passed into the resource."
  type        = map(string)
  #default = { BuiltBy = "terraform" }
}

variable "data_tags" {
  description = "Data Classification tags to be passed into the resource storage & resource."
  type        = map(string)
  #default = { ContainsPCI = "N" ContainsPII = "N" }

  validation {
    condition     = can(regex("ContainsPCI", join(",", keys(var.data_tags))))
    error_message = "The data_tags map variable keys must contain the ContainsPCI tag."
  }

  validation {
    condition     = can(regex("ContainsPII", join(",", keys(var.data_tags))))
    error_message = "The data_tags map variable keys must contain the ContainsPII tag."
  }
}

variable "name" {
  description = "The DB name to create. If omitted, no database is created initially."
}

variable "license_model" {
  description = "License model information for this DB instance. Optional, but required for some DB engines"
  default     = ""
}

variable "engine" {
  description = "The database engine to use"
}

variable "engine_version" {
  description = "(Optional) The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10). The actual engine version used is returned in the attribute engine_version_actual, which is not set in this module. For supported values, see the EngineVersion parameter in [API action CreateDBInstance](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html)."
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
}

variable "security_groups" {
  description = "List of security groups for RDS instance."
  default     = []
}

variable "security_groups_replica" {
  description = "List of security groups for RDS replica instance."
  default     = []
}

variable "database_name" {
  description = "Defines the database name used in the application."
  default     = ""
}

variable "initial_username" {
  description = "Initial username for the master DB user, defaults to z_rds_<var.database_name>, unless there is no DB, which it then will be db_admin."
  default     = ""
}

variable "initial_password" {
  description = "Initial password for the master DB user. Note that this will be stored in the state file."
  sensitive   = true
}

variable "allocated_storage" {
  description = "Specifies the value for Allocated Storage."
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling, which defaults to var.allocated_storage + 5GB."
  default     = ""
}

variable "port" {
  description = "The port on which the DB accepts connections."
  default     = ""
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key."
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot."
  default     = null
}

variable "backup_retention_period" {
  description = "The days to retain backups for."
  default     = 3
}

variable "backup_window" {
  description = "(Optional) The daily time range (in UTC) during which automated backups are created if they are enabled. Example: \"09:46-10:16\". Must not overlap with maintenance_window."
  default     = null
}

variable "maintenance_window" {
  description = "(Optional) The window to perform maintenance in. Syntax: \"ddd:hh24:mi-ddd:hh24:mi\". Eg: \"Mon:00:00-Mon:03:00\". See [RDS Maintenance Window docs](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.Maintenance.html#AdjustingTheMaintenanceWindow) for more information."
  default     = null
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  default     = false
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted."
  default     = true
}

variable "storage_type" {
  description = "(Optional) One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not."
  default     = ""
}

variable "iops" {
  description = "(Optional) The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'."
  default     = null
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ."
  default     = false
}

variable "replica" {
  description = "Specifies that this resource is a Replica database, and to use this value as the source database."
  default     = false
}

variable "parameter_group_name" {
  description = "AWS parameter group name for any RDS DB, which may override the FRB standard PG, as currently defined in mod-rds (affecting PGSQL)."
  default     = ""
}

variable "additional_parameters" {
  description = "A list of DB parameters to apply, that go above and beyond the default PG we apply to all DBs. Note that parameters may differ from a DB family to another"
  default     = []
  #type = list(object({
  #  apply_method = string
  #  name         = string
  #  value        = string
  #}))
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible."
  default     = false
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  default     = false
}

variable "ds_enable" {
  description = "Enable Active Directory Service auth (kerberos5) for the RDS DB, set to true '1' to use ManagedAD auth to the DB."
  default     = true
}

variable "rds_backup_plan" {
  description = "Defines a backup plan for rds."
  default     = ""
}

variable "copy_tags_to_snapshot" {
  description = "(Optional, boolean) Copy all Instance tags to snapshots."
  default     = true
}

variable "cron_schedule_time" {
  description = "Defines cron schedule time."
  default     = "24hr"
}

variable "rds_force_ssl" {
  description = "Forces SSL when connecting to PostgreSQL or MS-SQL instance"
  default     = 1
}

variable "enable_cloudwatch" {
  description = "export logs to cloudwatch"
  default     = true
}

variable "monitoring_interval" {
  description = "(Optional) The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0."
  default     = 60
}

variable "monitoring_role_arn" {
  description = "(Optional) The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs."
  default     = ""
}

variable "performance_insights_enabled" {
  description = "(Optional) Specifies whether Performance Insights are enabled."
  default     = true
}

variable "performance_insights_kms_key_id" {
  description = "(Optional) The ARN for the KMS key to encrypt Performance Insights data. To enable, performance_insights_enabled needs to be set to true. Once KMS key is set, it can never be changed."
  default     = ""
}

variable "performance_insights_retention_period" {
  description = "(Optional) The amount of time in days to retain Performance Insights data.To enable, performance_insights_enabled needs to be set to true. Either 7 (7 days, the default) or 731 (2 years) are valid values."
  default     = 0
  type        = number
}

variable "mssql_clr_enable" {
  description = "For MS-SQL DBs parameter group only. Set to 1 if SSIS features are needed."
  default     = 0
  type        = number
}

variable "pgsql_shared_preload_libraries" {
  description = "For PostgreSQL DBs, the shared_preload_libraries Parameter Group value."
  default     = ["pgaudit", "pg_stat_statements"]
  type        = list(string)
}

variable "log_group_kms_key" {
  description = "The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested."
  default     = "alias/frb-cloudwatch"
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replica database, and to use this value as the source RDS database. defaults to null to ignore this argument"
  default     = null
}

variable "use_identifier" {
  description = "Use the identifier value instead of identifier prefix. This provides a predictable ARN for replica, but does not avoid name conflicts"
  default     = false
}

variable "promote" {
  description = "Specifies that this run is promoting a replica to primary"
  default     = false
}

variable "mssql_timezone" {
  description = "(Optional) Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See [MSSQL User Guide](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_SQLServer.html#SQLServer.Concepts.General.TimeZone) for more information."
  default     = null
}

variable "delete_automated_backups" {
  description = "(Optional) Specifies whether to remove automated backups immediately after the DB instance is deleted."
  default     = true
}
