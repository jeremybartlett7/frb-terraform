data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  map_acct = {
    #330257083883 = "billing"
    872499233454 = "dev"
    326609289561 = "prod"
    #248310287184 = "security"
  }
  acct_id = data.aws_caller_identity.current.account_id
  acct    = local.map_acct[local.acct_id]
  region  = data.aws_region.current.name

  region_abbr = {
    us-west-2 = "w2"
    us-east-1 = "e1"
  }

  vpc_name = data.terraform_remote_state.vpc.outputs.name

  map_dg_suffix = {
    dss = "dss"
    pss = "pss"
  }
  _dataguise_stack = lookup(
    local.map_dg_suffix,
    replace(var.vpc_name, "/^(d|p).*(ss|os).*$/", "$1$2"),
    "",
  )
  dataguise_stack_suffix = local._dataguise_stack != "" ? "-${substr(local._dataguise_stack, 0, -1)}" : "-${local.acct}"
  dataguise_stack        = "dataguise${local.region == "us-east-1" ? "-dr" : ""}${local.dataguise_stack_suffix}"

  directory_stack = "directory-service-${local.acct}"
  apollo_stack    = "apollo-native-logging-${substr(local.acct, 0, 1)}ss"

  _kms_key_id = "arn:aws:kms:${local.region}:${local.acct_id}:alias/frb-rds"
  kms_key_id  = coalesce(var.kms_key_id, local._kms_key_id)

  _p-i_kms_key_id = "arn:aws:kms:${local.region}:${local.acct_id}:alias/frb-rds-pi"
  p-i_kms_key_id  = coalesce(var.performance_insights_kms_key_id, local._p-i_kms_key_id)
}

//--------------------------------------------------------------
// Values pulled in from other TF configs
data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    hostname     = "terraform.corp.firstrepublic.com"
    organization = "CLOUD"
    workspaces = {
      name = "net-vpc-${var.vpc_name}"
    }
  }
}

data "terraform_remote_state" "dataguise" {
  backend = "remote"

  config = {
    hostname     = "terraform.corp.firstrepublic.com"
    organization = "CLOUD"
    workspaces = {
      name = "res-${local.dataguise_stack}"
    }
  }
}

data "terraform_remote_state" "managed_ad" {
  backend = "remote"

  config = {
    hostname     = "terraform.corp.firstrepublic.com"
    organization = "CLOUD"
    workspaces = {
      name = "res-${local.directory_stack}"
    }
  }
}

data "terraform_remote_state" "apollo" {
  backend = "remote"

  config = {
    hostname     = "terraform.corp.firstrepublic.com"
    organization = "CLOUD"
    workspaces = {
      name = "res-${local.apollo_stack}"
    }
  }
}


// Lookup data from AWS account
data "aws_iam_role" "monitoring" {
  name = "rds-monitoring-role"
}

data "aws_kms_key" "rds_kms" {
  key_id = local.kms_key_id
}

data "aws_kms_key" "p-i_kms" {
  key_id = local.p-i_kms_key_id
}

data "aws_kms_key" "log_kms" {
  key_id = var.log_group_kms_key
}
