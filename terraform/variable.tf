variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "elizabethfolzgroup-vpc"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  default     = "10.0.64.0/19"
}

variable "public_subnet_cidr_block2" {
  description = "CIDR block for the public subnet"
  default     = "10.0.96.0/19"
}

variable "public_subnet_availability_zone" {
  description = "Availability zone for the public subnet"
  default     = "us-east-1a"
}

variable "public_subnet_availability_zone2" {
  description = "Availability zone for the public subnet"
  default     = "us-east-1b"
}

variable "public_subnet_name" {
  description = "Name of the subnet"
  default     = "elizabethfolzgroup-public-subnet"
}

variable "public_subnet_name2" {
  description = "Name of the subnet"
  default     = "elizabethfolzgroup-public-subnet2"
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for the private subnet"
  default     = "10.0.0.0/19"
}

variable "private_subnet_cidr_block2" {
  description = "CIDR block for the private subnet"
  default     = "10.0.32.0/19"
}

variable "private_subnet_availability_zone" {
  description = "Availability zone for the private subnet"
  default     = "us-east-1a"
}

variable "private_subnet_availability_zone2" {
  description = "Availability zone for the private subnet"
  default     = "us-east-1b"
}

variable "private_subnet_name" {
  description = "Name of the subnet"
  default     = "elizabethfolzgroup-private-subnet"
}

variable "private_subnet_name2" {
  description = "Name of the subnet"
  default     = "elizabethfolzgroup-private-subnet2"
}

variable "gateway_name" {
  description = "Name of the internet gateway"
  default     = "elizabethfolzgroup-gateway"
}

variable "eip" {
  description = "Name of the internet gateway"
  default     = "elizabethfolzgroup-eip"
}

variable "nat_gateway_name" {
  description = "Name of the internet gateway"
  default     = "elizabethfolzgroup-nat-gateway"
}

variable "public_route_table_name" {
  description = "Name of the public route table"
  default     = "elizabethfolzgroup-public-route-table"
}

variable "public_routetable_cidr_block" {
  description = "CIDR block for the public route table"
  default     = "0.0.0.0/0"
}

variable "private_route_table_name" {
  description = "Name of the private route table"
  default     = "elizabethfolzgroup-private-route-table"
}

variable "private_routetable_cidr_block" {
  description = "CIDR block for the private route table"
  default     = "0.0.0.0/0"
}

variable "eks_cluster_sg_name" {
  description = "Name of the security group for the EKS cluster"
  default     = "elizabethfolzgroup-eks-cluster-sg"
}

variable "eks_cluster_sg_ingress_cidr" {
  description = "CIDR block allowed for ingress to the EKS cluster security group"
  default     = "0.0.0.0/0"
}

variable "worker_nodes_sg_name" {
  description = "Name of the security group for the worker nodes"
  default     = "elizabethfolzgroup-worker-nodes-sg"
}

variable "worker_nodes_sg_ingress_cidr" {
  description = "CIDR block allowed for ingress to the worker nodes security group"
  default     = "0.0.0.0/0"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  default     = "elizabethfolzgroup-eks-cluster"
}

variable "eks_cluster_version" {
  description = "Version of the EKS cluster"
  default     = "1.21"
}

variable "eks_role_name" {
  description = "Name of the IAM role for the EKS cluster"
  default     = "elizabethfolzgroup-eks-role"
}

variable "node_group_name" {
  description = "Name of the worker node group"
  default     = "elizabethfolzgroup-node-group"
}

variable "node_group_desired_size" {
  description = "Desired size of the worker node group"
  default     = 2
}

variable "node_group_min_size" {
  description = "Minimum size of the worker node group"
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum size of the worker node group"
  default     = 3
}

variable "ec2_ssh_key" {
  description = "Name of the EC2 SSH key pair"
  default     = "elizabethfolzgroup-key-pair"
}

variable "node_role_name" {
  description = "Name of the IAM role for the worker nodes"
  default     = "elizabethfolzgroup-node-role"
}

variable "route53_zone_name" {
  description = "Domain name for the Route 53 zone"
  default     = "elizabethfolzgroupllc.com"
}

variable "route53_record_name" {
  description = "Name of the Route 53 record"
  default     = "eks-cluster.elizabethfolzgroupllc.com"
}
