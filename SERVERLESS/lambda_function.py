# =================================
#  Lambda Function for API Gateway Serverless Integration
# 

import boto3
import os
import datetime

OWNER_NAME = os.environ['OWNER_NAME']

def lambda_handler(event, context):
    try:
        message = {
            "owner"     : OWNER_NAME,
            "message"   : "This is AWS APIGateway + AWS Lambda",
            "runtime"   : str(datetime.datetime.now())
        }
    
    expert Exception as error:
        print("Error eccuried! Error Message: " + str(error))
    
    return message