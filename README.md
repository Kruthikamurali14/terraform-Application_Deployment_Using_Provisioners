<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.server](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/instance) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/internet_gateway) | resource |
| [aws_key_pair.key_pair](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/key_pair) | resource |
| [aws_route_table.main_rt](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/route_table) | resource |
| [aws_route_table_association.public_rt_assoc](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/route_table_association) | resource |
| [aws_security_group.webSG](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/security_group) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/subnet) | resource |
| [aws_vpc.my_vpc](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/resources/vpc) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/5.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | the type of instance | `any` | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The key-pair name | `any` | n/a | yes |
| <a name="input_sg_name"></a> [sg\_name](#input\_sg\_name) | The SG name | `any` | n/a | yes |
| <a name="input_subnet_az"></a> [subnet\_az](#input\_subnet\_az) | the AZ for subnet | `any` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The cidr block for the VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_Website-link"></a> [Website-link](#output\_Website-link) | n/a |
<!-- END_TF_DOCS -->