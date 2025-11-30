module "vpc" {
  source   = "../modules/vpc"
  name     = "ms-dev"
  vpc_cidr = "10.10.0.0/16"
  az_map = {
    "ap-south-1a" = { private_cidr = "10.10.1.0/24", public_cidr = "10.10.101.0/24" }
    "ap-south-1b" = { private_cidr = "10.10.2.0/24", public_cidr = "10.10.102.0/24" }
  }
}

module "iam" {
  source = "../modules/iam"
  name   = "ms-dev"
}

module "ecr_patient" {
  source = "../modules/ecr"
  name   = "patient-service"
}

module "ecr_appointment" {
  source = "../modules/ecr"
  name   = "appointment-service"
}

module "lambda_patient" {
  source             = "../modules/lambda"
  name               = "patient-service-dev"
  lambda_role_arn    = module.iam.lambda_role_arn
  image_uri          = "${module.ecr_patient.repository_url}:dev"
  private_subnet_ids = module.vpc.private_subnet_ids
  lambda_sg_id       = module.vpc.lambda_sg_id
  memory_size        = 1024
  timeout            = 15
}

module "lambda_appointment" {
  source             = "../modules/lambda"
  name               = "appointment-service-dev"
  lambda_role_arn    = module.iam.lambda_role_arn
  image_uri          = "${module.ecr_appointment.repository_url}:dev"
  private_subnet_ids = module.vpc.private_subnet_ids
  lambda_sg_id       = module.vpc.lambda_sg_id
  memory_size        = 1024
  timeout            = 15
}

module "apigw_patients" {
  source            = "../modules/apigw"
  name              = "patients"
  route_path        = "patients"
  lambda_invoke_arn = module.lambda_patient.function_arn
  lambda_name       = module.lambda_patient.name
}

module "apigw_appointments" {
  source            = "../modules/apigw"
  name              = "appointments"
  route_path        = "appointments"
  lambda_invoke_arn = module.lambda_appointment.function_arn
  lambda_name       = module.lambda_appointment.name
}
