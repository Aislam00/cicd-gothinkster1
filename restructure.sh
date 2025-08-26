#!/bin/bash

echo "=== TERRAFORM CONFIGURATION REVIEW ==="

echo "--- VPC MODULE ---"
cat terraform/modules/vpc/main.tf
echo ""
cat terraform/modules/vpc/variables.tf
echo ""
cat terraform/modules/vpc/outputs.tf

echo ""
echo "--- SECURITY MODULE ---"
cat terraform/modules/security/main.tf
echo ""
cat terraform/modules/security/variables.tf
echo ""
cat terraform/modules/security/outputs.tf

echo ""
echo "--- LOAD BALANCER MODULE ---"
cat terraform/modules/load_balancer/main.tf
echo ""
cat terraform/modules/load_balancer/variables.tf
echo ""
cat terraform/modules/load_balancer/outputs.tf

echo ""
echo "--- EC2 MODULE ---"
cat terraform/modules/ec2/main.tf
echo ""
cat terraform/modules/ec2/variables.tf
echo ""
cat terraform/modules/ec2/outputs.tf

echo ""
echo "--- USER DATA SCRIPT ---"
cat terraform/modules/ec2/templates/app-userdata.sh

echo ""
echo "--- IAM MODULE ---"
cat terraform/modules/iam/main.tf
echo ""
cat terraform/modules/iam/variables.tf
echo ""
cat terraform/modules/iam/outputs.tf

echo ""
echo "--- DEV ENVIRONMENT ---"
cat terraform/environments/dev/main.tf
echo ""
cat terraform/environments/dev/variables.tf
echo ""
cat terraform/environments/dev/outputs.tf
echo ""
cat terraform/environments/dev/terraform.tfvars