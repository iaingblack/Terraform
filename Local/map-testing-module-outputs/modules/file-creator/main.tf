variable "filename"    { type = string }
variable "extension"   { type = string }
variable "content"     { type = string }
variable "client_type" { type = string }

resource "local_file" "this" {
  filename = "./files/${var.client_type}-${var.filename}.${var.extension}"
  content  = var.content
}

output "file_id" {
  value = local_file.this.id
}