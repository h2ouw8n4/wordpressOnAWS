# Wordpress on Fargate

This terraform example demonstrates how to run a scalable WordPress site based on the AWS reference architecture described at: https://docs.aws.amazon.com/whitepapers/latest/best-practices-wordpress/reference-architecture.html. This example is based on the great work Sunil did at https://github.com/futurice/terraform-examples/tree/master/aws/wordpress_fargate, but with a couple of additional layers added, including using memcached and S3. Read more about the repository this was based on at the blog [Terraform Recipe for WordPress on Fargate](https://futurice.com/blog/terraform-recipe-wordpress-fargate)

This is my first attempt at using terraform so bear with me as I get familiar with terraform best practices.

In this example, we have tried to use serverless technologies as much as possible. Hence, we chose to run the site on Fargate and are using Aurora Serverless as DB.

## AWS Services

We used the below AWS services in our example. The main motivation behind the selection of services is that we select as many serverless components as possible.

- Fargate - for computing
- Aurora Serverless - for database
- EFS (Elastic File System) - for persistent data storage
- Cloudfront - CDN
- Memcached - for object caching
- S3 - for media storage

## Terraform setup

Note: Before running the Terraform commands locally, make sure you have set up your AWS CLI on your local machine and created an access key. You can create an access key by following the instructions on the [AWS documentation](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys). Once you have created an access key, configure your AWS CLI by running `aws configure` and entering your access key, secret access key, default region, and default output format.

### Configuring Secrets for executing Github Actions

Before running the GitHub Actions workflow to deploy your Terraform project, you will need to set up the following secrets in your repository settings:

- `AWS_ACCESS_KEY_ID`: The access key ID for an AWS IAM user with the appropriate permissions to deploy your infrastructure.
- `AWS_SECRET_ACCESS_KEY`: The secret access key for the same AWS IAM user.
- `AWS_REGION`: The AWS region where you want to deploy your infrastructure.

To set up these secrets, follow these steps:

1. Go to your repository on GitHub.
2. Click on the "Settings" tab.
3. Click on "Secrets" in the left-hand menu.
4. Click on "New repository secret" to create a new secret.
5. Enter the name of the secret (e.g. `AWS_ACCESS_KEY_ID`).
6. Enter the value of the secret (e.g. your AWS access key ID).
7. Repeat steps 5-6 for the other two secrets (`AWS_SECRET_ACCESS_KEY` and `AWS_REGION`).

Once you have set up these secrets, you can run the GitHub Actions workflow to deploy your Terraform project. The workflow will automatically authenticate with AWS using the secrets you have set up, and deploy the infrastructure to the specified region.

### Creating a Terraform state bucket

Before you can use Terraform to manage your infrastructure, you need to create an S3 bucket to store the Terraform state file. Here are the steps to create a new S3 bucket:

1. Log in to the AWS Management Console with an account that has administrative privileges.

2. Navigate to the S3 dashboard.

3. Click on the "Create bucket" button.

4. Enter a name for the bucket. This name should be unique across all AWS accounts.

5. Choose a region for the bucket. This should be the same region you plan to deploy your infrastructure to.

6. Leave the default settings for the remaining options, and click on the "Create bucket" button.

7. Your new S3 bucket is now ready to use as the backend for your Terraform project.

### Updating the `provider.tf` file

After creating the S3 bucket to store the Terraform state file, you need to update the `provider.tf` file to specify the new bucket name. Here are the steps to do that:

1. Open the `provider.tf` file in your Terraform code.

2. Locate the `backend` configuration block.

3. Update the `bucket` parameter in the `backend` configuration block to the name of the S3 bucket you created in the previous step.

4. If the S3 bucket is in a different region than the one specified in the `provider` configuration block, update the `region` parameter in the `backend` configuration block to the new region.

5. Save the changes to the `provider.tf` file.

### Initialization

After creating the S3 bucket and updating the `provider.tf` file, you need to initialize the Terraform environment by running the following command in the project directory:

```sh
terraform init
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

p.s. Instead of environment variables, you can obviously use .tfvar files for assigning values to Terraform variables.
