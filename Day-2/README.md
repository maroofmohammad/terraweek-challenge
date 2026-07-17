🧩 TerraWeek Day 2 — HCL Deep Dive: Variables, Types & Expressions

📝 Tasks
Task 1: Master HCL Syntax

Explain (with examples) in your notes:

The anatomy of a block: block_type "label_one" "label_two" { argument = value }.
The difference between an argument and a block.
Expressions: string interpolation "${...}", references (resource.name.attr), and operators.

What is a Block?

A block is the main building block of Terraform configuration.

Example:

resource "aws_instance" "web" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}


Argument vs Block

Argument - An argument assigns a value.

Example:

instance_type = "t2.micro"

Block - A block groups related configuration.

Example:

resource "aws_instance" "web" {

}

Expressions

Examples:

Interpolation - "${var.environment}-server"

Reference - aws_instance.web.id

Operator - var.port + 1


Task 2: Variables, Types & Validation
Create a variables.tf and define variables covering each major type:

Primitives: string, number, bool
Collections: list(string), map(string), set(string)
Structural: object({...}), tuple([...])
Add at least one variable with:

a default,
a validation block (e.g. only allow certain values),
the sensitive = true flag.





Task 3: Locals, Outputs & Functions
Use a locals block to compute a value (e.g. a common name_prefix or merged tags).
Add outputs that expose useful values.
Use at least 3 built-in functions — e.g. upper(), merge(), join(), lookup(), length(), format(). Explore them live with terraform console:

PS D:\python-train\terraweek\Day-2> terraform console
> upper("terraweek")
"TERRAWEEK"
> merge({a=1},{b=2})
{
  "a" = 1
  "b" = 2
}
> join("-",["aws","terraform","devops"])
"aws-terraform-devops"
> 

Task 4: Build Something Real (Docker provider — no cloud cost)
Use the starter code in ./example. It uses the kreuzwerker/docker provider to pull an Nginx image and run a container — fully driven by variables.

PS D:\python-train\terraweek\Day-2> 
PS D:\python-train\terraweek\Day-2> terraform plan  -var 'container_name=tws-web' -var 'external_port=8080'

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # docker_container.web will be created
  + resource "docker_container" "web" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (known after apply)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + memory_reservation                          = 0
      + must_run                                    = true
      + name                                        = "tws-dev-tws-web"
      + network_data                                = (known after apply)
      + network_mode                                = "bridge"
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + healthcheck (known after apply)

      + labels {
          + label = "environment"
          + value = "dev"
        }
      + labels {
          + label = "managed_by"
          + value = "terraform"
        }
      + labels {
          + label = "project"
          + value = "terraweek"
        }
      + labels {
          + label = "team"
          + value = "trainwithshubham"
        }

      + ports {
          + external = 8080
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }
    }

  # docker_image.nginx will be created
  + resource "docker_image" "nginx" {
      + id           = (known after apply)
      + image_id     = (known after apply)
      + keep_locally = false
      + name         = "nginx:1.27-alpine"
      + repo_digest  = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these
actions if you run "terraform apply" now.
PS D:\python-train\terraweek\Day-2> 

PS D:\python-train\terraweek\Day-2> terraform apply -var 'container_name=tws-web' -var 'external_port=8080'

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # docker_container.web will be created
  + resource "docker_container" "web" {
      + attach                                      = false
      + bridge                                      = (known after apply)
      + command                                     = (known after apply)
      + container_logs                              = (known after apply)
      + container_read_refresh_timeout_milliseconds = 15000
      + entrypoint                                  = (known after apply)
      + env                                         = (known after apply)
      + exit_code                                   = (known after apply)
      + hostname                                    = (known after apply)
      + id                                          = (known after apply)
      + image                                       = (known after apply)
      + init                                        = (known after apply)
      + ipc_mode                                    = (known after apply)
      + log_driver                                  = (known after apply)
      + logs                                        = false
      + memory_reservation                          = 0
      + must_run                                    = true
      + name                                        = "tws-dev-tws-web"
      + network_data                                = (known after apply)
      + network_mode                                = "bridge"
      + read_only                                   = false
      + remove_volumes                              = true
      + restart                                     = "no"
      + rm                                          = false
      + runtime                                     = (known after apply)
      + security_opts                               = (known after apply)
      + shm_size                                    = (known after apply)
      + start                                       = true
      + stdin_open                                  = false
      + stop_signal                                 = (known after apply)
      + stop_timeout                                = (known after apply)
      + tty                                         = false
      + wait                                        = false
      + wait_timeout                                = 60

      + healthcheck (known after apply)

      + labels {
          + label = "environment"
          + value = "dev"
        }
      + labels {
          + label = "managed_by"
          + value = "terraform"
        }
      + labels {
          + label = "project"
          + value = "terraweek"
        }
      + labels {
          + label = "team"
          + value = "trainwithshubham"
        }

      + ports {
          + external = 8080
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }
    }

  # docker_image.nginx will be created
  + resource "docker_image" "nginx" {
      + id           = (known after apply)
      + image_id     = (known after apply)
      + keep_locally = false
      + name         = "nginx:1.27-alpine"
      + repo_digest  = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

docker_image.nginx: Creating...
docker_image.nginx: Still creating... [00m10s elapsed]
docker_image.nginx: Creation complete after 15s [id=sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10nginx:1.27-alpine]
docker_container.web: Creating...
docker_container.web: Creation complete after 2s [id=fe4b4f8f067fcef0631a4b8f4594ef4611494a6220da1a76b1ef069704b6081e]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
PS D:\python-train\terraweek\Day-2> 


PS D:\python-train\terraweek\Day-2> terraform console
╷
│ Warning: Value for undeclared variable
│ 
│ The root module does not declare a variable named "password" but a value was found in file
│ "terraform.tfvars". If you meant to use this value, add a "variable" block to the configuration.
│ 
│ To silence these warnings, use TF_VAR_... environment variables to provide certain "global" settings to all
│ configurations in your organization. To reduce the verbosity of these warnings, use the -compact-warnings
│ option.
╵

> [for s in ["web","app","db"] : upper(s)]
[
  "WEB",
  "APP",
  "DB",
]
> "dev" == "prod" ? "t3.medium" : "t3.micro"
"t3.micro"
> 