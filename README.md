# Wordpress on Fargate

This terraform example demonstrates how to run a scalable WordPress site based on the AWS reference architecture described at: https://docs.aws.amazon.com/whitepapers/latest/best-practices-wordpress/reference-architecture.html. This example is based on the work Sunil did at https://github.com/futurice/terraform-examples/tree/master/aws/wordpress_fargate, but with a couple of additional layers added, including using memcached and S3.

In this example, we have tried to use serverless technologies as much as possible. Hence, we chose to run the site on Fargate and are using Aurora Serverless as DB.

Read more about this on the blog [Terraform Recipe for WordPress on Fargate](https://futurice.com/blog/terraform-recipe-wordpress-fargate)

## AWS Services

We used the below AWS services in our example. The main motivation behind the selection of services is that we select as many serverless components as possible.

- Fargate - for computing
- Aurora Serverless - for database
- EFS (Elastic File System) - for persistent data storage
- Cloudfront - CDN
- Memcached - for object caching
- S3 - for media storage

## Terraform setup

### Initialize terraform environment

```sh
terraform init -backend-config="bucket=<BUCKET_NAME>" -backend-config="profile=<AWS_PROFILE>" -backend-config="region=<AWS_REGION>"
```

### Create environment

```sh
AWS_SDK_LOAD_CONFIG=1 \
TF_VAR_site_domain=<PUBLIC_DOMAIN> \
TF_VAR_public_alb_domain=<INTERNAL_DOMAIN_FOR_ALB> \
TF_VAR_db_master_username=<DB_MASTER_USERNAME> \
TF_VAR_db_master_password="<DB_MASTER_PASSWORD>" \
AWS_PROFILE=<AWS_PROFILE> \
AWS_DEFAULT_REGION=<AWS_REGION> \
terraform apply
```

### Tear down

```sh
AWS_SDK_LOAD_CONFIG=1 \
TF_VAR_site_domain=<PUBLIC_DOMAIN> \
TF_VAR_public_alb_domain=<INTERNAL_DOMAIN_FOR_ALB> \
TF_VAR_db_master_username=<DB_MASTER_USERNAME> \
TF_VAR_db_master_password="<DB_MASTER_PASSWORD>" \
AWS_PROFILE=<AWS_PROFILE> \
AWS_DEFAULT_REGION=<AWS_REGION> \
terraform destroy
```

p.s. Instead of environment variables, you can obviously use .tfvar files for assigning values to terraform variables.