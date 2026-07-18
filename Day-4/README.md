🗄️ TerraWeek Day 4 — State & Remote Backends (Native Locking)
Date: Wednesday, 15th July 2026

Terraform's state is the single most important concept for working on a team. Today you'll understand what state is, why it's sensitive, and how to store it remotely and safely — using the modern S3 native state locking (no DynamoDB needed anymore!). 🔐

🎯 Learning Goals
Understand what Terraform state is and why it exists.
Use the terraform state commands to inspect and manipulate state.
Move from local to remote state with an S3 backend.
Enable S3 native state locking with use_lockfile (the 2026 way).
Safely import existing resources into state.
🆕 What Changed (Important!)
The old TerraWeek taught S3 + DynamoDB for state locking. As of Terraform 1.10 (experimental) and 1.11 (GA), the S3 backend supports native locking via a lock file in the bucket — using S3 conditional writes. DynamoDB-based locking is now deprecated and will be removed in a future release. ➡️ For all new work, use use_lockfile = true and skip DynamoDB entirely.

📝 Tasks
Task 1: Why State Matters
Explain in your notes:

What is the terraform.tfstate file and what does it store?
Why should you never edit it by hand or commit it to Git?
What is state drift, and how does terraform plan / terraform refresh relate to it?
Why is state sensitive (it can contain secrets in plaintext)?


What is terraform.tfstate?

Terraform state is a JSON file that stores the mapping between Terraform configuration and the real infrastructure. It tracks resource IDs, attributes, and metadata so Terraform knows what it manages.

Why shouldn't it be edited or committed?

Editing it manually can corrupt the infrastructure state and cause incorrect Terraform operations. It should not be committed to Git because it may contain sensitive information such as resource IDs, IPs, and secrets.

What is State Drift?

State drift occurs when infrastructure is changed outside Terraform. Running terraform plan detects the drift, while terraform refresh (or the refresh phase of plan/apply) updates the state with the current infrastructure information.

Why is State Sensitive?

Terraform state can contain plaintext secrets, passwords, access keys, private IPs, and resource metadata. Therefore it should be securely stored and encrypted.

Task 2: Explore Local State & terraform state
Start from any working config (reuse Day 3's, or the ./backend_demo here). After an apply, practice:

terraform state list                       # list all managed resources
terraform state show <resource_address>    # inspect one resource
terraform state mv <src> <dest>            # rename/move within state
terraform state rm <resource_address>      # stop managing (does NOT delete infra)
terraform show                             # human-readable state
Document what each command does and when you'd use it.

PS D:\python-train\terraweek\Day-3> terraform state list
data.aws_ami.al2023
data.aws_availability_zones.available
data.aws_region.current
data.aws_region.virginia
aws_instance.web
aws_internet_gateway.igw
aws_route_table.public
aws_route_table_association.public
aws_security_group.count_demo[0]
aws_security_group.count_demo[1]
aws_security_group.foreach_demo["app"]
aws_security_group.foreach_demo["db"]
aws_security_group.foreach_demo["web"]
aws_security_group.web
aws_subnet.public
aws_vpc.main
PS D:\python-train\terraweek\Day-3> terraform state show aws_instance.web
# aws_instance.web:
resource "aws_instance" "web" {
    ami                                  = "ami-0fd6240f599091088"
    arn                                  = "arn:aws:ec2:us-east-1:213425191912:instance/i-05f52ba9a0e7ed361"
    associate_public_ip_address          = true
    availability_zone                    = "us-east-1a"
    disable_api_stop                     = false
    disable_api_termination              = false
    ebs_optimized                        = false
    force_destroy                        = false
    get_password_data                    = false
    hibernation                          = false
    host_id                              = null
    iam_instance_profile                 = null
    id                                   = "i-05f52ba9a0e7ed361"
    instance_initiated_shutdown_behavior = "stop"
    instance_lifecycle                   = null
    instance_state                       = "running"
    instance_type                        = "t2.micro"
    ipv6_address_count                   = 0
    ipv6_addresses                       = []
    key_name                             = null
    monitoring                           = false
    outpost_arn                          = null
    password_data                        = null
    placement_group                      = null
    placement_group_id                   = null
    placement_partition_number           = 0
    primary_network_interface_id         = "eni-0890a88bd589fc4f3"
    private_dns                          = "ip-10-0-1-26.ec2.internal"
    private_ip                           = "10.0.1.26"
    public_dns                           = "ec2-100-54-71-223.compute-1.amazonaws.com"
    public_ip                            = "100.54.71.223"
    region                               = "us-east-1"
    secondary_private_ips                = []
    security_groups                      = []
    source_dest_check                    = true
    spot_instance_request_id             = null
    subnet_id                            = "subnet-031772f527367c510"
    tags                                 = {
        "Name" = "terraweek-web"
    }
    tags_all                             = {
        "Day"       = "03"
        "ManagedBy" = "terraform"
        "Name"      = "terraweek-web"
        "Project"   = "terraweek-2026"
    }
    tenancy                              = "default"
    user_data                            = <<-EOT
        #!/bin/bash
        dnf install -y nginx
        echo "<h1>Hello from TerraWeek 2026 🚀</h1>" > /usr/share/nginx/html/index.html
        systemctl enable --now nginx
    EOT
    user_data_replace_on_change          = false
    vpc_security_group_ids               = [
        "sg-0c7c2373a4f4aa16c",
    ]

    capacity_reservation_specification {
        capacity_reservation_preference = "open"
    }

    cpu_options {
        amd_sev_snp           = null
        core_count            = 1
        nested_virtualization = null
        threads_per_core      = 1
    }

    credit_specification {
        cpu_credits = "standard"
    }

    enclave_options {
        enabled = false
    }

    maintenance_options {
        auto_recovery = "default"
    }

    metadata_options {
        http_endpoint               = "enabled"
        http_protocol_ipv6          = "disabled"
        http_put_response_hop_limit = 2
        http_tokens                 = "required"
        instance_metadata_tags      = "disabled"
    }

    primary_network_interface {
        delete_on_termination = true
        network_interface_id  = "eni-0890a88bd589fc4f3"
    }

    private_dns_name_options {
        enable_resource_name_dns_a_record    = false
        enable_resource_name_dns_aaaa_record = false
        hostname_type                        = "ip-name"
    }

    root_block_device {
        delete_on_termination = true
        device_name           = "/dev/xvda"
        encrypted             = false
        iops                  = 3000
        kms_key_id            = null
        tags                  = {
            "Day"       = "03"
            "ManagedBy" = "terraform"
            "Project"   = "terraweek-2026"
        }
        tags_all              = {
            "Day"       = "03"
            "ManagedBy" = "terraform"
            "Project"   = "terraweek-2026"
        }
        throughput            = 125
        volume_id             = "vol-0032cf751eed0cf51"
        volume_size           = 8
        volume_type           = "gp3"
    }
}
PS D:\python-train\terraweek\Day-3> terraform show
# data.aws_ami.al2023:
data "aws_ami" "al2023" {
    architecture          = "x86_64"
    arn                   = "arn:aws:ec2:us-east-1::image/ami-0fd6240f599091088"
    block_device_mappings = [
        {
            device_name  = "/dev/xvda"
            ebs          = {
                "delete_on_termination"      = "true"
                "encrypted"                  = "false"
                "iops"                       = "3000"
                "snapshot_id"                = "snap-07059b2224a6e7e8c"
                "throughput"                 = "125"
                "volume_initialization_rate" = "0"
                "volume_size"                = "8"
                "volume_type"                = "gp3"
            }
            no_device    = null
            virtual_name = null
        },
    ]
    boot_mode             = "uefi-preferred"
    creation_date         = "2026-07-10T03:19:55.000Z"
    deprecation_time      = "2026-10-08T06:08:00.000Z"
    description           = "Amazon Linux 2023 AMI 2023.12.20260710.0 x86_64 HVM kernel-6.1"
    ena_support           = true
    hypervisor            = "xen"
    id                    = "ami-0fd6240f599091088"
    image_id              = "ami-0fd6240f599091088"
    image_location        = "amazon/al2023-ami-2023.12.20260710.0-kernel-6.1-x86_64"
    image_owner_alias     = "amazon"
    image_type            = "machine"
    imds_support          = "v2.0"
    include_deprecated    = false
    kernel_id             = null
    last_launched_time    = null
    most_recent           = true
    name                  = "al2023-ami-2023.12.20260710.0-kernel-6.1-x86_64"
    owner_id              = "137112412989"
    owners                = [
        "amazon",
    ]
    platform              = null
    platform_details      = "Linux/UNIX"
    product_codes         = []
    public                = true
    ramdisk_id            = null
    region                = "us-east-1"
    root_device_name      = "/dev/xvda"
    root_device_type      = "ebs"
    root_snapshot_id      = "snap-07059b2224a6e7e8c"
    sriov_net_support     = "simple"
    state                 = "available"
    state_reason          = {
        "code"    = "UNSET"
        "message" = "UNSET"
    }
    tags                  = {}
    tpm_support           = null
    usage_operation       = "RunInstances"
    virtualization_type   = "hvm"

    filter {
        name   = "architecture"
        values = [
            "x86_64",
        ]
    }
    filter {
        name   = "name"
        values = [
            "al2023-ami-2023.*-x86_64",
        ]
    }
}

# data.aws_availability_zones.available:
data "aws_availability_zones" "available" {
    group_names = [
        "us-east-1-zg-1",
    ]
    id          = "us-east-1"
    names       = [
        "us-east-1a",
        "us-east-1b",
        "us-east-1c",
        "us-east-1d",
        "us-east-1e",
        "us-east-1f",
    ]
    region      = "us-east-1"
    state       = "available"
    zone_ids    = [
        "use1-az1",
        "use1-az2",
        "use1-az4",
        "use1-az6",
        "use1-az3",
        "use1-az5",
    ]
}

# data.aws_region.current:
data "aws_region" "current" {
    description = "US East (N. Virginia)"
    endpoint    = "ec2.us-east-1.amazonaws.com"
    id          = "us-east-1"
    name        = "us-east-1"
    region      = "us-east-1"
}

# data.aws_region.virginia:
data "aws_region" "virginia" {
    description = "US East (N. Virginia)"
    endpoint    = "ec2.us-east-1.amazonaws.com"
    id          = "us-east-1"
    name        = "us-east-1"
    region      = "us-east-1"
}

# aws_instance.web:
resource "aws_instance" "web" {
    ami                                  = "ami-0fd6240f599091088"
    arn                                  = "arn:aws:ec2:us-east-1:213425191912:instance/i-05f52ba9a0e7ed361"
    associate_public_ip_address          = true
    availability_zone                    = "us-east-1a"
    disable_api_stop                     = false
    disable_api_termination              = false
    ebs_optimized                        = false
    force_destroy                        = false
    get_password_data                    = false
    hibernation                          = false
    host_id                              = null
    iam_instance_profile                 = null
    id                                   = "i-05f52ba9a0e7ed361"
    instance_initiated_shutdown_behavior = "stop"
    instance_lifecycle                   = null
    instance_state                       = "running"
    instance_type                        = "t2.micro"
    ipv6_address_count                   = 0
    ipv6_addresses                       = []
    key_name                             = null
    monitoring                           = false
    outpost_arn                          = null
    password_data                        = null
    placement_group                      = null
    placement_group_id                   = null
    placement_partition_number           = 0
    primary_network_interface_id         = "eni-0890a88bd589fc4f3"
    private_dns                          = "ip-10-0-1-26.ec2.internal"
    private_ip                           = "10.0.1.26"
    public_dns                           = "ec2-100-54-71-223.compute-1.amazonaws.com"
    public_ip                            = "100.54.71.223"
    region                               = "us-east-1"
    secondary_private_ips                = []
    security_groups                      = []
    source_dest_check                    = true
    spot_instance_request_id             = null
    subnet_id                            = "subnet-031772f527367c510"
    tags                                 = {
        "Name" = "terraweek-web"
    }
    tags_all                             = {
        "Day"       = "03"
        "ManagedBy" = "terraform"
        "Name"      = "terraweek-web"
        "Project"   = "terraweek-2026"
    }
    tenancy                              = "default"
    user_data                            = <<-EOT
        #!/bin/bash
        dnf install -y nginx
        echo "<h1>Hello from TerraWeek 2026 🚀</h1>" > /usr/share/nginx/html/index.html
        systemctl enable --now nginx
    EOT
    user_data_replace_on_change          = false
    vpc_security_group_ids               = [
        "sg-0c7c2373a4f4aa16c",
    ]

    capacity_reservation_specification {
        capacity_reservation_preference = "open"
    }

    cpu_options {
        amd_sev_snp           = null
        core_count            = 1
        nested_virtualization = null
        threads_per_core      = 1
    }

    credit_specification {
        cpu_credits = "standard"
    }

    enclave_options {
        enabled = false
    }

    maintenance_options {
        auto_recovery = "default"
    }

    metadata_options {
        http_endpoint               = "enabled"
        http_protocol_ipv6          = "disabled"
        http_put_response_hop_limit = 2
        http_tokens                 = "required"
        instance_metadata_tags      = "disabled"
    }

    primary_network_interface {
        delete_on_termination = true
        network_interface_id  = "eni-0890a88bd589fc4f3"
    }

    private_dns_name_options {
        enable_resource_name_dns_a_record    = false
        enable_resource_name_dns_aaaa_record = false
        hostname_type                        = "ip-name"
    }

    root_block_device {
        delete_on_termination = true
        device_name           = "/dev/xvda"
        encrypted             = false
        iops                  = 3000
        kms_key_id            = null
        tags                  = {
            "Day"       = "03"
            "ManagedBy" = "terraform"
            "Project"   = "terraweek-2026"
        }
        tags_all              = {
            "Day"       = "03"
            "ManagedBy" = "terraform"
            "Project"   = "terraweek-2026"
        }
        throughput            = 125
        volume_id             = "vol-0032cf751eed0cf51"
        volume_size           = 8
        volume_type           = "gp3"
    }
}

# aws_internet_gateway.igw:
resource "aws_internet_gateway" "igw" {
    arn      = "arn:aws:ec2:us-east-1:213425191912:internet-gateway/igw-05959148e3c926700"
    id       = "igw-05959148e3c926700"
    owner_id = "213425191912"
    region   = "us-east-1"
    tags     = {
        "Name" = "terraweek-igw"
    }
    tags_all = {
        "Day"       = "03"
        "ManagedBy" = "terraform"
        "Name"      = "terraweek-igw"
        "Project"   = "terraweek-2026"
    }
    vpc_id   = "vpc-0b797a820500dba36"
}

# aws_route_table.public:
resource "aws_route_table" "public" {
    arn              = "arn:aws:ec2:us-east-1:213425191912:route-table/rtb-020f933944283347d"
    id               = "rtb-020f933944283347d"
    owner_id         = "213425191912"
    propagating_vgws = []
    region           = "us-east-1"
    route            = [
        {
            carrier_gateway_id         = null
            cidr_block                 = "0.0.0.0/0"
            core_network_arn           = null
            destination_prefix_list_id = null
            egress_only_gateway_id     = null
            gateway_id                 = "igw-05959148e3c926700"
            ipv6_cidr_block            = null
            local_gateway_id           = null
            nat_gateway_id             = null
            network_interface_id       = null
            odb_network_arn            = null
            transit_gateway_id         = null
            vpc_endpoint_id            = null
            vpc_peering_connection_id  = null
        },
    ]
    tags             = {
        "Name" = "terraweek-public-rt"
    }
    tags_all         = {
        "Day"       = "03"
        "ManagedBy" = "terraform"
        "Name"      = "terraweek-public-rt"
        "Project"   = "terraweek-2026"
    }
    vpc_id           = "vpc-0b797a820500dba36"
}

# aws_route_table_association.public:
resource "aws_route_table_association" "public" {
    gateway_id     = null
    id             = "rtbassoc-08eee21e05aef639a"
    region         = "us-east-1"
    route_table_id = "rtb-020f933944283347d"
    subnet_id      = "subnet-031772f527367c510"
}

# aws_security_group.count_demo[0]:
resource "aws_security_group" "count_demo" {
    arn                    = "arn:aws:ec2:us-east-1:213425191912:security-group/sg-0d756ecf930a2c731"
    description            = "Managed by Terraform"
    egress                 = []
    id                     = "sg-0d756ecf930a2c731"
    ingress                = []
    name                   = "count-demo-0"
    name_prefix            = null
    owner_id               = "213425191912"
    region                 = "us-east-1"
    revoke_rules_on_delete = false
    tags                   = {
        "Name" = "count-demo-0"
    }
    tags_all               = {
        "Day"       = "03"
        "ManagedBy" = "terraform"
        "Name"      = "count-demo-0"
        "Project"   = "terraweek-2026"
    }
    vpc_id                 = "vpc-0b797a820500dba36"
}

# aws_security_group.count_demo[1]:
resource "aws_security_group" "count_demo" {
    arn                    = "arn:aws:ec2:us-east-1:213425191912:security-group/sg-0cfa7182ddea2df84"
    description            = "Managed by Terraform"
    egress                 = []
    id                     = "sg-0cfa7182ddea2df84"
    ingress                = []
    name                   = "count-demo-1"
    name_prefix            = null
    owner_id               = "213425191912"
    region                 = "us-east-1"
    revoke_rules_on_delete = false
    tags                   = {
        "Name" = "count-demo-1"
    }
    tags_all               = {
        "Day"       = "03"
        "ManagedBy" = "terraform"
        "Name"      = "count-demo-1"
        "Project"   = "terraweek-2026"
    }
    vpc_id                 = "vpc-0b797a820500dba36"
}

# aws_security_group.foreach_demo["app"]:
resource "aws_security_group" "foreach_demo" {
    arn                    = "arn:aws:ec2:us-east-1:213425191912:security-group/sg-00794a32b2a51427d"
    description            = "Managed by Terraform"
    egress                 = []
    id                     = "sg-00794a32b2a51427d"
    ingress                = []
    name                   = "app"
    name_prefix            = null
    owner_id               = "213425191912"
    region                 = "us-east-1"
    revoke_rules_on_delete = false
    tags                   = {
        "Name" = "app"
    }
    tags_all               = {
        "Day"       = "03"
        "ManagedBy" = "terraform"
        "Name"      = "app"
        "Project"   = "terraweek-2026"
    }
    vpc_id                 = "vpc-0b797a820500dba36"
}

# aws_security_group.foreach_demo["db"]:
resource "aws_security_group" "foreach_demo" {
    arn                    = "arn:aws:ec2:us-east-1:213425191912:security-group/sg-0cbbd10d00fec2498"
    description            = "Managed by Terraform"
    egress                 = []
    id                     = "sg-0cbbd10d00fec2498"
    ingress                = []
    name                   = "db"
    name_prefix            = null
    owner_id               = "213425191912"
    region                 = "us-east-1"
    revoke_rules_on_delete = false
    tags                   = {
        "Name" = "db"
    }
    tags_all               = {
        "Day"       = "03"
        "ManagedBy" = "terraform"
        "Name"      = "db"
        "Project"   = "terraweek-2026"
    }
    vpc_id                 = "vpc-0b797a820500dba36"
}

# aws_security_group.foreach_demo["web"]:
resource "aws_security_group" "foreach_demo" {
    arn                    = "arn:aws:ec2:us-east-1:213425191912:security-group/sg-0904ba574e7522b0c"
    description            = "Managed by Terraform"
    egress                 = []
    id                     = "sg-0904ba574e7522b0c"
    ingress                = []
    name                   = "web"
    name_prefix            = null
    owner_id               = "213425191912"
    region                 = "us-east-1"
    revoke_rules_on_delete = false
    tags                   = {
        "Name" = "web"
    }
    tags_all               = {
        "Day"       = "03"
        "ManagedBy" = "terraform"
        "Name"      = "web"
        "Project"   = "terraweek-2026"
    }
    vpc_id                 = "vpc-0b797a820500dba36"
}

# aws_security_group.web:
resource "aws_security_group" "web" {
    arn                    = "arn:aws:ec2:us-east-1:213425191912:security-group/sg-0c7c2373a4f4aa16c"
    description            = "Allow HTTP inbound and all outbound"
    egress                 = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "All outbound"
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    id                     = "sg-0c7c2373a4f4aa16c"
    ingress                = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "HTTP from anywhere"
            from_port        = 80
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 80
        },
    ]
    name                   = "terraweek-web-sg"
    name_prefix            = null
    owner_id               = "213425191912"
    region                 = "us-east-1"
    revoke_rules_on_delete = false
    tags                   = {
        "Name" = "terraweek-web-sg"
    }
    tags_all               = {
        "Day"       = "03"
        "ManagedBy" = "terraform"
        "Name"      = "terraweek-web-sg"
        "Project"   = "terraweek-2026"
    }
    vpc_id                 = "vpc-0b797a820500dba36"
}

# aws_subnet.public:
resource "aws_subnet" "public" {
    arn                                            = "arn:aws:ec2:us-east-1:213425191912:subnet/subnet-031772f527367c510"
    assign_ipv6_address_on_creation                = false
    availability_zone                              = "us-east-1a"
    availability_zone_id                           = "use1-az1"
    cidr_block                                     = "10.0.1.0/24"
    customer_owned_ipv4_pool                       = null
    enable_dns64                                   = false
    enable_lni_at_device_index                     = 0
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    id                                             = "subnet-031772f527367c510"
    ipv6_cidr_block                                = null
    ipv6_cidr_block_association_id                 = null
    ipv6_native                                    = false
    map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = true
    outpost_arn                                    = null
    owner_id                                       = "213425191912"
    private_dns_hostname_type_on_launch            = "ip-name"
    region                                         = "us-east-1"
    tags                                           = {
        "Name" = "terraweek-public-subnet"
    }
    tags_all                                       = {
        "Day"       = "03"
        "ManagedBy" = "terraform"
        "Name"      = "terraweek-public-subnet"
        "Project"   = "terraweek-2026"
    }
    vpc_id                                         = "vpc-0b797a820500dba36"
}

# aws_vpc.main:
resource "aws_vpc" "main" {
    arn                                  = "arn:aws:ec2:us-east-1:213425191912:vpc/vpc-0b797a820500dba36"
    assign_generated_ipv6_cidr_block     = false
    cidr_block                           = "10.0.0.0/16"
    default_network_acl_id               = "acl-06dec4c84267295d7"
    default_route_table_id               = "rtb-00f02e5e565f394ce"
    default_security_group_id            = "sg-0dda188b154da460c"
    dhcp_options_id                      = "dopt-0375cf0abac7ed668"
    enable_dns_hostnames                 = true
    enable_dns_support                   = true
    enable_network_address_usage_metrics = false
    id                                   = "vpc-0b797a820500dba36"
    instance_tenancy                     = "default"
    ipv6_association_id                  = null
    ipv6_cidr_block                      = null
    ipv6_cidr_block_network_border_group = null
    ipv6_ipam_pool_id                    = null
    ipv6_netmask_length                  = 0
    main_route_table_id                  = "rtb-00f02e5e565f394ce"
    owner_id                             = "213425191912"
    region                               = "us-east-1"
    tags                                 = {
        "Name" = "terraweek-vpc"
    }
    tags_all                             = {
        "Day"       = "03"
        "ManagedBy" = "terraform"
        "Name"      = "terraweek-vpc"
        "Project"   = "terraweek-2026"
    }
}


Outputs:

ami_id = "ami-0fd6240f599091088"
default_region = "us-east-1"
instance_id = "i-05f52ba9a0e7ed361"
public_ip = "100.54.71.223"
second_region = "us-east-1"
web_url = "http://100.54.71.223"
PS D:\python-train\terraweek\Day-3> 

Task 2: Explore Local State & terraform state
Start from any working config (reuse Day 3's, or the ./backend_demo here). After an apply, practice:

terraform state list                       # list all managed resources
terraform state show <resource_address>    # inspect one resource
terraform state mv <src> <dest>            # rename/move within state
terraform state rm <resource_address>      # stop managing (does NOT delete infra)
terraform show                             # human-readable state
Document what each command does and when you'd use it.

Task 3: Bootstrap the Backend Infrastructure
The S3 bucket that holds your state must exist before you configure the backend. Use ./backend_infra to create it (local state for this bootstrap step only):

cd backend_infra
terraform init
terraform apply    # creates the versioned, encrypted S3 state bucket

PS D:\python-train\terraweek\Day-4\backend_infra> terraform init     
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
PS D:\python-train\terraweek\Day-4\backend_infra> terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.state will be created
  + resource "aws_s3_bucket" "state" {
      + acceleration_status         = (known after apply)
      + acl                         = (known after apply)
      + arn                         = (known after apply)
      + bucket                      = "terraweek-2026-state-bucket-changeme"
      + bucket_domain_name          = (known after apply)
      + bucket_namespace            = (known after apply)
      + bucket_prefix               = (known after apply)
      + bucket_region               = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + object_lock_enabled         = (known after apply)
      + policy                      = (known after apply)
      + region                      = "us-east-1"
      + request_payer               = (known after apply)
      + tags                        = {
          + "Name" = "terraweek-2026-state-bucket-changeme"
        }
      + tags_all                    = {
          + "ManagedBy" = "terraform"
          + "Name"      = "terraweek-2026-state-bucket-changeme"
          + "Project"   = "terraweek-2026"
          + "Purpose"   = "tf-state-backend"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + cors_rule (known after apply)

      + grant (known after apply)

      + lifecycle_rule (known after apply)

      + logging (known after apply)

      + object_lock_configuration (known after apply)

      + replication_configuration (known after apply)

      + server_side_encryption_configuration (known after apply)

      + versioning (known after apply)

      + website (known after apply)
    }

  # aws_s3_bucket_public_access_block.state will be created
  + resource "aws_s3_bucket_public_access_block" "state" {
      + block_public_acls       = true
      + block_public_policy     = true
      + bucket                  = (known after apply)
      + id                      = (known after apply)
      + ignore_public_acls      = true
      + region                  = "us-east-1"
      + restrict_public_buckets = true
    }

  # aws_s3_bucket_server_side_encryption_configuration.state will be created
  + resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
      + bucket = (known after apply)
      + id     = (known after apply)
      + region = "us-east-1"

      + rule {
          + blocked_encryption_types = (known after apply)
          + bucket_key_enabled       = (known after apply)

          + apply_server_side_encryption_by_default {
              + kms_master_key_id = (known after apply)
              + sse_algorithm     = "AES256"
            }
        }
    }

  # aws_s3_bucket_versioning.state will be created
  + resource "aws_s3_bucket_versioning" "state" {
      + bucket = (known after apply)
      + id     = (known after apply)
      + region = "us-east-1"

      + versioning_configuration {
          + mfa_delete = (known after apply)
          + status     = "Enabled"
        }
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + state_bucket_arn  = (known after apply)
  + state_bucket_name = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_s3_bucket.state: Creating...
aws_s3_bucket.state: Creation complete after 7s [id=terraweek-2026-state-bucket-changeme]
aws_s3_bucket_public_access_block.state: Creating...
aws_s3_bucket_versioning.state: Creating...
aws_s3_bucket_server_side_encryption_configuration.state: Creating...
aws_s3_bucket_public_access_block.state: Creation complete after 1s [id=terraweek-2026-state-bucket-changeme]
aws_s3_bucket_server_side_encryption_configuration.state: Creation complete after 2s [id=terraweek-2026-state-bucket-changeme]
aws_s3_bucket_versioning.state: Creation complete after 3s [id=terraweek-2026-state-bucket-changeme]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

state_bucket_arn = "arn:aws:s3:::terraweek-2026-state-bucket-changeme"
state_bucket_name = "terraweek-2026-state-bucket-changeme"
PS D:\python-train\terraweek\Day-4\backend_infra> 


Task 4: Configure the Remote Backend with Native Locking
Now point a real config at that bucket. See ./backend_demo:

terraform {
  backend "s3" {
    bucket       = "your-unique-terraweek-state-bucket"
    key          = "day04/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true   # ✅ native S3 state locking — no DynamoDB!
  }
}
cd backend_demo
terraform init     # Terraform will offer to migrate local state → S3
terraform apply
Verify in the S3 console that your terraform.tfstate is uploaded, and watch a .tflock file appear/disappear during an apply.


PS D:\python-train\terraweek\Day-4\backend_demo> terraform init    
Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 6.0"...
- Finding hashicorp/random versions matching "~> 3.7"...
- Installing hashicorp/aws v6.55.0...
- Installed hashicorp/aws v6.55.0 (signed by HashiCorp)
- Installing hashicorp/random v3.9.0...
- Installed hashicorp/random v3.9.0 (signed by HashiCorp)

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
PS D:\python-train\terraweek\Day-4\backend_demo> 


PS D:\python-train\terraweek\Day-4\backend_demo> terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # random_pet.demo will be created
  + resource "random_pet" "demo" {
      + id        = (known after apply)
      + length    = 3
      + separator = "-"
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + demo_id = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_pet.demo: Creating...
random_pet.demo: Creation complete after 0s [id=smoothly-talented-buck]
Releasing state lock. This may take a few moments...

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

demo_id = "smoothly-talented-buck"
PS D:\python-train\terraweek\Day-4\backend_demo> 

Task 5: Import an Existing Resource
Create something manually in the console (e.g. an S3 bucket), then bring it under Terraform management using an import block (Terraform 1.5+):

import {
  to = aws_s3_bucket.imported
  id = "my-manually-created-bucket"
}
Run terraform plan -generate-config-out=generated.tf and review the generated config.

📚 Reference the companion repo for the full set of state/refactor blocks, each in a commented file: examples/import.tf · examples/moved.tf · examples/removed.tf · examples/check.tf

PS D:\python-train\terraweek\Day-4\backend_demo> terraform version
Terraform v1.15.8
on windows_amd64
+ provider registry.terraform.io/hashicorp/aws v6.55.0
+ provider registry.terraform.io/hashicorp/random v3.9.0
PS D:\python-train\terraweek\Day-4\backend_demo> terraform plan -generate-config-out generated.tf
random_pet.demo: Refreshing state... [id=smoothly-talented-buck]
aws_s3_bucket.imported: Preparing import... [id=maroof-import-demo-2026-001]
aws_s3_bucket.imported: Refreshing state... [id=maroof-import-demo-2026-001]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # aws_s3_bucket.imported will be updated in-place
  # (imported from "maroof-import-demo-2026-001")
  ~ resource "aws_s3_bucket" "imported" {
        acceleration_status         = null
        arn                         = "arn:aws:s3:::maroof-import-demo-2026-001"
        bucket                      = "maroof-import-demo-2026-001"
        bucket_domain_name          = "maroof-import-demo-2026-001.s3.amazonaws.com"
        bucket_namespace            = "global"
        bucket_prefix               = null
        bucket_region               = "us-east-1"
        bucket_regional_domain_name = "maroof-import-demo-2026-001.s3.us-east-1.amazonaws.com"
        force_destroy               = false
        hosted_zone_id              = "Z3AQBSTGFYJSTF"
        id                          = "maroof-import-demo-2026-001"
        object_lock_enabled         = false
        policy                      = null
        region                      = "us-east-1"
        request_payer               = "BucketOwner"
        tags                        = {}
      ~ tags_all                    = {
          + "Day"       = "04"
          + "ManagedBy" = "terraform"
          + "Project"   = "terraweek-2026"
        }

        grant {
            id          = "4570fd26d181a803280e33610062c46fa3ddd94c66927d5693143943eac43fed"
            permissions = [
                "FULL_CONTROL",
            ]
            type        = "CanonicalUser"
            uri         = null
        }

        server_side_encryption_configuration {
            rule {
                bucket_key_enabled = true

                apply_server_side_encryption_by_default {
                    kms_master_key_id = null
                    sse_algorithm     = "AES256"
                }
            }
        }

        versioning {
            enabled    = false
            mfa_delete = false
        }
    }

Plan: 1 to import, 0 to add, 1 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you
run "terraform apply" now.
Releasing state lock. This may take a few moments...
PS D:\python-train\terraweek\Day-4\backend_demo> 

PS D:\python-train\terraweek\Day-4\backend_demo> terraform state list
aws_s3_bucket.imported
random_pet.demo
PS D:\python-train\terraweek\Day-4\backend_demo> terraform state mv aws_s3_bucket.imported aws_s3_bucket.backup_bucket
Acquiring state lock. This may take a few moments...
Move "aws_s3_bucket.imported" to "aws_s3_bucket.backup_bucket"
Successfully moved 1 object(s).
Releasing state lock. This may take a few moments...
PS D:\python-train\terraweek\Day-4\backend_demo> 

PS D:\python-train\terraweek\Day-4\backend_demo> terraform state rm aws_s3_bucket.backup_bucket
Removed aws_s3_bucket.backup_bucket
Successfully removed 1 resource instance(s).
Releasing state lock. This may take a few moments...
PS D:\python-train\terraweek\Day-4\backend_demo> terraform state list                                                 
random_pet.demo
PS D:\python-train\terraweek\Day-4\backend_demo> 

