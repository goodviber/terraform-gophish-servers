################################################################################
# TERRAFORM CONFIG
################################################################################

terraform {
  required_version = ">= 0.13"
    required_providers {
      libvirt = {
        source  = "dmacvicar/libvirt"
        version = "0.6.2"
      }
      aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
      }
      civo = {
        source = "civo/civo"
        version = "0.9.23"
      }
      cloudflare = {
        source = "cloudflare/cloudflare"
        version = "~> 2.0"
      }
    }

  # backend "s3" {
   # bucket = "my-bucket-name"
   # key    = "global/s3/terraform.tfstate"
   # region = ${var.AWS_REGION}

   # dynamodb_table = "my-db-name"
   # encrypt        = true
  # }
}

# Configure the AWS Provider using credentials
provider "aws" {
  region = var.AWS_REGION
  shared_credentials_file = "/path_to/.aws/credentials"
}


# Configure the Civo provider using a token
#provider "civo" {
# token = SECRET_CIVO_TOKEN
#}

# Configure the Cloudflare provider - can set these as secrets
provider "cloudflare" {
  api_token = "api_token_here"
}
