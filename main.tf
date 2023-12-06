data "airbyte_source_schema" "default" {
  source_id = var.source_id
}

resource "airbyte_operation" "normalization" {
  count = var.normalize ? 1 : 0
  name  = "Basic Normalization"

  operator_configuration = {
    operator_type = "normalization"
    normalization = {
      option = "basic"
    }
  }
  workspace_id = var.workspace_id
}

resource "airbyte_connection" "default" {
  name                            = var.name
  status                          = var.status
  source_id                       = var.source_id
  destination_id                  = var.destination_id
  namespace_definition            = "customformat"
  namespace_format                = var.destination_dataset
  non_breaking_changes_preference = "ignore"
  operation_ids                   = var.normalize ? [airbyte_operation.normalization.0.operation_id] : []
  prefix                          = var.prefix

  schedule_type = var.schedule.type
  schedule_data = var.schedule.type == "manual" ? null : {
    basic_schedule = {
      units     = var.schedule.data.units
      time_unit = var.schedule.data.time_unit
    }
  }
  resource_requirements = var.resource_requirements

  sync_catalog = {
    streams = [
      for stream in var.streams : {
        stream = {
          name                 = stream.name
          supported_sync_modes = element([for item in data.airbyte_source_schema.default.catalog.streams : item.stream.supported_sync_modes if item.stream.name == stream.name], 0)
          json_schema          = element([for item in data.airbyte_source_schema.default.catalog.streams : item.stream.json_schema if item.stream.name == stream.name], 0)
        }
        config = {
          selected              = true
          destination_sync_mode = stream.destination_sync_mode
          sync_mode             = stream.sync_mode
        }
      }
    ]
  }
}
