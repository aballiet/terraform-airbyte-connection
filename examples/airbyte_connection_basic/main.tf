locals {
  bq_destination_id = "e03724f5-987b-4f97-abf1-3ed54f3ea126"
}

data "airbyte_workspace" "default" {
  workspace_id = "3bd35192-80b7-40ff-82a7-956845321660"
}

# Here we are using the Slack official source connector
# But you can use any source connector you want from your own registry
resource "airbyte_source_definition" "slack" {
  source_definition = {
    name              = "Slack"
    docker_repository = "airbyte/source-slack"
    docker_image_tag  = "0.3.5"
    documentation_url = "https://api.slack.com/messaging/managing"
  }
  workspace_id = data.airbyte_workspace.default.workspace_id
}

# In the `connection_configuration` you can pass any configuration you want
# Based on the connector spec
# In this Slack example, configuration matches :
# https://github.com/airbytehq/airbyte/blob/master/airbyte-integrations/connectors/source-slack/source_slack/spec.json#L9
resource "airbyte_source" "slack" {
  connection_configuration = jsonencode({
    api_token       = "xoxb-1234567890-1234567890123-999999999999999999999"
    start_date      = "2023-01-01T00:00:00Z"
    lookback_window = 7
    join_channels   = false
    channel_filter  = ["your-channel-name"]
  })
  name                 = "Slack"
  source_definition_id = airbyte_source_definition.slack.source_definition_id
  workspace_id         = data.airbyte_workspace.default.workspace_id
}

module "airbyte_connection" {
  source              = "aballiet/connection/airbyte"
  version             = "0.0.5"
  name                = "Slack Basic"
  status              = "active"
  workspace_id        = data.airbyte_workspace.default.workspace_id
  source_id           = airbyte_source.slack.source_id
  destination_id      = local.bq_destination_id
  destination_dataset = "airbyte_slack"
  normalize           = true

  schedule = {
    type = "basic"
    basic = {
      units     = 24
      time_unit = "hours"
    }
  }

  streams = [
    {
      name                  = "channel_members"
      destination_sync_mode = "overwrite"
      sync_mode             = "full_refresh"
    },
    {
      name                  = "users"
      destination_sync_mode = "overwrite"
      sync_mode             = "full_refresh"
    },
  ]
}
