module "kms" {
  source      = "../../modules/kms"
  common_tags = var.common_tags
}

module "vpc" {
  source      = "../../modules/vpc"
  common_tags = var.common_tags
  admin_cidr  = var.admin_cidr
}

module "ecr" {
  source      = "../../modules/ecr"
  common_tags = var.common_tags
  kms_key_arn = module.kms.kms_key_arn
}

module "secrets" {
  source       = "../../modules/secrets"
  common_tags  = var.common_tags
  kms_key_arn  = module.kms.kms_key_arn
  db_password  = var.db_password
  rds_endpoint = module.rds.rds_endpoint
}

module "rds" {
  source          = "../../modules/rds"
  common_tags     = var.common_tags
  environment     = var.environment
  data_subnet_ids = module.vpc.private_data_subnet_ids
  kms_key_arn     = module.kms.kms_key_arn
  db_password     = var.db_password
  rds_sg_id       = module.vpc.rds_sg_id
}

module "dynamodb" {
  source      = "../../modules/dynamodb"
  common_tags = var.common_tags
  kms_key_arn = module.kms.kms_key_arn
}

module "sqs" {
  source      = "../../modules/sqs"
  common_tags = var.common_tags
  kms_key_arn = module.kms.kms_key_arn
}

module "ses" {
  source         = "../../modules/ses"
  ses_domain     = var.ses_domain
  ses_test_email = var.ses_test_email
}

module "eks" {
  source                 = "../../modules/eks"
  common_tags            = var.common_tags
  public_subnet_ids      = module.vpc.public_subnet_ids
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  eks_nodes_sg_id        = module.vpc.eks_nodes_sg_id
  kms_key_arn            = module.kms.kms_key_arn
  dynamodb_products_arn  = module.dynamodb.table_arn
  sqs_orders_queue_arn   = module.sqs.queue_arn
  rds_secret_arn         = module.secrets.rds_secret_arn
}

data "aws_eks_cluster_auth" "main" {
  name = module.eks.cluster_name
}

module "kubernetes_namespaces" {
  source                 = "../../modules/kubernetes"
  cluster_endpoint       = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  cluster_token          = data.aws_eks_cluster_auth.main.token
}

module "monitoring" {
  source      = "../../modules/monitoring"
  common_tags = var.common_tags
  alert_email = var.alert_email
}
