import json
import boto3
import pandas as pd
from io import StringIO

def lambda_handler(event, context):
    
    # Define your source and destination S3 bucket names
    source_bucket_name = 'landingzone-group2'
    destination_bucket_name = 'stagingzone-group2'
    
    # Initialize S3 client
    s3 = boto3.client('s3')
    
    def s3_to_df(bucket_name, file_name):
        
        # Fetch the file from S3
        response = s3.get_object(Bucket=bucket_name, Key=file_name)
        
        # Read the content of the file
        content = response['Body'].read().decode('utf-8')
        
        # Convert the content to a pandas DataFrame and return
        return pd.read_csv(StringIO(content))
        
    citibike_df = s3_to_df(source_bucket_name, 'citibike_data.csv')
    weather_df = s3_to_df(source_bucket_name, 'weather_data.csv')
    
    # Change Datatype
    citibike_df['started_at'] = pd.to_datetime(citibike_df['started_at'], format='%m/%d/%Y %I:%M:%S %p')
    citibike_df['ended_at']   = pd.to_datetime(citibike_df['ended_at'], format='%m/%d/%Y %I:%M:%S %p')
    
    # Extract the date and hour from both DataFrames
    citibike_df['date'] = citibike_df['started_at'].dt.date
    citibike_df['hour'] = citibike_df['started_at'].dt.hour
    weather_df['date'] = pd.to_datetime(weather_df['datetime']).dt.date
    weather_df['hour'] = pd.to_datetime(weather_df['datetime']).dt.hour
    
    merged_df = citibike_df.merge(weather_df, on=['date', 'hour'], how='inner')
    
    # Convert the transformed DataFrame back to CSV format
    transformed_csv = merged_df.to_csv(index=False)
    
    # Define the destination key where you want to store the transformed data
    destination_key = 'citibike_weather_merged.csv'
    
    # Upload the transformed data to the destination S3 bucket
    s3.put_object(Body=transformed_csv, Bucket=destination_bucket_name, Key=destination_key)
    
    return {
        'statusCode': 200,
        'body': json.dumps(f"Data merged and uploaded to S3 bucket: {destination_bucket_name}, filename: {destination_key}")
    }