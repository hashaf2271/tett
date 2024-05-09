data "archive_file" "function_script_check" {
  source_dir  = "../../python/src/${var.script_dir_name}/"
  output_path = ".terraform/archives/${var.script_dir_name}_check.zip"
  type        = "zip"
  excludes    = ["Dockerfile.dev", "Makefile", "requirements.in", "requirements-dev.in", "requirements-dev.txt", "tests.py", "lds_utilities"]
}

resource "null_resource" "utilities_library" {
  provisioner "local-exec" {
    command = var.uses_utilities_library ? "pip install --no-cache-dir keyring keyrings.google-artifactregistry-auth" : "echo 'lds-utilities not required'"
  }
  provisioner "local-exec" {
    working_dir = "../../python/src/${var.script_dir_name}"
    command     = var.uses_utilities_library ? "pip install -t ./lds_utilities --extra-index-url https://us-central1-python.pkg.dev/${var.project}/utilities/simple/ lds-utilities" : "true"
  }
  provisioner "local-exec" {
    working_dir = "../../python/src/${var.script_dir_name}"
    command     = var.uses_utilities_library ? "touch lds_utilities/__init__.py" : "true"
  }

  triggers = {
    trigger_time = timestamp()
  }
}

data "archive_file" "function_script" {
  depends_on = [null_resource.utilities_library]

  source_dir  = "../../python/src/${var.script_dir_name}/"
  output_path = ".terraform/archives/${var.script_dir_name}.zip"
  type        = "zip"
  excludes    = ["Dockerfile.dev", "Makefile", "requirements.in", "requirements-dev.in", "requirements-dev.txt", "tests.py"]
}

resource "google_storage_bucket_object" "script" {
  provider = google-beta
  bucket   = "artifacts-${var.project}"
  name     = "${var.name}_${data.archive_file.function_script.output_md5}.zip"
  source   = data.archive_file.function_script.output_path
}

resource "google_compute_region_network_endpoint_group" "function_neg" {
  provider              = google-beta
  name                  = var.name
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  cloud_run {
    service = var.name
  }
}

resource "google_cloudfunctions2_function" "function" {
  name     = var.name
  provider = google-beta
  location = "us-central1"
  build_config {
    runtime     = "python39"
    entry_point = var.trigger_function_name
    source {
      storage_source {
        bucket = google_storage_bucket_object.script.bucket
        object = google_storage_bucket_object.script.name
      }
    }
  }
  service_config {
    available_memory = "1024M"
    timeout_seconds  = 3600
    environment_variables = {
      GCP_PROJECT = var.project
    }
  }
}
