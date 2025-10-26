module "iam_oidc_github" {
  source         = "../../modules/iam_oidc_github"
  role_name      = "mini-prod-github-oidc-role"
  repo_full_name = "hoooooomkke/aws-mini-prod-env"
  project_prefix = "mini-prod-hoooo2025"

  tfstate_bucket = "mini-prod-tfstate-hoooo2025"
  tflock_table   = "mini-prod-tflock"
  region         = "ap-northeast-1"
  account_id     = "750570464141"
}

output "gha_role_arn" {
  value = module.iam_oidc_github.gha_role_arn
}