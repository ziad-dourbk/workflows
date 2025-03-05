variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy the cloud functions"
  type        = string
  default     = "us-central1"
}

variable "function_runtime" {
  description = "The runtime for the cloud functions"
  type        = string
  default     = "python39"
}


