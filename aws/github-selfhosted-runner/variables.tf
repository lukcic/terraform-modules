variable "ami" {
  description = "AMI ID. If not set, the latest Ubuntu Jammy will be used."
  type = object({
    id = optional(string)
  })
}

variable "project_id" {
  description = "Name of the project"
}

variable "environment" {
  description = "Deployment Environment"
}

variable branches_config {
  description = "Branch names and IPs"
  type = map(object({
    name    = string
    ip      = string
  }))
}

variable "key_pair_name" {
  description = "EC2 key pair name"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "subnet_id" {
  description = "ID of the public subnet"
}

variable "schedule_name" {
  description = "Value of 'Schedule' tag used for turning off instance at non-work hours"
}

variable "node_ver" {
  type = string
  description = "Version of node.js used in project"
}

variable "runner_ver" {
  type = string
  description = "Version of GitHub Runner"
}

variable "runner_token" {
  type = string
  description = "GH Actions token generated in project settings"
}

variable "runner_name" {
  type = string
  description = "GH Actions runner name"
}

variable "github_repo_url" {
  type = string
  description = "GitHub repo url"
}

variable "images_age" {
  type = string
  description = "How long store Docker Images ex: 168h"
}

variable "prometheus_host" {
  type = string
  description = "IP of metrics collector"
}

variable "exporter_version" {
  type = string
  description = "Node Exporter version"
}

variable "dns_zone_id" {
  type = string
  description = "Domain to create DNS record"
}

variable "dns_record_name" {
  type = string
  description = "Hostname of runner"
}