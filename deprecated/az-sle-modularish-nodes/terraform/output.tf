output "user" {
  description = "ssh and login username for hosts"
  value       = var.login_creds.user
}

output "ssh_private_key" {
  value = var.login_creds.private_key
}

output "client_hostname" {
  description = "list of hostnames created"
  value       = var.client_node_names

}

output "client_public_ip" {
  description = "list of public ips for client instances created"
  value       = module.vm-client.public_ip
}

output "client_private_ip" {
  description = "list of private ips for client instances created"
  value       = module.vm-client.private_ip
}

output "cluster_hostname" {
  description = "list of cluster hostnames created"
  value       = var.cluster_node_names
}

output "cluster_public_ip" {
  description = "list of public ips for cluster instances created"
  value       = module.vm-nodes.public_ip
}

output "cluster_private_ip" {
  description = "list of private ips for cluster instances created"
  value       = module.vm-nodes.private_ip
}

output "cluster_machine_id" {
  description = "list of machine ids for cluster instances created"
  value       = module.vm-nodes.vm-id
}
