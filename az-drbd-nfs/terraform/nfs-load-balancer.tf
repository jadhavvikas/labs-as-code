# An internal load balancer will front the cluster nodes
resource "azurerm_lb" "nfs_lb" {
  name                = "lb-${var.cluster_service_name}"
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location
  sku                 = "Basic"

  frontend_ip_configuration {
    name                          = var.cluster_service_name
    subnet_id                     = azurerm_subnet.common.id
    private_ip_address_allocation = "Dynamic"
  }

  frontend_ip_configuration {
    name                          = "dummy_test_to_remove"
    subnet_id                     = azurerm_subnet.common.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = azurerm_resource_group.common.tags
}

# The load balancer probes are defined separately
resource "azurerm_lb_probe" "nfs_lb_probe61000" {
  resource_group_name = azurerm_resource_group.common.name
  loadbalancer_id     = azurerm_lb.nfs_lb.id
  name                = "tcp-61000"
  port                = 61000
  protocol            = "Tcp"
  interval_in_seconds = 5
  number_of_probes    = 2
}

# As are the backend pools
resource "azurerm_lb_backend_address_pool" "nfs_lb" {
  resource_group_name = azurerm_resource_group.common.name
  loadbalancer_id     = azurerm_lb.nfs_lb.id
  name                = "${var.cluster_service_name}-pool"
}

# Which, of course, must be then associated to the nics of cluster nodes
resource "azurerm_network_interface_backend_address_pool_association" "nfs_lb" {
  count                   = length(var.cluster_hostnames)
  network_interface_id    = azurerm_network_interface.clustervms[count.index].id
  ip_configuration_name   = "eth0"
  backend_address_pool_id = azurerm_lb_backend_address_pool.nfs_lb.id
}

# And finally there has to be a load balancing rules
resource "azurerm_lb_rule" "cluster_rule_nfs_tcp" {
  name                           = "lb-rule-nfs-tcp"
  resource_group_name            = azurerm_resource_group.common.name
  loadbalancer_id                = azurerm_lb.nfs_lb.id
  protocol                       = "Tcp"
  frontend_port                  = 2049
  backend_port                   = 2049
  frontend_ip_configuration_name = var.cluster_service_name
  probe_id                       = azurerm_lb_probe.nfs_lb_probe61000.id
  idle_timeout_in_minutes        = 30
  enable_floating_ip             = true
}

resource "azurerm_lb_rule" "cluster_rule_nfs_udp" {
  name                           = "lb-rule-nfs-udp"
  resource_group_name            = azurerm_resource_group.common.name
  loadbalancer_id                = azurerm_lb.nfs_lb.id
  protocol                       = "Udp"
  frontend_port                  = 2049
  backend_port                   = 2049
  frontend_ip_configuration_name = var.cluster_service_name
  probe_id                       = azurerm_lb_probe.nfs_lb_probe61000.id
  idle_timeout_in_minutes        = 30
  enable_floating_ip             = true
}
