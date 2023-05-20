# https://stackoverflow.com/questions/65143585/terraform-azure-sql-server-admin-password-change-forces-recreating-of-resource
resource "azurerm_mssql_server" "this" {
  name                         = var.sqlserver_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sqlserver_admin_user
  administrator_login_password = var.sqlserver_admin_password
  minimum_tls_version          = "1.2"

  lifecycle {
    ignore_changes = [administrator_login_password]
  }
}

resource "time_sleep" "wait_for_sqlserver" {
  create_duration = "180s"
  depends_on      = [azurerm_mssql_server.this]
}

resource "azurerm_sql_firewall_rule" "this" {
  name                = "Public"
  resource_group_name = azurerm_mssql_server.this.resource_group_name
  server_name         = azurerm_mssql_server.this.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}