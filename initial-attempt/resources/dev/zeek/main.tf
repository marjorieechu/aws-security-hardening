module "zeek" {
  source              = "./modules/zeek"
  region              = var.region
  key_name           = var.key_name
  zeek_instance_type = var.zeek_instance_type
  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_id
}

output "zeek_instance_id" {
  value = module.zeek.zeek_instance_id
}

output "zeek_public_ip" {
  value = module.zeek.zeek_public_ip
}
