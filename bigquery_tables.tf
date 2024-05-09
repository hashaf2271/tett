locals {
  youtube_content_id_name    = "youtube_content_id_data"
  youtube_video_tags_name    = "youtube_video_tags"
  youtube_file_metadata      = "youtube_file_metadata"
  twitter_data_folder_name   = "twitter_insights"
  facebook_data_folder_name  = "facebook"
  instagram_data_folder_name = "instagram"
  snapchat_data_folder_name  = "snapchat"
}

resource "google_bigquery_dataset" "raw_youtube" {
  dataset_id  = "raw_youtube"
  description = "Contains raw ingested data from youtube to be used for transformation"
  location    = "US"
}

resource "google_bigquery_table" "youtube_video_tags" {
  dataset_id = google_bigquery_dataset.raw_youtube.dataset_id
  table_id   = local.youtube_video_tags_name

  external_data_configuration {
    autodetect    = true
    source_format = "NEWLINE_DELIMITED_JSON"
    source_uris   = ["${google_storage_bucket.data_staging.url}/${local.youtube_video_tags_name}/*"]
    hive_partitioning_options {
      mode                     = "AUTO"
      require_partition_filter = false
      source_uri_prefix        = "${google_storage_bucket.data_staging.url}/${local.youtube_video_tags_name}"
    }
  }
}

resource "google_bigquery_dataset" "raw_twitter" {
  dataset_id  = "raw_twitter"
  description = "Contains raw ingested data from youtube to be used for transformation"
  location    = "US"
}

resource "google_bigquery_table" "twitter_insights" {
  dataset_id = google_bigquery_dataset.raw_twitter.dataset_id
  table_id   = local.twitter_data_folder_name

  external_data_configuration {
    autodetect    = true
    source_format = "NEWLINE_DELIMITED_JSON"
    source_uris   = ["${google_storage_bucket.data_staging.url}/${local.twitter_data_folder_name}/*"]
    hive_partitioning_options {
      mode              = "AUTO"
      source_uri_prefix = "${google_storage_bucket.data_staging.url}/${local.twitter_data_folder_name}"
    }
  }
}

resource "google_bigquery_dataset" "raw_facebook" {
  dataset_id  = "raw_facebook"
  description = "Contains raw ingested data from Facebook to be used for transformation"
  location    = "US"
}

resource "google_bigquery_table" "facebook_insights" {
  dataset_id = google_bigquery_dataset.raw_facebook.dataset_id
  count      = length(var.facebook_report_types)
  table_id   = "${local.facebook_data_folder_name}_${replace(var.facebook_report_types[count.index], "/", "_")}"

  external_data_configuration {
    autodetect    = true
    source_format = "NEWLINE_DELIMITED_JSON"
    source_uris   = ["${google_storage_bucket.data_staging.url}/${local.facebook_data_folder_name}/${var.facebook_report_types[count.index]}/*"]
    hive_partitioning_options {
      mode              = "AUTO"
      source_uri_prefix = "${google_storage_bucket.data_staging.url}/${local.facebook_data_folder_name}/${var.facebook_report_types[count.index]}"
    }
  }
}

resource "google_bigquery_dataset" "raw_instagram" {
  dataset_id  = "raw_instagram"
  description = "Contains raw ingested data from instagram to be used for transformation"
  location    = "US"
}

resource "google_bigquery_table" "instagram_insights" {
  dataset_id = google_bigquery_dataset.raw_instagram.dataset_id
  count      = length(var.instagram_report_types)
  table_id   = "${local.instagram_data_folder_name}_${replace(var.instagram_report_types[count.index], "/", "_")}"

  external_data_configuration {
    autodetect    = true
    source_format = "NEWLINE_DELIMITED_JSON"
    source_uris   = ["${google_storage_bucket.data_staging.url}/${local.instagram_data_folder_name}/${var.instagram_report_types[count.index]}/*"]
    hive_partitioning_options {
      mode              = "AUTO"
      source_uri_prefix = "${google_storage_bucket.data_staging.url}/${local.instagram_data_folder_name}/${var.instagram_report_types[count.index]}"
    }
  }
}

resource "google_bigquery_dataset" "raw_snapchat" {
  dataset_id  = "raw_snapchat"
  description = "Contains raw ingested data from snapchat to be used for transformation"
  location    = "US"
}

resource "google_bigquery_table" "snapchat_insights" {
  dataset_id = google_bigquery_dataset.raw_snapchat.dataset_id
  count      = length(var.snapchat_report_types)
  table_id   = "${local.snapchat_data_folder_name}_${replace(var.snapchat_report_types[count.index], "/", "_")}"

  external_data_configuration {
    autodetect    = true
    source_format = "NEWLINE_DELIMITED_JSON"
    source_uris   = ["${google_storage_bucket.data_staging.url}/${local.snapchat_data_folder_name}/${var.snapchat_report_types[count.index]}/*"]
    hive_partitioning_options {
      mode              = "AUTO"
      source_uri_prefix = "${google_storage_bucket.data_staging.url}/${local.snapchat_data_folder_name}/${var.snapchat_report_types[count.index]}"
    }
  }
}

resource "google_bigquery_dataset" "raw_youtube_file_metadata" {
  dataset_id  = "raw_youtube_file_metadata"
  description = "Contains raw ingested metadata from youtube-dl to be used for transformation"
  location    = "US"
}

resource "google_bigquery_table" "youtube_file_metadata_insights" {
  dataset_id = google_bigquery_dataset.raw_youtube_file_metadata.dataset_id
  count      = 1
  table_id   = local.youtube_file_metadata

  external_data_configuration {
    autodetect    = true
    source_format = "NEWLINE_DELIMITED_JSON"
    source_uris   = ["${google_storage_bucket.data_staging.url}/${local.youtube_file_metadata}/*"]
    hive_partitioning_options {
      mode              = "AUTO"
      source_uri_prefix = "${google_storage_bucket.data_staging.url}/${local.youtube_file_metadata}"
    }
  }
}

resource "google_bigquery_dataset" "raw_youtube_content_id_api_data" {
  dataset_id  = "raw_youtube_content_id_api_data"
  description = "Contains raw ingested metadata from the YouTube Content ID API For YouTube Assets"
  location    = "US"
}

resource "google_bigquery_table" "youtube_content_id_api_data" {
  dataset_id = google_bigquery_dataset.raw_youtube_content_id_api_data.dataset_id
  count      = 1
  table_id   = local.youtube_content_id_name

  external_data_configuration {
    autodetect    = true
    source_format = "NEWLINE_DELIMITED_JSON"
    source_uris   = ["${google_storage_bucket.data_staging.url}/${local.youtube_content_id_name}/*"]
    hive_partitioning_options {
      mode              = "AUTO"
      source_uri_prefix = "${google_storage_bucket.data_staging.url}/${local.youtube_content_id_name}"
    }
  }
}
