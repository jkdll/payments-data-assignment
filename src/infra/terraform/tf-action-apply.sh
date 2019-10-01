terraform apply  -var-file="io-values-secrets.tfvars" -var-file="io-values-project.tfvars"
terraform output -json > infra_values.json
python3 provision-redshift.py