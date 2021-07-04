init: input
  @terraform init

get: init
  @terraform get

plan: get
  @terraform plan "environment=", $$(ENV)

deploy: plan
  @terraform apply "environment=", $$(ENV)

input:
  @read -p "Enter Environment to be deployed: "; \
	read ENV; \
	echo "Deploying environment ", $$(ENV)

run: deploy

destroy:
  @terraform destroy
