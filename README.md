# mediawiki_shyam_kumar



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