variable "location" {
  type        = string
  description = "The region all resources are located in"
}

variable "project" {
  type        = string
  description = "The project all resources are located in"
}

variable "name" {
  type        = string
  description = "The name of the Cloud Function"
}

variable "trigger_function_name" {
  type        = string
  description = "The entry point name of the Cloud Function"
}

variable "script_dir_name" {
  type        = string
  description = "The name of the Script directory"
}

variable "output_bucket_name" {
  type        = string
  description = "The name of the bucket to write to"
}

variable "uses_utilities_library" {
  type        = bool
  description = "Whether or not the lds-utilities library is used in the Cloud Function"
}
