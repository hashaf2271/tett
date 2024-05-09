output "function_id" {
  value = google_cloudfunctions2_function.function.id
}

output "service_account_email" {
  value = google_service_account.service_account.email
}
