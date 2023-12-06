## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_airbyte"></a> [airbyte-oss](https://registry.terraform.io/providers/aballiet/airbyte-oss/latest) | ~> 1.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_airbyte"></a> [airbyte-oss](https://registry.terraform.io/providers/aballiet/airbyte-oss/latest) | ~> 1.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [airbyte_connection.default](https://registry.terraform.io/providers/aballiet/airbyte-oss/latest/docs/resources/connection) | resource |
| [airbyte_operation.normalization](https://registry.terraform.io/providers/aballiet/airbyte-oss/latest/docs/resources/operation) | resource |
| [airbyte_source_schema.default](https://registry.terraform.io/providers/aballiet/airbyte-oss/latest/docs/data-sources/source_schema) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destination_dataset"></a> [destination\_dataset](#input\_destination\_dataset) | Destination dataset | `string` | n/a | yes |
| <a name="input_destination_id"></a> [destination\_id](#input\_destination\_id) | Airbyte destination ID | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the connection | `string` | n/a | yes |
| <a name="input_normalize"></a> [normalize](#input\_normalize) | n/a | `bool` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `""` | no |
| <a name="input_resource_requirements"></a> [resource\_requirements](#input\_resource\_requirements) | n/a | <pre>object({<br>    cpu_limit      = optional(string)<br>    cpu_request    = optional(string)<br>    memory_limit   = optional(string)<br>    memory_request = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | schedule = {<br>      type: "manual" or "basic"<br>      basic: {<br>        units: 24<br>        time\_unit: "hours"<br>      }<br>    }<br><br>    OR for cron schedule<br><br>    schedule = {<br>      type: "cron"<br>      cron: {<br>        cron\_expression: "0 0 * * *"<br>        cron\_timezone: "UTC"<br>      }<br>    } | <pre>object({<br>    type = string<br>    basic = optional(object({<br>      units     = number<br>      time_unit = string<br>    }))<br>    cron = optional(object({<br>      cron_expression = string<br>      cron_timezone   = string<br>      })<br>    )<br>  })</pre> | n/a | yes |
| <a name="input_source_id"></a> [source\_id](#input\_source\_id) | Airbyte source ID | `string` | n/a | yes |
| <a name="input_status"></a> [status](#input\_status) | n/a | `string` | `"active"` | no |
| <a name="input_streams"></a> [streams](#input\_streams) | streams = {<br>      [<br>        name : "Name of the stream"<br>        destination\_sync\_mode : "Can be [append, overwrite, append\_dedup]"<br>        sync\_mode : "Can be [full\_refresh, incremental]"<br>      ]<br>    } | <pre>list(object({<br>    name                  = string<br>    destination_sync_mode = string<br>    sync_mode             = string<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | Airbyte workspace ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_id"></a> [connection\_id](#output\_connection\_id) | n/a |
| <a name="output_connection_name"></a> [connection\_name](#output\_connection\_name) | n/a |
