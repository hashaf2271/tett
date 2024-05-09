variable "location" {
  type        = string
  description = "The region all resources are located in"
}

variable "project" {
  type        = string
  description = "The project all resources are located in"
}

variable "facebook_report_types" {
  type        = list(string)
  description = "report types used in facebook or instagram"
  default     = ["ad_report/ads", "ad_report/adsets", "ad_report/campaigns", "page_report", "post_report", "video_report", "page_names"]
}

variable "instagram_report_types" {
  type        = list(string)
  description = "report types used in facebook or instagram"
  default     = ["media_report", "story_report", "video_report", "user_insight_report/day_param", "user_insight_report/audience"]
}

variable "snapchat_report_types" {
  type        = list(string)
  description = "report types used in snapchat"
  default     = ["publisher_analytics_report_audience", "publisher_analytics_report_behaviour", "publisher_revenue_report", "story_revenue_report"]
}
