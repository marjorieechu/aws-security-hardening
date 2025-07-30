module "cloudcustodian" {
  source              = "./modules/cloudcustodian"
  region              = var.region
  key_name           = var.key_name
  custodian_instance_type = var.custodian_instance_type
  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_id
}

output "custodian_instance_id" {
  value = module.cloudcustodian.custodian_instance_id
}

output "custodian_public_ip" {
  value = module.cloudcustodian.custodian_public_ip
}
