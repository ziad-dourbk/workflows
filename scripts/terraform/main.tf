provider "google" {
  project = var.project_id
  region  = var.region
}

# Cloud Storage bucket for function source code
resource "google_storage_bucket" "function_bucket" {
  name     = "${var.project_id}-function-source"
  location = var.region
  
  # Fix for CKV_GCP_62
  logging {
    log_bucket = "${var.project_id}-function-source-logs"
  }
  
  # Fix for CKV_GCP_29
  uniform_bucket_level_access = true
  
  # Fix for CKV_GCP_114
  public_access_prevention = "enforced"
  
  # Fix for CKV_GCP_78
  versioning {
    enabled = true
  }
}

# First Cloud Function
resource "google_storage_bucket_object" "function1_source" {
  name   = "function1-source.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "function1-source.zip"  # You'll need to create this zip file
}

resource "google_cloudfunctions_function" "function1" {
  name        = "test-function-1"
  description = "First test function"
  runtime     = var.function_runtime

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function1_source.name
  trigger_http         = true
  entry_point         = "main"
  
  # Fix for CKV_GCP_124
  ingress_settings = "ALLOW_INTERNAL_ONLY"
  
  # Fix for CKV2_GCP_10
  https_trigger_security_level = "SECURE_ALWAYS"
}

# Second Cloud Function
resource "google_storage_bucket_object" "function2_source" {
  name   = "function2-source.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = "function2-source.zip"  # You'll need to create this zip file
}

resource "google_cloudfunctions_function" "function2" {
  name        = "test-function-2"
  description = "Second test function"
  runtime     = var.function_runtime

  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function2_source.name
  trigger_http         = true
  entry_point         = "main"
  
  # Fix for CKV_GCP_124
  ingress_settings = "ALLOW_INTERNAL_ONLY"
  
  # Fix for CKV2_GCP_10
  https_trigger_security_level = "SECURE_ALWAYS"
}

# Replace public access with specific service accounts or groups
resource "google_cloudfunctions_function_iam_member" "function1_invoker" {
  project        = google_cloudfunctions_function.function1.project
  region         = google_cloudfunctions_function.function1.region
  cloud_function = google_cloudfunctions_function.function1.name
  role           = "roles/cloudfunctions.invoker"
  # Fix for CKV_GCP_107
  member         = "serviceAccount:${var.service_account_email}"
}

resource "google_cloudfunctions_function_iam_member" "function2_invoker" {
  project        = google_cloudfunctions_function.function2.project
  region         = google_cloudfunctions_function.function2.region
  cloud_function = google_cloudfunctions_function.function2.name
  role           = "roles/cloudfunctions.invoker"
  # Fix for CKV_GCP_107
  member         = "serviceAccount:${var.service_account_email}"
}
