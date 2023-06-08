import boto3

def lambda_handler(event, context):
    # Get the repository name and tag from the event details
    print("Event is ",event)
    print("Context is ",context)

    # Update the ECS task definition with the new image
    ecs_client = boto3.client('ecs')
    
    response = ecs_client.update_service(
        cluster='urbanpillar-cluster',
        service='urbanpillar-backend-service',
        forceNewDeployment=True
    )
    
    return "Succeed"
    
    