verify:
	terraform init
	terraform plan -out=tfplan
	terraform validate
deploy:
	terraform apply -auto-approve tfplan
	