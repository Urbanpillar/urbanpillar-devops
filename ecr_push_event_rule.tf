################################################################################
# Defining event rule for Backend service which will triger on urbanpillar backend service image push
################################################################################
resource "aws_cloudwatch_event_rule" "ecr_push_rule_backend" {
    name    ="urbanpillar_backend_service_ecr_push_rule"
    description = "Urban pillar backend service ecr push rule"

    event_pattern = <<EOF
    {
        "source": ["aws.ecr"],
        "detail-type": ["ECR Image Action"],
        "detail": {
        "action-type": ["PUSH"],
        "result": ["SUCCESS"],
        "repository-name": ["urbanpillar-backend"],
        "image-tag": ["latest", ""]
         }
    }
    EOF
}
################################################################################
# Defining event target service for backend rule
################################################################################
resource "aws_cloudwatch_event_target" "ecr_push_target_backend" {
  rule      = aws_cloudwatch_event_rule.ecr_push_rule_backend.name
  target_id = aws_lambda_function.lambda_function_backend.id
  arn       = aws_lambda_function.lambda_function_backend.arn
}

################################################################################
# Defining event rule for frontend service which will triger on urbanpillar  service image push
################################################################################
resource "aws_cloudwatch_event_rule" "ecr_push_rule_service" {
    name    ="urbanpillar_service_ecr_push_rule"
    description = "Urban pillar frontend service ecr push rule"

    event_pattern = <<EOF
    {
        "source": ["aws.ecr"],
        "detail-type": ["ECR Image Action"],
        "detail": {
        "action-type": ["PUSH"],
        "result": ["SUCCESS"],
        "repository-name": ["urbanpillar"],
        "image-tag": ["latest", ""]
        }
    }
    EOF
}
################################################################################
# Defining event target service for frontend rule
################################################################################
resource "aws_cloudwatch_event_target" "ecr_push_target" {
  rule      = aws_cloudwatch_event_rule.ecr_push_rule_service.name
  target_id = aws_lambda_function.lambda_function_service.id
  arn       = aws_lambda_function.lambda_function_service.arn
}