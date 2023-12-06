data "airbyte_workspace" "default" {}

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
    api_token = "xoxb-1234567890-1234567890123-999999999999999999999"
  })
  name                 = "Slack"
  source_definition_id = airbyte_source_definition.slack.source_definition_id
  workspace_id         = data.airbyte_workspace.default.workspace_id
}

module "airbyte_connection" {
  source  = "aballiet/airbyte-oss/connection"
  version = "~> 0"

  name                = "Slack"
  status              = "active"
  workspace_id        = data.airbyte_workspace.default.workspace_id
  source_id           = airbyte_source.slack.slack_source_id
  destination_id      = local.airbyte_bq_growth_production_V1
  destination_dataset = "airbyte_slack"
  normalize           = true

  schedule = {
    type = "manual"
  }

  streams = [
    {
      name                  = "threads"
      destination_sync_mode = "overwrite"
      sync_mode             = "full_refresh"
    },
    {
      name                  = "channel_members"
      destination_sync_mode = "overwrite"
      sync_mode             = "full_refresh"
    },
    {
      name                  = "	users"
      destination_sync_mode = "overwrite"
      sync_mode             = "full_refresh"
    },
  ]
}
