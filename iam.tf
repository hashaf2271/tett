resource "google_service_account" "service_account" {
  account_id  = replace(var.name, "_", "-")
  description = "Account to run the ingest function"
  project     = var.project
}

resource "google_storage_bucket_iam_member" "bucket_objectcreator" {
  bucket = var.output_bucket_name
  member = "serviceAccount:${google_service_account.service_account.email}"
  role   = "roles/storage.objectCreator"
}

resource "google_project_iam_member" "secretmanager_accessor" {
  member  = "serviceAccount:${google_service_account.service_account.email}"
  role    = "roles/secretmanager.secretAccessor"
  project = var.project
}

resource "google_project_iam_member" "secretmanager_viewer" {
  member  = "serviceAccount:${google_service_account.service_account.email}"
  role    = "roles/secretmanager.viewer"
  project = var.project
}
