echo "========================================================================================================"
terraform init
echo "========================================================================================================"
terraform plan -var-file=./envs/prod.tfvars
echo "========================================================================================================"
terraform apply -var-file=./envs/prod.tfvars -auto-approve