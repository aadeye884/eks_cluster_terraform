# # Output the kubeconfig
# data "aws_eks_cluster_auth" "cluster_auth" {
#   name = aws_eks_cluster.cluster.name

#   depends_on = [
#     aws_eks_cluster.cluster
#   ]
# }

# output "kubeconfig" {
#   value = data.aws_eks_cluster_auth.cluster_auth.kubeconfig
# }

# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.vpc.id
}

# Output the Subnet ID
output "subnet_id" {
  value = aws_subnet.public_subnet.id
}

# Output the Security Group IDs
output "eks_cluster_sg_id" {
  value = aws_security_group.eks_cluster_sg.id
}

output "worker_nodes_sg_id" {
  value = aws_security_group.worker_nodes_sg.id
}

# Output the EKS Cluster Endpoint
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}