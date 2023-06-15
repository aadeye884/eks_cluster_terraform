# Custom VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

# Two Public and Two Private subnet within the VPC
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr_block
  availability_zone = var.public_subnet_availability_zone

  tags = {
    Name = var.public_subnet_name
    "kubernetes.io/role/elb"          = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr_block2
  availability_zone = var.public_subnet_availability_zone2

  tags = {
    Name = var.public_subnet_name2
    "kubernetes.io/role/elb"          = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = var.private_subnet_availability_zone

  tags = {
    Name = var.private_subnet_name
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_block2
  availability_zone = var.private_subnet_availability_zone2

  tags = {
    Name = var.private_subnet_name2
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"    
  }
}

# Custom Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.gateway_name
  }
}

# EIP for NAT Gateway
resource "aws_eip" "eip" {
  domain = aws_vpc.vpc.id

  tags = {
    Name = var.eip
  }

  depends_on = [ aws_internet_gateway.internet_gateway ]
}

#Custom NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = var.nat_gateway_name
  }
}

# Route table and associate it with the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.public_routetable_cidr_block
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

# Public subnet attached to public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Route table and associate it with the private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.private_routetable_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = var.private_route_table_name
  }
}

# Public subnet attached to public route table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_association2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_route_table.id
}

# Create a security group for the EKS cluster
resource "aws_security_group" "eks_cluster_sg" {
  name        = var.eks_cluster_sg_name
  description = "Security group for the EKS cluster"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.eks_cluster_sg_ingress_cidr]
  }

  tags = {
    Name = var.eks_cluster_sg_name
  }
}

# Create a security group for the worker nodes
resource "aws_security_group" "worker_nodes_sg" {
  name        = var.worker_nodes_sg_name
  description = "Security group for the worker nodes"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.worker_nodes_sg_ingress_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.worker_nodes_sg_name
  }
}

# Create an EKS cluster
resource "aws_eks_cluster" "cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_role.arn
  version  = var.eks_cluster_version

  vpc_config {
    subnet_ids         = [
      aws_subnet.public_subnet.id,
      aws_subnet.public_subnet2.id,
      aws_subnet.private_subnet.id,
      aws_subnet.private_subnet2.id,     
      ]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }
}

# Create an IAM role for the EKS cluster
resource "aws_iam_role" "eks_role" {
  name = var.eks_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "eks_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

# Create a worker node group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.node_role.arn

  subnet_ids = [
    aws_subnet.private_subnet.id,
    aws_subnet.private_subnet2.id,
  ]

  capacity_type = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = var.node_group_desired_size
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
  }

  remote_access {
    ec2_ssh_key               = var.ec2_ssh_key
    source_security_group_ids = [aws_security_group.worker_nodes_sg.id]
  }
}

# Create an IAM role for the worker nodes
resource "aws_iam_role" "node_role" {
  name = var.node_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_role.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_role.name
}

# Route 53 Hosted Zone
resource "aws_route53_zone" "route53_zone" {
  name          = var.route53_zone_name
  force_destroy = true
}

# Route 53 A Record
resource "aws_route53_record" "route53_record" {
  zone_id = aws_route53_zone.route53_zone.zone_id
  name    = var.route53_record_name
  type    = "A"
  ttl     = "300"
  records = [aws_eks_cluster.cluster.endpoint]
}
