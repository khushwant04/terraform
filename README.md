# terraform

Minimal Terraform configuration that creates a single Google Compute Engine VM running NGINX, plus a firewall rule that opens port 80.

## What it creates

| Resource | Name | Details |
|----------|------|---------|
| `google_compute_instance.vm_instance` | `var.vm_name` | Ubuntu 22.04 (`ubuntu-os-cloud/ubuntu-2204-lts`), 30 GB `pd-balanced` disk, `default` VPC, ephemeral public IP, network tag `http-server` |
| `google_compute_firewall.default` | `allow-http` | Allows TCP 80 from `0.0.0.0/0` to instances tagged `http-server` |

A startup script installs NGINX on first boot. The VM's public IP is exported as the `instance_ip` output.

## Project structure

```
.
├── versions.tf        # Terraform and provider version constraints
├── main.tf            # Provider, VM and firewall rule
├── variables.tf       # Input variables
├── outputs.tf         # instance_ip output
└── terraform.tfvars   # Example values (placeholder project ID)
```

## Variables

| Name | Default | Description |
|------|---------|-------------|
| `project_id` | (required) | GCP project ID |
| `region` | `us-central1` | GCP region |
| `zone` | `us-central1-a` | GCP zone |
| `vm_name` | `terraform-vm` | Name of the VM |
| `machine_type` | `e2-micro` | Machine type |
| `boot_image` | `ubuntu-os-cloud/ubuntu-2204-lts` | Boot disk image |

`terraform.tfvars` overrides these with `asia-south1` / `asia-south1-a` and `vm_name = "test-server"`. Replace the placeholder `project_id` before applying.

## Usage

Requirements: Terraform >= 1.5, the `gcloud` CLI, and a GCP project with the Compute Engine API enabled.

```bash
# Authenticate (Application Default Credentials)
gcloud auth application-default login

# Set your project ID in terraform.tfvars, or pass it on the command line
terraform init
terraform plan  -var="project_id=<your-project-id>"
terraform apply -var="project_id=<your-project-id>"

# Check NGINX (give the startup script a minute to finish)
curl "http://$(terraform output -raw instance_ip)"

# Clean up
terraform destroy -var="project_id=<your-project-id>"
```

## Notes

- State is stored locally (`terraform.tfstate`, git-ignored). For shared use, configure a remote backend such as a GCS bucket.
- The firewall rule opens HTTP to the whole internet. Narrow `source_ranges` if the VM is not meant to be public.
- There is no HTTPS; port 443 is not opened.
