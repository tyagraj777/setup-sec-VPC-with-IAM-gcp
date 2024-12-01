#!/bin/bash

# Exit on any error
set -e

# Variables
PROJECT_ID="<your_project_id>"  # Replace with your GCP Project ID
REGION="us-central1"
TERRAFORM_DIR="./"  # Adjust to your Terraform directory if different

# Step 1: Authenticate with GCP
#echo "Authenticating with GCP..."
#gcloud auth application-default login

# Step 2: Initialize Terraform
#echo "Initializing Terraform..."
#cd $TERRAFORM_DIR
#terraform init

# Step 3: Validate Terraform configuration
#echo "Validating Terraform configuration..."
#terraform validate

# Step 4: Plan Terraform deployment
#echo "Planning Terraform deployment..."
#terraform plan -var="project_id=$PROJECT_ID" -var="region=$REGION"

# Step 5: Apply Terraform configuration
#echo "Applying Terraform configuration..."
#terraform apply -var="project_id=$PROJECT_ID" -var="region=$REGION" -auto-approve

# Step 6: Capture and display outputs
echo "Capturing Terraform outputs..."
VPC_NAME=$(terraform output -raw vpc_name)
PUBLIC_SUBNET=$(terraform output -raw public_subnet_self_link)
PRIVATE_SUBNET=$(terraform output -raw private_subnet_self_link)
ALLOW_SSH_RULE=$(terraform output -raw firewall_allow_ssh_name)
DENY_ALL_RULE=$(terraform output -raw firewall_deny_all_name)

echo "Terraform Outputs:"
echo "VPC Name: $VPC_NAME"
echo "Public Subnet: $PUBLIC_SUBNET"
echo "Private Subnet: $PRIVATE_SUBNET"
echo "Allow SSH Firewall Rule: $ALLOW_SSH_RULE"
echo "Deny All Firewall Rule: $DENY_ALL_RULE"

# Step 7: Verify resources with gcloud commands
echo "Verifying resources with gcloud..."
gcloud compute networks list --filter="name=$VPC_NAME"
gcloud compute firewall-rules list --filter="network=$VPC_NAME"

# Step 8: Cleanup (Optional)
if [[ $1 == "--cleanup" ]]; then
  echo "Cleaning up resources..."
  terraform destroy -var="project_id=$PROJECT_ID" -var="region=$REGION" -auto-approve
  echo "Cleanup completed."
else
  echo "To clean up resources, rerun this script with the '--cleanup' flag."
fi
