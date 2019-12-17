provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_instance" "web" {
  # ...

  provisioner "chef" {
    attributes_json = <<EOF
      {
        "key": "value",
        "app": {
          "cluster1": {
            "nodes": [
              "webserver1",
              "webserver2"
            ]
          }
        }
      }
    EOF

    environment     = "_default"
    client_options  = ["chef_license 'accept'"]
    run_list        = ["cookbook::recipe"]
    node_name       = "webserver1"
    secret_key      = "${file("../encrypted_data_bag_secret")}"
    server_url      = "https://chef.company.com/organizations/org1"
    recreate_client = true
    user_name       = "bork"
    user_key        = "${file("../bork.pem")}"
    version         = "12.4.1"
    # If you have a self signed cert on your chef server change this to :verify_none
    ssl_verify_mode = ":verify_peer"
  }
}