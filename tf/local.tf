locals {
  path_root_list = split("/", path.root)
  path_root_len  = length(local.path_root_list)
  parent_dir     = element(local.path_root_list, local.path_root_len - 1)

  region     = data.aws_region._.name
  account_id = data.aws_caller_identity._.account_id
}

locals {
  project_name = var.project_name != "" ? var.project_name : "dev-project"

  ecr_repo      = var.ecr_repo != "" ? var.ecr_repo : local.project_name
  ecr_repo_full = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${local.ecr_repo}:${var.ecr_repo_tag}"

  ecs_name_cluster         = local.project_name
  ecs_name_service         = local.project_name
  ecs_name_task_definition = local.project_name
  ecs_iam_role_name        = "${local.project_name}-ecs"
  ecs_role_arn             = var.ecs_role_arn != "" ? var.ecs_role_arn : "arn:aws:iam::${local.account_id}:role/${local.ecs_iam_role_name}"

  log_group_count = var.log_group_count

  env_length    = length(var.env_keys) == length(var.env_vals) ? length(var.env_keys) : 0
  env_vars_list = formatlist("{\"name\":\"%s\",\"value\":\"%s\"}", var.env_keys, var.env_vals)
  env_vars      = local.env_length > 0 ? join(",", local.env_vars_list) : "{\"name\":\"TF_AUTHOR\",\"value\":\"rms1000watt\"}"

  alb_count = var.include_alb ? 1 : 0

  out_alb_dns = coalescelist(aws_alb._.*.dns_name, tolist(["nil"]))
}
