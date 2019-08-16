# Deploying [hyperlexia.xyz](https://hyperlexia.xyz/)

## Prerequisites

* Set the domain name purchased through AWS.

```bash
DOMAIN_NAME=<domain-name>
```

The domain name should also be updated in `parameters.properties`.

* Set a CloudFormation stack name:

```bash
STACK_NAME=<stack-name>
```

## Validation

```bash
aws cloudformation validate-template \
--template-body file://.aws/template.yaml
```

## Deploy CloudFormation

```bash
aws cloudformation deploy \
--stack-name $STACK_NAME \
--template-file .aws/template.yaml \
--parameter-overrides $(cat .aws/parameters.properties)
```

## DNS Validation

To automate DNS validation, run the following script:

```bash
./.aws/dns-validation.sh $DOMAIN_NAME $STACK_NAME
```

## Deploy Content

```bash
./.aws/deploy.sh
```
