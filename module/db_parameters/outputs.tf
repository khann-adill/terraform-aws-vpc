output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = element(concat(aws_db_parameter_group.that.*.id, [""]), 0)
}
