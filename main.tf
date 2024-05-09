module "infrastructure" {
  source   = "../infra"
  location = local.region
  project  = local.project
}
