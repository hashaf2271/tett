resource "google_storage_bucket" "data_staging" {
  name     = "data-staging-${var.project}"
  location = var.location
}

data "google_composer_environment" "data-composer-environment" {
  name    = "data-composer-environment"
  project = var.project
  region  = var.location
}

resource "google_storage_bucket_object" "dags" {
  for_each = fileset("../../dags", "*.py")

  bucket = split("/", replace(data.google_composer_environment.data-composer-environment.config.0.dag_gcs_prefix, "gs://", ""))[0]
  name   = "dags/${each.key}"
  source = "../../dags/${each.key}"
}

module "youtube_content_id_api" {
  source = "./ingest_function"

  name                   = "youtube-content-id-api-ingest"
  script_dir_name        = "youtube_content_id_api_ingest"
  trigger_function_name  = "youtube_content_id_api_ingest"
  output_bucket_name     = google_storage_bucket.data_staging.name
  uses_utilities_library = true

  project  = var.project
  location = var.location
}

module "youtube_video_tag_ingest_function" {
  source = "./ingest_function"

  name                   = "youtube-video-tag-ingest"
  script_dir_name        = "youtube_video_tag_ingest"
  trigger_function_name  = "youtube_video_tag_ingest"
  output_bucket_name     = google_storage_bucket.data_staging.name
  uses_utilities_library = false

  project  = var.project
  location = var.location
}

module "youtube_file_metadata_ingest" {
  source = "./ingest_function"

  name                   = "yt-file-metadata-ingest"
  script_dir_name        = "youtube_file_metadata_ingest"
  trigger_function_name  = "youtube_file_metadata_ingest"
  output_bucket_name     = google_storage_bucket.data_staging.name
  uses_utilities_library = false

  project  = var.project
  location = var.location
}

module "facebook_ingest_function" {
  source = "./ingest_function"

  name                   = "facebook"
  script_dir_name        = "facebook"
  trigger_function_name  = "facebook_ingest"
  output_bucket_name     = google_storage_bucket.data_staging.name
  uses_utilities_library = true

  project  = var.project
  location = var.location
}

module "instagram_ingest_function" {
  source = "./ingest_function"

  name                   = "instagram"
  script_dir_name        = "instagram"
  trigger_function_name  = "instagram_ingest"
  output_bucket_name     = google_storage_bucket.data_staging.name
  uses_utilities_library = true

  project  = var.project
  location = var.location
}

module "twitter_gcs_ingester" {
  source = "./ingest_function"

  name                   = "twitter-gcs-ingester"
  script_dir_name        = "twitter_gcs_ingester"
  trigger_function_name  = "twitter_ingester_function"
  output_bucket_name     = google_storage_bucket.data_staging.name
  uses_utilities_library = true

  project  = var.project
  location = var.location
}

module "snapchat" {
  source = "./ingest_function"

  name                   = "snapchat"
  script_dir_name        = "snapchat"
  trigger_function_name  = "snapchat_ingest"
  output_bucket_name     = google_storage_bucket.data_staging.name
  uses_utilities_library = false

  project  = var.project
  location = var.location
}
