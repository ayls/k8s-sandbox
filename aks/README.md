# Terraform remote state setup

https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli

# AKS Setup

```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/your_subscription_id"
export ARM_SUBSCRIPTION_ID=xxxxxxxx
export ARM_CLIENT_ID=xxxxxxx
export ARM_CLIENT_SECRET=xxxxxxx
export ARM_TENANT_ID=xxxxxxxx
```

Ensure the principal has Application Administrator AAD role

```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```