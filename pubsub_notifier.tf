locals {
  notifier_function_name = "pubsub_notifier"
}

resource "google_pubsub_topic" "pipeline_topic" {
  name    = "data_pipeline_status"
  project = var.project
}

data "archive_file" "pubsub_notifier_script" {
  source_dir  = "../../python/src/${local.notifier_function_name}/"
  output_path = ".terraform/archives/${local.notifier_function_name}.zip"
  type        = "zip"
  excludes    = ["Dockerfile.dev", "Makefile", "requirements.in", "requirements-dev.in", "requirements-dev.txt", "tests.py"]
}

resource "google_storage_bucket_object" "pubsub_notifier_script" {
  bucket = "artifacts-${var.project}"
  name   = "${local.notifier_function_name}_${data.archive_file.pubsub_notifier_script.output_md5}.zip"
  source = data.archive_file.pubsub_notifier_script.output_path
}

resource "google_cloudfunctions_function" "pubsub_notifier" {
  name    = local.notifier_function_name
  runtime = "python39"

  entry_point           = local.notifier_function_name
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket_object.pubsub_notifier_script.bucket
  source_archive_object = google_storage_bucket_object.pubsub_notifier_script.name
  timeout               = 60
  service_account_email = google_service_account.pubsub_notifier.email

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.pipeline_topic.id
  }
  environment_variables = {
    GCP_PROJECT = var.project
  }
}
