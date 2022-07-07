<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

# FRB module to create AWS Relational Database Services Instances

https://aws.amazon.com/rds/
https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html

The current FRB guidelines are to only use postgres or ms-sql (sqlserver).

## Usage

### Examples

## Notes

## Regenerating docs
```bash
$ terraform-docs md . >README.md
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.5.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_subscription_filter.export_agent_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_cloudwatch_log_subscription_filter.export_error_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_cloudwatch_log_subscription_filter.export_postgres_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_db_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.mssql](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_parameter_group.pgsql](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_role.monitoring](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_kms_key.log_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_kms_key.p-i_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_kms_key.rds_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [terraform_remote_state.apollo](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.dataguise](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.managed_ad](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_parameters"></a> [additional\_parameters](#input\_additional\_parameters) | A list of DB parameters to apply, that go above and beyond the default PG we apply to all DBs. Note that parameters may differ from a DB family to another | `list` | `[]` | no |
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | Specifies the value for Allocated Storage. | `any` | n/a | yes |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible. | `bool` | `false` | no |
| <a name="input_app"></a> [app](#input\_app) | Name of the application | `any` | n/a | yes |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any database modifications are applied immediately, or during the next maintenance window. | `bool` | `false` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for. | `number` | `3` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | (Optional) The daily time range (in UTC) during which automated backups are created if they are enabled. Example: "09:46-10:16". Must not overlap with maintenance\_window. | `any` | `null` | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | (Optional, boolean) Copy all Instance tags to snapshots. | `bool` | `true` | no |
| <a name="input_cron_schedule_time"></a> [cron\_schedule\_time](#input\_cron\_schedule\_time) | Defines cron schedule time. | `string` | `"24hr"` | no |
| <a name="input_data_tags"></a> [data\_tags](#input\_data\_tags) | Data Classification tags to be passed into the resource storage & resource. | `map(string)` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Defines the database name used in the application. | `string` | `""` | no |
| <a name="input_delete_automated_backups"></a> [delete\_automated\_backups](#input\_delete\_automated\_backups) | (Optional) Specifies whether to remove automated backups immediately after the DB instance is deleted. | `bool` | `true` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | The database can't be deleted when this value is set to true. | `bool` | `false` | no |
| <a name="input_ds_enable"></a> [ds\_enable](#input\_ds\_enable) | Enable Active Directory Service auth (kerberos5) for the RDS DB, set to true '1' to use ManagedAD auth to the DB. | `bool` | `true` | no |
| <a name="input_enable_cloudwatch"></a> [enable\_cloudwatch](#input\_enable\_cloudwatch) | export logs to cloudwatch | `bool` | `true` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use | `any` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | (Optional) The engine version to use. If auto\_minor\_version\_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10). The actual engine version used is returned in the attribute engine\_version\_actual, which is not set in this module. For supported values, see the EngineVersion parameter in [API action CreateDBInstance](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html). | `any` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The environment the application is deployed in. | `string` | `""` | no |
| <a name="input_initial_password"></a> [initial\_password](#input\_initial\_password) | Initial password for the master DB user. Note that this will be stored in the state file. | `any` | n/a | yes |
| <a name="input_initial_username"></a> [initial\_username](#input\_initial\_username) | Initial username for the master DB user, defaults to z\_rds\_<var.database\_name>, unless there is no DB, which it then will be db\_admin. | `string` | `""` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance | `any` | n/a | yes |
| <a name="input_iops"></a> [iops](#input\_iops) | (Optional) The amount of provisioned IOPS. Setting this implies a storage\_type of 'io1'. | `any` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN for the KMS encryption key. | `any` | n/a | yes |
| <a name="input_license_model"></a> [license\_model](#input\_license\_model) | License model information for this DB instance. Optional, but required for some DB engines | `string` | `""` | no |
| <a name="input_log_group_kms_key"></a> [log\_group\_kms\_key](#input\_log\_group\_kms\_key) | The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested. | `string` | `"alias/frb-cloudwatch"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | (Optional) The window to perform maintenance in. Syntax: "ddd:hh24:mi-ddd:hh24:mi". Eg: "Mon:00:00-Mon:03:00". See [RDS Maintenance Window docs](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.Maintenance.html#AdjustingTheMaintenanceWindow) for more information. | `any` | `null` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | Specifies the value for Storage Autoscaling, which defaults to var.allocated\_storage + 5GB. | `string` | `""` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | (Optional) The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. | `number` | `60` | no |
| <a name="input_monitoring_role_arn"></a> [monitoring\_role\_arn](#input\_monitoring\_role\_arn) | (Optional) The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. | `string` | `""` | no |
| <a name="input_mssql_clr_enable"></a> [mssql\_clr\_enable](#input\_mssql\_clr\_enable) | For MS-SQL DBs parameter group only. Set to 1 if SSIS features are needed. | `number` | `0` | no |
| <a name="input_mssql_timezone"></a> [mssql\_timezone](#input\_mssql\_timezone) | (Optional) Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See [MSSQL User Guide](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_SQLServer.html#SQLServer.Concepts.General.TimeZone) for more information. | `any` | `null` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Specifies if the RDS instance is multi-AZ. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The DB name to create. If omitted, no database is created initially. | `any` | n/a | yes |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | AWS parameter group name for any RDS DB, which may override the FRB standard PG, as currently defined in mod-rds (affecting PGSQL). | `string` | `""` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | (Optional) Specifies whether Performance Insights are enabled. | `bool` | `true` | no |
| <a name="input_performance_insights_kms_key_id"></a> [performance\_insights\_kms\_key\_id](#input\_performance\_insights\_kms\_key\_id) | (Optional) The ARN for the KMS key to encrypt Performance Insights data. To enable, performance\_insights\_enabled needs to be set to true. Once KMS key is set, it can never be changed. | `string` | `""` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | (Optional) The amount of time in days to retain Performance Insights data.To enable, performance\_insights\_enabled needs to be set to true. Either 7 (7 days, the default) or 731 (2 years) are valid values. | `number` | `0` | no |
| <a name="input_pgsql_shared_preload_libraries"></a> [pgsql\_shared\_preload\_libraries](#input\_pgsql\_shared\_preload\_libraries) | For PostgreSQL DBs, the shared\_preload\_libraries Parameter Group value. | `list(string)` | <pre>[<br>  "pgaudit",<br>  "pg_stat_statements"<br>]</pre> | no |
| <a name="input_port"></a> [port](#input\_port) | The port on which the DB accepts connections. | `string` | `""` | no |
| <a name="input_promote"></a> [promote](#input\_promote) | Specifies that this run is promoting a replica to primary | `bool` | `false` | no |
| <a name="input_rds_backup_plan"></a> [rds\_backup\_plan](#input\_rds\_backup\_plan) | Defines a backup plan for rds. | `string` | `""` | no |
| <a name="input_rds_force_ssl"></a> [rds\_force\_ssl](#input\_rds\_force\_ssl) | Forces SSL when connecting to PostgreSQL or MS-SQL instance | `number` | `1` | no |
| <a name="input_replica"></a> [replica](#input\_replica) | Specifies that this resource is a Replica database, and to use this value as the source database. | `bool` | `false` | no |
| <a name="input_replicate_source_db"></a> [replicate\_source\_db](#input\_replicate\_source\_db) | Specifies that this resource is a Replica database, and to use this value as the source RDS database. defaults to null to ignore this argument | `any` | `null` | no |
| <a name="input_role"></a> [role](#input\_role) | Tag, role used for application | `string` | `"database"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security groups for RDS instance. | `list` | `[]` | no |
| <a name="input_security_groups_replica"></a> [security\_groups\_replica](#input\_security\_groups\_replica) | List of security groups for RDS replica instance. | `list` | `[]` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create this database from a snapshot. | `any` | `null` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB instance is encrypted. | `bool` | `true` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | (Optional) One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | TFE Workspace tags to be passed into the resource. | `map(string)` | n/a | yes |
| <a name="input_use_identifier"></a> [use\_identifier](#input\_use\_identifier) | Use the identifier value instead of identifier prefix. This provides a predictable ARN for replica, but does not avoid name conflicts | `bool` | `false` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC name the stack will be deployed in. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the RDS instance. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The connection endpoint. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
