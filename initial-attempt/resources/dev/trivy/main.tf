module "trivy" {
  source              = "./modules/trivy"
  region              = var.region
  key_name           = var.key_name
  trivy_instance_type = var.trivy_instance_type
  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_id
}

output "trivy_instance_id" {
  value = module.trivy.trivy_instance_id
}

output "trivy_public_ip" {
  value = module.trivy.trivy_public_ip
}
