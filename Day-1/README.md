Task 1: Understand IaC & Terraform


1. What is Infrastructure as Code, and what problems does it solve compared to clicking around a cloud console?

Infrastructure as Code (IaC) is the process for managing and provisioning infrastructure using code instead of manually creating resources through a cloud console. It helps to automate infrastructure, maintain overall consistency, and enables version control. It eliminates manual configuration and enables automation.

2. What is Terraform, and why is it so popular?

Terraform is an open-source Infrastructure as Code tool which is developed by HashiCorp. It allows users to provision and manage infrastructure using a declarative language called HCL across multiple cloud providers like AWS, Azure, and GCP. 


3. Terraform vs alternatives — write one line each on how Terraform compares to OpenTofu, Pulumi, CloudFormation, and Ansible.


Terraform	We can create multi-cloud Infrastructure as Code using HCL.
OpenTofu	It is an open-source fork of Terraform with similar syntax.
Pulumi	    It provisions Infrastructure as Code using programming languages like Python, Go and C#.
CloudFormation	It is an AWS-native Infrastructure as Code service.
Ansible	It is a Configuration Management tool which is used after infrastructure is created to manage things inside the resources.



Task 2: Install Terraform (latest version)

Install Terraform ≥ 1.15 using the official install guide.
Verify your install and paste the output in your notes:


PS D:\python-train\terraweek> terraform version
Terraform v1.15.8
on windows_amd64
PS D:\python-train\terraweek> terraform -help
Usage: terraform [global options] <subcommand> [args]

The available commands for execution are listed below.
The primary workflow commands are given first, followed by
less common or more advanced commands.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt
  fmt           Reformat your configuration in the standard style
  force-unlock  Release a stuck lock on the current workspace
  get           Install or upgrade remote Terraform modules
  graph         Generate a Graphviz graph of the steps in an operation
  import        Associate existing infrastructure with a Terraform resource
  login         Obtain and save credentials for a remote host
  logout        Remove locally-stored credentials for a remote host
  metadata      Metadata related commands
  modules       Show all declared modules in a working directory
  output        Show output values from your root module
  providers     Show the providers required for this configuration
  query         Search and list remote infrastructure with Terraform
  refresh       Update the state to match remote systems
  show          Show the current state or a saved plan
  stacks        Manage HCP Terraform stack operations
  state         Advanced state management
  taint         Mark a resource instance as not fully functional
  test          Execute integration tests for Terraform modules
  untaint       Remove the 'tainted' state from a resource instance
  version       Show the current Terraform version
  workspace     Workspace management

Global options (use these before the subcommand, if any):
  -chdir=DIR    Switch to a different working directory before executing the
                given subcommand.
  -help         Show this help output or the help for a specified subcommand.
  -version      An alias for the "version" subcommand.





  Task 3: Learn 6 Crucial Terraform Terminologies
Explain each of these in your own words with a one-line example:

Provider — A provider is a plugin that allows Terraform to communicate with a platform such as AWS, Azure, Docker or Kubernetes.
Resource — A resource represents any infrastructure component Terraform creates.
State — State is Terraform's record of all managed infrastructure stored in the terraform.tfstate file.
Plan — a preview of the changes Terraform will make.
HCL — HashiCorp Configuration Language, the syntax you write Terraform in.
Module — a reusable, packaged group of Terraform configuration.


Task 4: Your First Terraform Config (no cloud account needed!)

PS D:\python-train\terraweek\Day-1> terraform init
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/local versions matching "~> 2.5"...
- Finding hashicorp/random versions matching "~> 3.7"...
- Installing hashicorp/local v2.9.0...
- Installed hashicorp/local v2.9.0 (signed by HashiCorp)
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
PS D:\python-train\terraweek\Day-1> 


PS D:\python-train\terraweek\Day-1> terraform fmt
PS D:\python-train\terraweek\Day-1> terraform validate
Success! The configuration is valid.

PS D:\python-train\terraweek\Day-1> terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.greeting will be created
  + resource "local_file" "greeting" {
      + content              = (known after apply)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "./greeting.txt"
      + id                   = (known after apply)
    }

  # random_pet.name will be created
  + resource "random_pet" "name" {
      + id        = (known after apply)
      + length    = 2
      + separator = "-"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + file_path = "./greeting.txt"
  + pet_name  = (known after apply)

──────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these
actions if you run "terraform apply" now.
PS D:\python-train\terraweek\Day-1> 

PS D:\python-train\terraweek\Day-1> terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # local_file.greeting will be created
  + resource "local_file" "greeting" {
      + content              = (known after apply)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "./greeting.txt"
      + id                   = (known after apply)
    }

  # random_pet.name will be created
  + resource "random_pet" "name" {
      + id        = (known after apply)
      + length    = 2
      + separator = "-"
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + file_path = "./greeting.txt"
  + pet_name  = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_pet.name: Creating...
random_pet.name: Creation complete after 0s [id=enough-rhino]
local_file.greeting: Creating...
local_file.greeting: Creation complete after 0s [id=90c80a4bd40da3e904ff78e5596041e7de5bfbd8]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

file_path = "./greeting.txt"
pet_name = "enough-rhino"
PS D:\python-train\terraweek\Day-1> 

PS D:\python-train\terraweek\Day-1> cat greeting.txt
Hello from TerraWeek 2026! ðŸš€
Your infra pet name is: enough-rhino
PS D:\python-train\terraweek\Day-1> 

PS D:\python-train\terraweek\Day-1> terraform destroy
random_pet.name: Refreshing state... [id=enough-rhino]
local_file.greeting: Refreshing state... [id=90c80a4bd40da3e904ff78e5596041e7de5bfbd8]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  - destroy

Terraform will perform the following actions:

  # local_file.greeting will be destroyed
  - resource "local_file" "greeting" {
      - content              = <<-EOT
            Hello from TerraWeek 2026! 🚀
            Your infra pet name is: enough-rhino
        EOT -> null
      - content_base64sha256 = "spIw/X75I4Id8abnCOoNL/JukdTb5uH8Ho2Fi+EA06U=" -> null
      - content_base64sha512 = "6OuxWyk/b/yrvSRZTq4omKypedBbH1BR/MFnyJyNTClGac4rfN3m5uzyb5Ik8rhOSp37mxH2JH/WtQuI8++hgQ==" -> null
      - content_md5          = "57652548827af3b0e97d0605748487be" -> null
      - content_sha1         = "90c80a4bd40da3e904ff78e5596041e7de5bfbd8" -> null
      - content_sha256       = "b29230fd7ef923821df1a6e708ea0d2ff26e91d4dbe6e1fc1e8d858be100d3a5" -> null
      - content_sha512       = "e8ebb15b293f6ffcabbd24594eae2898aca979d05b1f5051fcc167c89c8d4c294669ce2b7cdde6e6ecf26f9224f2b84e4a9dfb9b11f6247fd6b50b88f3efa181" -> null
      - directory_permission = "0777" -> null
      - file_permission      = "0777" -> null
      - filename             = "./greeting.txt" -> null
      - id                   = "90c80a4bd40da3e904ff78e5596041e7de5bfbd8" -> null
    }

  # random_pet.name will be destroyed
  - resource "random_pet" "name" {
      - id        = "enough-rhino" -> null
      - length    = 2 -> null
      - separator = "-" -> null
    }

Plan: 0 to add, 0 to change, 2 to destroy.

Changes to Outputs:
  - file_path = "./greeting.txt" -> null
  - pet_name  = "enough-rhino" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

local_file.greeting: Destroying... [id=90c80a4bd40da3e904ff78e5596041e7de5bfbd8]
local_file.greeting: Destruction complete after 0s
random_pet.name: Destroying... [id=enough-rhino]
random_pet.name: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.
PS D:\python-train\terraweek\Day-1> 

