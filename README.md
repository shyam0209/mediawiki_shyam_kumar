# MediaWiki on a Red Hat Enterprise Linux

This module will create a single EC2 instance which will configure MediaWiki in it. Apache , MediaWiki and MariaDB are configured in the same EC2 and the installation steps is managed via EC2 user data . The customization available with this stacks are mentioned in the below Inputs section.

## Steps to provision MediaWiki stack on AWS

### Prerequisite 
    * terraform. 
	* AWS access and secret keys.
	* RHEL 8 AMI details from the AWS account where we are going to provision MediaWiki stack.
	
1) Clone the repository to your local.
   
   <img width="964" alt="git clone" src="https://github.com/shyam0209/mediawiki_shyam_kumar/blob/main/images/step1.PNG?raw=true">
   
2) Switch to terraform folder.

   <img width="964" alt="navigate to terraform folder" src="https://github.com/shyam0209/mediawiki_shyam_kumar/blob/main/images/step2.PNG?raw=true">
 
3) Excute terraform commands

   <img width="964" alt="terraform init" src="https://github.com/shyam0209/mediawiki_shyam_kumar/blob/main/images/step31.PNG?raw=true">   
   
   <img width="964" alt="terraform plan" src="https://github.com/shyam0209/mediawiki_shyam_kumar/blob/main/images/step32.png?raw=true"> 
   
   <img width="964" alt="terraform apply" src="https://github.com/shyam0209/mediawiki_shyam_kumar/blob/main/images/step33.PNG?raw=true">
   

4) Access the Wikimedia URL and login with the wiki user configured.

   <img width="964" alt="wikimedia login" src="https://github.com/shyam0209/mediawiki_shyam_kumar/blob/main/images/step4.PNG?raw=true">
   
   <img width="964" alt="wikimedia home" src="https://github.com/shyam0209/mediawiki_shyam_kumar/blob/main/images/step41.PNG?raw=true">

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_key | AWS Access Key | `string` | n/a | yes |
| db\_root\_pwd | DB root user password | `string` | n/a | yes |
| ec2\_ami | The AMI to use for the instance . PS : select Red Hat Enterprise Linux 8  AMI | `string` | n/a | yes |
| ec2\_instance\_type | The type of instance | `string` | `"t2.micro"` | no |
| http\_range | Source from which media wiki URL to be access.Dafault accessible from everywhere | `string` | `"0.0.0.0/0"` | no |
| public\_key | The public key material. For more details abpout generation of public key ,refer Readme file | `string` | n/a | yes |
| region | AWS region | `string` | `"us-east-1"` | no |
| secret\_key | AWS Secret Key | `string` | n/a | yes |
| ssh\_range | Source from which SSH access to be enabled for the EC2. Dafault accessible from everywhere | `string` | `"0.0.0.0/0"` | no |
| subnet\_cidr\_block | The CIDR block for the subnet | `string` | `"10.0.0.0/24"` | no |
| vpc\_cidr\_block | The CIDR block of the VPC | `string` | `"10.0.0.0/22"` | no |
| wiki\_db | Wiki db name | `string` | n/a | yes |
| wiki\_db\_pwd | Wiki DB user password | `string` | n/a | yes |
| wiki\_db\_user | Wiki DB user name | `string` | n/a | yes |
| wiki\_name | Wiki name | `string` | n/a | yes |
| wiki\_pwd | Wiki user password . PS : Min length 10 | `string` | n/a | yes |
| wiki\_user | Wiki user name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| Wikimedia\_URL | Wikimedia login instructions |


## TO DO

### Blue Green Deployment

Create target group and register Wikimedia EC2 with appropriate health checks (HTTP).Create ALB and attach target group and add path based routing. For example , /mediawiki path redirect traffic to TG1 . Then create TG2 with changes and add to ALB . Add new path /mediawikinew and configure listener rule to route traffic to TG2. Post testing point /mediawiki to TG2 and TG1 will be idle and wait for next changes.

### Scaling
Current installation won’t support cluster configuration. We need to have multiple application servers which will point to the central DB. Once we know procedure to implement  , we can make use of AWS ALB with ASG to achieve elastic architecture. Please find below a proposed architect using ALB , EC2 and RDS. We can further add more AWS services such as Route 53 to achieve blue green or rolling deployment techniques.

<img width="964" alt="cluster " src="https://github.com/shyam0209/mediawiki_shyam_kumar/blob/main/images/cluster.png?raw=true">
