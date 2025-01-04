# Usage

```tf
module "github-selfhosted-runner" {
  source = "../../modules/github-selfhosted-runner/"

  ami             = var.ami
  project_id      = var.project_id
  environment     = var.environment
  branches_config = var.branches_config
  key_pair_name   = var.key_pair_name
  vpc_id          = var.vpc_id
  subnet_id       = var.subnet_id
  schedule_name   = var.schedule_name
  
  node_ver          = var.node_ver
  runner_ver        = var.runner_ver
  runner_name       = var.runner_name
  runner_token      = var.runner_token
  github_repo_url   = var.github_repo_url
  images_age        = var.images_age
  prometheus_host   = var.prometheus_host
  exporter_version  = var.exporter_version
  dns_zone_id       = var.dns_zone_id
  dns_record_name   = var.dns_record_name
}
```
