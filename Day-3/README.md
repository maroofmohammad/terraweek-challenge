☁️ TerraWeek Day 3 — Providers, Resources & Your First Cloud Infra
Date: Tuesday, 14th July 2026

Time to touch real cloud infrastructure! Today you'll configure a provider, use data sources and meta-arguments (for_each, count, depends_on, lifecycle), and provision a small network + compute stack on the cloud of your choice. 🏗️

🎯 Learning Goals
Configure a provider properly with version pinning and region.
Understand resources vs data sources.
Use meta-arguments: count, for_each, depends_on, lifecycle.
Provision, update, and destroy real cloud resources safely.
⚙️ Setup: Authenticate Your Cloud
Pick one provider and configure its CLI (never hard-code credentials in .tf files!):

AWS → aws configure (uses ~/.aws/credentials) — provider hashicorp/aws ~> 6.0
Azure → az login — provider hashicorp/azurerm ~> 4.0
GCP → gcloud auth application-default login — provider hashicorp/google ~> 6.0
Utho → API token env var — provider uthoplatforms/utho
🗺️ 60-Second Networking Primer (read this first!)


Today jumps from a single container to a real cloud network. Don't panic — here are the 6 building blocks you'll create, in plain English:

Block	What it is	Real-world analogy
VPC	Your own private, isolated network in the cloud (a range of IPs like 10.0.0.0/16)	Your own gated neighborhood
Subnet	A slice of the VPC's IPs (10.0.1.0/24), lives in one Availability Zone	A street in that neighborhood
Internet Gateway (IGW)	The door between your VPC and the public internet	The neighborhood's main gate
Route Table	Rules that say "traffic for the internet → go via the IGW"	Road signs / GPS routes
Security Group (SG)	A stateful virtual firewall on the instance (which ports are open)	A bouncer checking who gets in
EC2 Instance	The actual virtual machine running your app	A house on the street
How they connect: an EC2 instance lives in a subnet, inside a VPC. To reach the internet, the subnet's route table sends traffic through the IGW, and the security group decides which ports (e.g. 80/HTTP) are allowed in.

Internet ──▶ [IGW] ──▶ [Route Table] ──▶ [ Public Subnet ] ──▶ [SG] ──▶ [EC2]
                                          (inside the VPC)
💡 You'll build exactly this stack in Task 3. Re-read this table if a resource name ever feels confusing.

📝 Tasks
Task 1: Providers & Version Pinning
Add a terraform block with required_version and required_providers (pin with ~>).
Explain why version pinning matters and what the ~> (pessimistic) operator does.
Bonus: configure a second provider alias (e.g. a second AWS region) and explain when you'd use it.

Why version pinning?

Version pinning ensures Terraform always uses a compatible provider version. It prevents unexpected changes when newer provider versions introduce breaking changes.

Task 2: Resources vs Data Sources
Create at least one resource (something new).
Use at least one data source to read existing info (e.g. aws_ami, aws_availability_zones, or your default VPC).
Explain the difference: resources create/manage, data sources only read.
Task 3: Provision a Cloud Stack
Use the AWS starter code in ./example (or adapt to Azure/GCP). It builds a minimal, free-tier-friendly stack:

a VPC + public subnet + internet gateway + route table
a security group
an EC2 instance using a data source to find the latest Amazon Linux 2023 AMI

PS D:\python-train\terraweek\Day-3> terraform init
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 6.0"...
- Installing hashicorp/aws v6.55.0...
- Installed hashicorp/aws v6.55.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
PS D:\python-train\terraweek\Day-3> 


Why version pinning?

Version pinning ensures everyone uses compatible provider versions and prevents unexpected breaking changes.

What does ~> mean?

It allows patch and minor updates within the same compatible version but prevents automatic upgrades to the next major version.



PS D:\python-train\terraweek\Day-3> terraform apply
data.aws_availability_zones.available: Reading...
data.aws_ami.al2023: Reading...
data.aws_region.current: Reading...
data.aws_region.current: Read complete after 0s [id=us-east-1]
data.aws_region.virginia: Reading...
data.aws_region.virginia: Read complete after 0s [id=us-east-1]
data.aws_availability_zones.available: Read complete after 1s [id=us-east-1]
data.aws_ami.al2023: Read complete after 1s [id=ami-0fd6240f599091088]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami                                  = "ami-0fd6240f599091088"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + force_destroy                        = false
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t2.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_group_id                   = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + region                               = "us-east-1"
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "terraweek-web"
        }
      + tags_all                             = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "terraweek-web"
          + "Project"   = "terraweek-2026"
        }
      + tenancy                              = (known after apply)
      + user_data                            = <<-EOT
            #!/bin/bash
            dnf install -y nginx
            echo "<h1>Hello from TerraWeek 2026 🚀</h1>" > /usr/share/nginx/html/index.html
            systemctl enable --now nginx
        EOT
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options (known after apply)

      + network_interface (known after apply)

      + primary_network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device (known after apply)

      + secondary_network_interface (known after apply)
    }

  # aws_internet_gateway.igw will be created
  + resource "aws_internet_gateway" "igw" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + region   = "us-east-1"
      + tags     = {
          + "Name" = "terraweek-igw"
        }
      + tags_all = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "terraweek-igw"
          + "Project"   = "terraweek-2026"
        }
      + vpc_id   = (known after apply)
    }

  # aws_route_table.public will be created
  + resource "aws_route_table" "public" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + region           = "us-east-1"
      + route            = [
          + {
              + cidr_block                 = "0.0.0.0/0"
              + gateway_id                 = (known after apply)
                # (12 unchanged attributes hidden)
            },
        ]
      + tags             = {
          + "Name" = "terraweek-public-rt"
        }
      + tags_all         = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "terraweek-public-rt"
          + "Project"   = "terraweek-2026"
        }
      + vpc_id           = (known after apply)
    }

  # aws_route_table_association.public will be created
  + resource "aws_route_table_association" "public" {
      + id             = (known after apply)
      + region         = "us-east-1"
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_security_group.web will be created
  + resource "aws_security_group" "web" {
      + arn                    = (known after apply)
      + description            = "Allow HTTP inbound and all outbound"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "All outbound"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "HTTP from anywhere"
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
        ]
      + name                   = "terraweek-web-sg"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + region                 = "us-east-1"
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "terraweek-web-sg"
        }
      + tags_all               = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "terraweek-web-sg"
          + "Project"   = "terraweek-2026"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.public will be created
  + resource "aws_subnet" "public" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block                                = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + region                                         = "us-east-1"
      + tags                                           = {
          + "Name" = "terraweek-public-subnet"
        }
      + tags_all                                       = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "terraweek-public-subnet"
          + "Project"   = "terraweek-2026"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.main will be created
  + resource "aws_vpc" "main" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + region                               = "us-east-1"
      + tags                                 = {
          + "Name" = "terraweek-vpc"
        }
      + tags_all                             = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "terraweek-vpc"
          + "Project"   = "terraweek-2026"
        }
    }

Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + ami_id         = "ami-0fd6240f599091088"
  + default_region = "us-east-1"
  + instance_id    = (known after apply)
  + public_ip      = (known after apply)
  + second_region  = "us-east-1"
  + web_url        = (known after apply)
╷
│ Warning: Deprecated value used
│ 
│   on outputs.tf line 22, in output "default_region":
│   22:   value = data.aws_region.current.name
│ 
│   The deprecation originates from data.aws_region.current.name
│ 
│ name is deprecated. Use region instead.
│ 
│ (and 3 more similar warnings elsewhere)
╵

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.main: Creating...
aws_vpc.main: Creation complete after 5s [id=vpc-0628857ccd5da3d9b]
aws_internet_gateway.igw: Creating...
aws_subnet.public: Creating...
aws_security_group.web: Creating...
aws_internet_gateway.igw: Creation complete after 2s [id=igw-0240d9d76659f3bfc]
aws_route_table.public: Creating...
aws_route_table.public: Creation complete after 3s [id=rtb-03c5a6b5b950e0657]
aws_security_group.web: Creation complete after 6s [id=sg-0a67dadb20a2019bd]
aws_subnet.public: Still creating... [00m10s elapsed]
aws_subnet.public: Creation complete after 13s [id=subnet-0f7dd8fc4b8ee1cc5]
aws_route_table_association.public: Creating...
aws_instance.web: Creating...
aws_route_table_association.public: Creation complete after 1s [id=rtbassoc-0214c1d60c128e18b]
aws_instance.web: Still creating... [00m10s elapsed]
aws_instance.web: Creation complete after 17s [id=i-07c8e648b9cc07e70]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

ami_id = "ami-0fd6240f599091088"
default_region = "us-east-1"
instance_id = "i-07c8e648b9cc07e70"
public_ip = "3.236.174.197"
second_region = "us-east-1"
web_url = "http://3.236.174.197"
PS D:\python-train\terraweek\Day-3> 





Task 4: Meta-Arguments in Action
Extend the config to practice each of these:

count — create N identical resources (e.g. N EC2 instances).
for_each — create resources from a map/set (preferred over count for named things).
depends_on — force an explicit ordering.
lifecycle — try create_before_destroy, prevent_destroy, and ignore_changes.
lifecycle {
  create_before_destroy = true
  ignore_changes        = [tags["LastModified"]]
}


PS D:\python-train\terraweek\Day-3> terraform plan
data.aws_availability_zones.available: Reading...
data.aws_ami.al2023: Reading...
data.aws_region.current: Reading...
aws_vpc.main: Refreshing state... [id=vpc-0628857ccd5da3d9b]
data.aws_region.current: Read complete after 0s [id=us-east-1]
data.aws_region.virginia: Reading...
data.aws_region.virginia: Read complete after 0s [id=us-east-1]
data.aws_availability_zones.available: Read complete after 1s [id=us-east-1]
data.aws_ami.al2023: Read complete after 1s [id=ami-0fd6240f599091088]
aws_internet_gateway.igw: Refreshing state... [id=igw-0240d9d76659f3bfc]
aws_subnet.public: Refreshing state... [id=subnet-0f7dd8fc4b8ee1cc5]
aws_security_group.web: Refreshing state... [id=sg-0a67dadb20a2019bd]
aws_route_table.public: Refreshing state... [id=rtb-03c5a6b5b950e0657]
aws_route_table_association.public: Refreshing state... [id=rtbassoc-0214c1d60c128e18b]
aws_instance.web: Refreshing state... [id=i-07c8e648b9cc07e70]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_security_group.count_demo[0] will be created
  + resource "aws_security_group" "count_demo" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "count-demo-0"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + region                 = "us-east-1"
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "count-demo-0"
        }
      + tags_all               = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "count-demo-0"
          + "Project"   = "terraweek-2026"
        }
      + vpc_id                 = "vpc-0628857ccd5da3d9b"
    }

  # aws_security_group.count_demo[1] will be created
  + resource "aws_security_group" "count_demo" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "count-demo-1"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + region                 = "us-east-1"
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "count-demo-1"
        }
      + tags_all               = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "count-demo-1"
          + "Project"   = "terraweek-2026"
        }
      + vpc_id                 = "vpc-0628857ccd5da3d9b"
    }

Plan: 2 to add, 0 to change, 0 to destroy.
╷
│ Warning: Deprecated value used
│ 
│   on outputs.tf line 22, in output "default_region":
│   22:   value = data.aws_region.current.name
│ 
│   The deprecation originates from data.aws_region.current.name
│ 
│ name is deprecated. Use region instead.
│ 
│ (and 3 more similar warnings elsewhere)
╵

───────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these
actions if you run "terraform apply" now.
PS D:\python-train\terraweek\Day-3> 


PS D:\python-train\terraweek\Day-3> terraform plan
data.aws_region.virginia: Reading...
data.aws_region.virginia: Read complete after 0s [id=us-east-1]
data.aws_availability_zones.available: Reading...
data.aws_ami.al2023: Reading...
data.aws_region.current: Reading...
aws_vpc.main: Refreshing state... [id=vpc-0628857ccd5da3d9b]
data.aws_region.current: Read complete after 0s [id=us-east-1]
data.aws_availability_zones.available: Read complete after 1s [id=us-east-1]
data.aws_ami.al2023: Read complete after 2s [id=ami-0fd6240f599091088]
aws_internet_gateway.igw: Refreshing state... [id=igw-0240d9d76659f3bfc]
aws_subnet.public: Refreshing state... [id=subnet-0f7dd8fc4b8ee1cc5]
aws_security_group.web: Refreshing state... [id=sg-0a67dadb20a2019bd]
aws_route_table.public: Refreshing state... [id=rtb-03c5a6b5b950e0657]
aws_route_table_association.public: Refreshing state... [id=rtbassoc-0214c1d60c128e18b]
aws_instance.web: Refreshing state... [id=i-07c8e648b9cc07e70]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_security_group.count_demo[0] will be created
  + resource "aws_security_group" "count_demo" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "count-demo-0"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + region                 = "us-east-1"
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "count-demo-0"
        }
      + tags_all               = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "count-demo-0"
          + "Project"   = "terraweek-2026"
        }
      + vpc_id                 = "vpc-0628857ccd5da3d9b"
    }

  # aws_security_group.count_demo[1] will be created
  + resource "aws_security_group" "count_demo" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "count-demo-1"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + region                 = "us-east-1"
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "count-demo-1"
        }
      + tags_all               = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "count-demo-1"
          + "Project"   = "terraweek-2026"
        }
      + vpc_id                 = "vpc-0628857ccd5da3d9b"
    }

  # aws_security_group.foreach_demo["app"] will be created
  + resource "aws_security_group" "foreach_demo" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "app"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + region                 = "us-east-1"
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "app"
        }
      + tags_all               = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "app"
          + "Project"   = "terraweek-2026"
        }
      + vpc_id                 = "vpc-0628857ccd5da3d9b"
    }

  # aws_security_group.foreach_demo["db"] will be created
  + resource "aws_security_group" "foreach_demo" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "db"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + region                 = "us-east-1"
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "db"
        }
      + tags_all               = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "db"
          + "Project"   = "terraweek-2026"
        }
      + vpc_id                 = "vpc-0628857ccd5da3d9b"
    }

  # aws_security_group.foreach_demo["web"] will be created
  + resource "aws_security_group" "foreach_demo" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = (known after apply)
      + name                   = "web"
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + region                 = "us-east-1"
      + revoke_rules_on_delete = false
      + tags                   = {
          + "Name" = "web"
        }
      + tags_all               = {
          + "Day"       = "03"
          + "ManagedBy" = "terraform"
          + "Name"      = "web"
          + "Project"   = "terraweek-2026"
        }
      + vpc_id                 = "vpc-0628857ccd5da3d9b"
    }

Plan: 5 to add, 0 to change, 0 to destroy.
╷
│ Warning: Deprecated value used
│ 
│   on outputs.tf line 22, in output "default_region":
│   22:   value = data.aws_region.current.name
│ 
│   The deprecation originates from data.aws_region.current.name
│ 
│ name is deprecated. Use region instead.
│ 
│ (and 3 more similar warnings elsewhere)
╵

───────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these
actions if you run "terraform apply" now.
PS D:\python-train\terraweek\Day-3> 


digraph G {
  rankdir = "RL";
  node [shape = rect, fontname = "sans-serif"];
  "data.aws_ami.al2023" [label="data.aws_ami.al2023"];
  "data.aws_availability_zones.available" [label="data.aws_availability_zones.available"];
  "data.aws_region.current" [label="data.aws_region.current"];
  "data.aws_region.virginia" [label="data.aws_region.virginia"];
  "aws_instance.web" [label="aws_instance.web"];
  "aws_internet_gateway.igw" [label="aws_internet_gateway.igw"];
  "aws_route_table.public" [label="aws_route_table.public"];
  "aws_route_table_association.public" [label="aws_route_table_association.public"];
  "aws_security_group.count_demo" [label="aws_security_group.count_demo"];
  "aws_security_group.foreach_demo" [label="aws_security_group.foreach_demo"];
  "aws_security_group.web" [label="aws_security_group.web"];
  "aws_subnet.public" [label="aws_subnet.public"];
  "aws_vpc.main" [label="aws_vpc.main"];
  "aws_instance.web" -> "data.aws_ami.al2023";
  "aws_instance.web" -> "aws_security_group.web";
  "aws_instance.web" -> "aws_subnet.public";
  "aws_internet_gateway.igw" -> "aws_vpc.main";
  "aws_route_table.public" -> "aws_internet_gateway.igw";
  "aws_route_table_association.public" -> "aws_route_table.public";
  "aws_route_table_association.public" -> "aws_subnet.public";
  "aws_security_group.count_demo" -> "aws_vpc.main";
  "aws_security_group.foreach_demo" -> "aws_vpc.main";
  "aws_security_group.web" -> "aws_vpc.main";
  "aws_subnet.public" -> "data.aws_availability_zones.available";
  "aws_subnet.public" -> "aws_vpc.main";
}



