📦 TerraWeek Day 5 — Modules: Reusable, Composable Infrastructure
Date: Thursday, 16th July 2026

Copy-pasting .tf blocks doesn't scale. Modules let you package infrastructure once and reuse it everywhere — across environments, teams, and projects. Today you'll write your own module, consume registry modules, and learn versioning. ♻️

🎯 Learning Goals
Understand what modules are and why they're the backbone of scalable Terraform.
Understand the root module vs child modules.
Write a local module with clear inputs (variables) and outputs.
Consume modules from the Terraform Registry and Git, and pin versions.
Use for_each to instantiate a module multiple times.
📝 Tasks
Task 1: Modules — the Why
Answer in your notes:

What is a module? What counts as the root module?
What are the benefits — reusability, consistency, encapsulation, versioning, testing?
What files make up a well-structured module (main.tf, variables.tf, outputs.tf, README.md)?

What is a module?

A module is a reusable collection of Terraform configuration files used to provision infrastructure.

What is the root module?

The root module is the Terraform configuration in the current working directory where Terraform commands are executed.

Benefits -
Reusability
Consistency
Encapsulation
Versioning
Easier testing and maintenance
Standard module structure
ec2_instance/
│
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md

Task 2: Write Your Own Module
Use the starter code in ./example. It contains:

A reusable module at ./example/modules/ec2_instance
A root module (./example) that calls it.
Study how the root resolves shared lookups once (AMI, subnet, security group) and passes them as inputs, then reads the module's outputs:

module "web_server" {
  source                 = "./modules/ec2_instance"
  name                   = "web"
  instance_type          = "t2.micro"
  environment            = "dev"
  ami                    = data.aws_ami.al2023.id   # resolved in the root
  subnet_id              = local.subnet_id
  vpc_security_group_ids = local.security_group_ids
}

output "web_public_ip" {
  value = module.web_server.public_ip
}
💡 Notice the module takes IDs as inputs instead of doing its own lookups. That keeps it reusable and avoids running the same data source once per instance.

cd example
terraform init      # note how Terraform initializes the module
terraform plan
terraform apply
terraform destroy

PS D:\python-train\terraweek\Day-5\Modules\ec2_instance> terraform init
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
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
PS D:\python-train\terraweek\Day-5\Modules\ec2_instance> terraform apply
var.ami
  AMI ID to launch. Resolve this once in the root module via a data source and pass it in.

  Enter a value: yes

var.name
  Logical name for this instance (used in tags).

  Enter a value: l

var.subnet_id
  ID of the subnet to launch the instance in.

  Enter a value: l

var.vpc_security_group_ids
  List of security group IDs to attach to the instance.

  Enter a value: l

╷
│ Error: Variables not allowed
│ 
│   on <value for var.vpc_security_group_ids> line 1:
│   (source code not available)
│ 
│ Variables may not be used here.
╵
╷
│ Error: No value for required variable
│ 
│   on variables.tf line 40:
│   40: variable "vpc_security_group_ids" {
│ 
│ The root module input variable "vpc_security_group_ids" is not set, and has no default value. Use a -var or -var-file
│ command line argument to provide a value for this variable.
╵
PS D:\python-train\terraweek\Day-5\Modules\ec2_instance> terraform destroy
var.ami
  AMI ID to launch. Resolve this once in the root module via a data source and pass it in.

  Enter a value: yes

var.name
  Logical name for this instance (used in tags).

  Enter a value: yes

var.subnet_id
  ID of the subnet to launch the instance in.

  Enter a value: yes

var.vpc_security_group_ids
  List of security group IDs to attach to the instance.

  Enter a value: t

╷
│ Error: Variables not allowed
│ 
│   on <value for var.vpc_security_group_ids> line 1:
│   (source code not available)
│ 
│ Variables may not be used here.
╵
╷
│ Error: No value for required variable
│ 
│   on variables.tf line 40:
│   40: variable "vpc_security_group_ids" {
│ 
│ The root module input variable "vpc_security_group_ids" is not set, and has no default value. Use a -var or -var-file
│ command line argument to provide a value for this variable.
╵
PS D:\python-train\terraweek\Day-5\Modules\ec2_instance> 

Task 3: Modular Composition (for_each)
Instantiate the same module multiple times to build multiple servers cleanly:

module "servers" {
  source   = "./modules/ec2_instance"
  for_each = toset(["app", "worker", "cache"])

  name                   = each.key
  instance_type          = "t2.micro"
  environment            = "dev"
  ami                    = data.aws_ami.al2023.id
  subnet_id              = local.subnet_id
  vpc_security_group_ids = local.security_group_ids
}
Add this to the root module and observe the plan.

PS D:\python-train\terraweek\Day-5> terraform plan
data.aws_ami.al2023: Reading...
data.aws_vpc.default: Reading...
data.aws_ami.al2023: Read complete after 2s [id=ami-0fd6240f599091088]
data.aws_vpc.default: Read complete after 3s [id=vpc-0b4f604ca1703c76e]
data.aws_security_group.default: Reading...
data.aws_subnets.default: Reading...
data.aws_security_group.default: Read complete after 0s [id=sg-0f372d66b84969637]
data.aws_subnets.default: Read complete after 0s [id=us-east-1]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # module.servers["app"].aws_instance.this will be created
  + resource "aws_instance" "this" {
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
      + subnet_id                            = "subnet-0d5da76f66d5c8d2a"
      + tags                                 = {
          + "Environment" = "dev"
          + "Module"      = "ec2_instance"
          + "Name"        = "dev-app"
        }
      + tags_all                             = {
          + "Day"         = "05"
          + "Environment" = "dev"
          + "ManagedBy"   = "terraform"
          + "Module"      = "ec2_instance"
          + "Name"        = "dev-app"
          + "Project"     = "terraweek-2026"
        }
      + tenancy                              = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = [
          + "sg-0f372d66b84969637",
        ]

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

  # module.servers["cache"].aws_instance.this will be created
  + resource "aws_instance" "this" {
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
      + subnet_id                            = "subnet-0d5da76f66d5c8d2a"
      + tags                                 = {
          + "Environment" = "dev"
          + "Module"      = "ec2_instance"
          + "Name"        = "dev-cache"
        }
      + tags_all                             = {
          + "Day"         = "05"
          + "Environment" = "dev"
          + "ManagedBy"   = "terraform"
          + "Module"      = "ec2_instance"
          + "Name"        = "dev-cache"
          + "Project"     = "terraweek-2026"
        }
      + tenancy                              = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = [
          + "sg-0f372d66b84969637",
        ]

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

  # module.servers["worker"].aws_instance.this will be created
  + resource "aws_instance" "this" {
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
      + subnet_id                            = "subnet-0d5da76f66d5c8d2a"
      + tags                                 = {
          + "Environment" = "dev"
          + "Module"      = "ec2_instance"
          + "Name"        = "dev-worker"
        }
      + tags_all                             = {
          + "Day"         = "05"
          + "Environment" = "dev"
          + "ManagedBy"   = "terraform"
          + "Module"      = "ec2_instance"
          + "Name"        = "dev-worker"
          + "Project"     = "terraweek-2026"
        }
      + tenancy                              = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = [
          + "sg-0f372d66b84969637",
        ]

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

  # module.web_server.aws_instance.this will be created
  + resource "aws_instance" "this" {
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
      + subnet_id                            = "subnet-0d5da76f66d5c8d2a"
      + tags                                 = {
          + "Environment" = "dev"
          + "Module"      = "ec2_instance"
          + "Name"        = "dev-web"
          + "Role"        = "frontend"
        }
      + tags_all                             = {
          + "Day"         = "05"
          + "Environment" = "dev"
          + "ManagedBy"   = "terraform"
          + "Module"      = "ec2_instance"
          + "Name"        = "dev-web"
          + "Project"     = "terraweek-2026"
          + "Role"        = "frontend"
        }
      + tenancy                              = (known after apply)
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = false
      + vpc_security_group_ids               = [
          + "sg-0f372d66b84969637",
        ]

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

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + server_ips    = {
      + app    = (known after apply)
      + cache  = (known after apply)
      + worker = (known after apply)
    }
  + web_public_ip = (known after apply)

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you
run "terraform apply" now.
PS D:\python-train\terraweek\Day-5> 


Task 4: Consume a Registry Module + Version Locking
Use a real, popular module from the Terraform Registry — e.g. the official AWS VPC module — and pin its version:

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"   # ✅ always pin registry/git module versions

  name = "terraweek-vpc"
  cidr = "10.0.0.0/16"
  # ...
}

PS D:\python-train\terraweek\Day-5> terraform init
Initializing the backend...

Initializing modules...
Downloading registry.terraform.io/terraform-aws-modules/vpc/aws 5.21.0 for vpc...
- vpc in .terraform\modules\vpc

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v6.55.0


Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
PS D:\python-train\terraweek\Day-5> 

Task 5: Ways to Lock Module Versions
Document, with code snippets, each way to pin a module source:

Registry: version = "~> 5.0" (also = 5.1.2, >= 5.0, < 6.0).
Git tag/ref: source = "git::https://github.com/org/repo.git//path?ref=v1.2.0".
Git commit SHA for immutability: ?ref=<full-sha>. Explain why pinning matters (reproducible builds, no surprise breaking changes).
📚 Reference the companion repo: aws_module_project/ is a real multi-environment example — one reusable my_app_infra_module (EC2 + S3 + DynamoDB) instantiated three times for dev / stg / prd with different instance sizes. Study how main.tf passes inputs and reads outputs.

🧠 ~> (Pessimistic Constraint) Cheatsheet
~> 5.0 → allows 5.x, not 6.0.
~> 5.1.0 → allows 5.1.x, not 5.2.0.



Registry
version = "~> 5.0"
Exact version
version = "= 5.1.2"
Version range
version = ">= 5.0, < 6.0"
Git tag
module "example" {
  source = "git::https://github.com/org/repo.git//module?ref=v1.2.0"
}
Git commit SHA
module "example" {
  source = "git::https://github.com/org/repo.git//module?ref=0123456789abcdef0123456789abcdef01234567"
}


Version pinning ensures reproducible deployments and prevents unexpected breaking changes caused by newer module releases.