resource "google_service_account" "pubsub_notifier" {
  account_id  = "pubsub-notifier"
  description = "Account to run the youtube_video_tag_ingest Cloud Function"
  project     = var.project
}

resource "google_cloudfunctions_function_iam_member" "pubsub_notifier_cloudfunctions_invoke" {
  cloud_function = google_cloudfunctions_function.pubsub_notifier.name
  member         = "serviceAccount:${google_service_account.pubsub_notifier.email}"
  role           = "roles/cloudfunctions.invoker"
}

resource "google_project_iam_member" "yt_video_tags_bigquery_dataviewer" {
  for_each = toset(["roles/bigquery.dataViewer", "roles/bigquery.jobUser", "roles/bigquery.resourceViewer"])
  project  = var.project
  role     = each.key
  member   = "serviceAccount:${module.youtube_video_tag_ingest_function.service_account_email}"
}

resource "google_project_iam_member" "youtube_video_tag_bigquerydataviewer" {
  member  = "serviceAccount:${module.youtube_video_tag_ingest_function.service_account_email}"
  role    = "roles/bigquery.dataViewer"
  project = var.project
}
