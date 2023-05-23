# CONTRIBUTING

Firstly, thank you for your interest in contributing to our open-source project, `wordpressOnAWS`! This is a project that demonstrates how to run a scalable WordPress site based on the AWS reference architecture. It uses Terraform and employs several AWS services with a focus on serverless technologies. Your contributions to improve or extend this project are welcome.

Please take a moment to review this document to make the contribution process easy and effective for everyone involved.

## Code of Conduct

By participating in this project, you are expected to uphold our [Code of Conduct](CODE_OF_CONDUCT.md). Please report unacceptable behavior to [Derek](https://github.com/h2ouw8n4).

## Getting Started

Before you start contributing, it would be helpful if you could familiarize yourself with Terraform and the AWS services we used in the project. These include Fargate, Aurora Serverless, EFS (Elastic File System), Cloudfront, Memcached, and S3.

## Setup

Before running the Terraform commands locally, make sure you have set up your AWS CLI on your local machine and created an access key. You can create an access key by following the instructions on the AWS documentation. Once you have created an access key, configure your AWS CLI by running `aws configure` and entering your access key, secret access key, default region, and default output format.

## How to Contribute

### Reporting Bugs

Ensure the bug was not already reported by searching on GitHub under [Issues](https://github.com/h2ouw8n4/wordpressOnAWS/issues). If you're unable to find an open issue addressing the problem, open a new one. Be sure to include a title and a clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

### Suggesting Enhancements

If you have a suggestion that is not a bug, you can use GitHub [Issues](https://github.com/h2ouw8n4/wordpressOnAWS/issues). Include as many details as you can and provide the context for the suggestion. If you're able, you can also submit a Pull Request with the changes.

### Pull Requests

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

Please understand that we might not accept all pull requests if they don't align with the project's roadmap or philosophy.

### Coding Standards

Please ensure you follow the coding standards used throughout the existing code base. Some basic rules include:

1. **Terraform Code Structure**: Your Terraform code should be organized into directories and files in a clear and logical manner. Each directory in your project should contain a `main.tf` file that holds the primary code for that directory. There should also be separate files for variables (`variables.tf`), outputs (`outputs.tf`), and providers (`providers.tf`), among others.

2. **Terraform Variable Declaration**: Variables should be declared in a separate `variables.tf` file. This makes it easier to understand and manage the variables used in your code.

3. **Sensitive Data**: Any sensitive data, such as passwords or API keys, should not be stored directly in your Terraform code. Instead, use secure methods like environment variables or a configuration file.

4. **Terraform and Provider Version**: The version of Terraform being used should be declared in the `terraform` block. The version of the provider (in this case, AWS) should also be pinned to a specific version.

5. **Resource and Variable Names**: Resources should be named meaningfully, and variable names should be self-explanatory and give a clear indication of the variable's purpose.

6. **Output Names**: Output variables should also have names that are clear and relevant to their purpose.

7. **Commenting**: Any complexities or important information in the code should be clearly documented in the code itself.

8. **Module Organization**: If a Terraform module becomes too large or complex, consider breaking it down and organizing it into sub-modules.

9. **Code Formatting and Linting**: Use `terraform fmt` to ensure your code is properly formatted. Consider using a linter to catch any syntax errors or violations of coding standards.

10. **Testing**: Whenever possible, create automated tests for your Terraform code.

## License

By contributing, you agree that your contributions will be licensed under the MIT License that is used for this project.

Thank you for your contribution, and we look forward to building great things together!

