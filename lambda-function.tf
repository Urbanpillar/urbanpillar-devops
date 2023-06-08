data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "./code/lambda_function_backend.py" 
  output_path = "lambda_function_backend.zip"
}
data "archive_file" "python_service_lambda_package" {  
  type = "zip"  
  source_file = "./code/lambda_function_service.py" 
  output_path = "lambda_function_service.zip"
}

resource "aws_lambda_function" "lambda_function_backend" {
    role = aws_iam_role.lambda_role.arn
    function_name = var.lambda_function_backend_name
    filename = "lambda_function_backend.zip"
    source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
    runtime = "python3.10"
    handler = "ambda_function.lambda_handler"
    timeout = 10
}   
resource "aws_lambda_function" "lambda_function_service" {
    role = aws_iam_role.lambda_role.arn
    function_name = var.lambda_function_service_name
    filename = "lambda_function_service.zip"
    source_code_hash = data.archive_file.python_service_lambda_package.output_base64sha256
    runtime = "python3.10"
    handler = "ambda_function.lambda_handler"
    timeout = 10
}   