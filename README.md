# setup-sec-VPC-with-IAM-gcp

Create a Virtual Private Cloud (VPC) with secure networking features, including custom subnets, firewall rules, and IAM policies to restrict access.

Key Features:

1. rovision a VPC with private and public subnets.
2. Apply firewall rules to block all inbound traffic except for specific ports (e.g., SSH on port 22 for a bastion host).
3. Use Terraform to create IAM roles and bindings for least privilege access.

Steps:

 "main.tf" Terraform scripts to provision:
   
a. A VPC with subnets and associated routing.

b. Firewall rules to allow/deny specific traffic.

c. (optional) A Compute Engine instance for a bastion host in the public subnet.

Note -

For adding IAM policies for fine-grained access control (e.g., restricting access to the VPC).
account you're using to apply the Terraform configuration should have sufficient permissions to modify IAM policies for the specified GCP project.
Specifically, the Set IAM Binding operation requires elevated permissions.

for this do,

check your current permissions, run:

#gcloud projects get-iam-policy <your_project_id> --flatten="bindings[].members" --format="table(bindings.role)"

Grant Required Permissions If your account lacks the necessary permissions:
Have an admin or owner of the project grant the roles/resourcemanager.projectIamAdmin role to your account:

#gcloud projects add-iam-policy-binding <your_project_id> \
  --member="user:<your_email>" \
  --role="roles/resourcemanager.projectIamAdmin"

Validation of putput

use test-gcp-secure-vpc.sh file to calidate uotput --optionally can be used to init, validate, plan, apply terraform config






