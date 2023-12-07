terraform {
  required_providers {
    airbyte = {
      source  = "aballiet/airbyte-oss"
      version = "~> 1.1.0"
    }
  }
}

provider "airbyte" {
  server_url = "http://localhost:8001/api/"
  username   = "airbyte"
  password   = "password"
}