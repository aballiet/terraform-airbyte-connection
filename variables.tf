variable "name" {
  type        = string
  description = "Name of the connection"
}

variable "status" {
  type    = string
  default = "active"
}

variable "source_id" {
  type        = string
  description = "Airbyte source ID"
}

variable "destination_id" {
  type        = string
  description = "Airbyte destination ID"
}

variable "destination_dataset" {
  type        = string
  description = "Destination dataset"
}

variable "workspace_id" {
  type        = string
  description = "Airbyte workspace ID"
}

variable "normalize" {
  type = bool
}

variable "prefix" {
  type    = string
  default = ""
}

variable "schedule" {
  type = object({
    type = string
    basic = optional(object({
      units     = number
      time_unit = string
    }))
    cron = optional(object({
      cron_expression = string
      cron_timezone   = string
      })
    )
  })
  description = <<EOT
    schedule = {
      type: "manual" or "basic"
      basic: {
        units: 24
        time_unit: "hours"
      }
    }

    OR for cron schedule

    schedule = {
      type: "cron"
      cron: {
        cron_expression: "0 0 * * *"
        cron_timezone: "UTC"
      }
    }
  EOT

  validation {
    condition     = var.schedule.type == "manual" || var.schedule.type == "basic" || var.schedule.type == "cron"
    error_message = "Schedule type must be manual, basic or cron"
  }

  validation {
    condition     = var.schedule.type == "basic" && var.schedule.basic != null
    error_message = "Schedule type is basic but basic data is not provided"
  }
  validation {
    condition     = var.schedule.type == "cron" && var.schedule.cron != null
    error_message = "Schedule type is cron but cron data is not provided"
  }
}

variable "streams" {
  type = list(object({
    name                  = string
    destination_sync_mode = string
    sync_mode             = string
    })
  )
  description = <<EOT
    streams = {
      [
        name : "Name of the stream"
        destination_sync_mode : "Can be [append, overwrite, append_dedup]"
        sync_mode : "Can be [full_refresh, incremental]"
      ]
    }
  EOT

  validation {
    condition     = length(var.streams) > 0
    error_message = "At least one stream must be provided"
  }
}

variable "resource_requirements" {
  type = object({
    cpu_limit      = optional(string)
    cpu_request    = optional(string)
    memory_limit   = optional(string)
    memory_request = optional(string)
  })
  default = {}
}
