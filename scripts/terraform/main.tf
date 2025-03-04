provider "google" {
  project = var.project_id
  region  = var.region
}

# Cloud Storage bucket for function source code
resource "google_storage_bucket" "function_bucket" {
  name     = "${var.project_id}-function-source"
  location = var.region
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
}

# IAM entries to make the functions publicly accessible
resource "google_cloudfunctions_function_iam_member" "function1_invoker" {
  project        = google_cloudfunctions_function.function1.project
  region        = google_cloudfunctions_function.function1.region
  cloud_function = google_cloudfunctions_function.function1.name
  role          = "roles/cloudfunctions.invoker"
  member        = "allUsers"
}

resource "google_cloudfunctions_function_iam_member" "function2_invoker" {
  project        = google_cloudfunctions_function.function2.project
  region        = google_cloudfunctions_function.function2.region
  cloud_function = google_cloudfunctions_function.function2.name
  role          = "roles/cloudfunctions.invoker"
  member        = "allUsers"
}
