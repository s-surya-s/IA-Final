import json
import boto3
import pandas as pd
import requests
from io import StringIO

def lambda_handler(event, context):
    # TODO implement
    
    bucket_name = "landingzone-group2"

    url = "https://raw.githubusercontent.com/s-surya-s/IA-Final/main/1_Data/weather_data.txt"
    # url = f'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/New%20York%20City%2CUSA/2023-12-01/2023-12-31?unitGroup=metric&include=hours&key={api_key}&contentType=json'

    # Make a GET request
    resp = requests.get(url)
    data = json.loads(resp.text)

    weather_df = pd.DataFrame()

    for day in data['days']:
        for data in day['hours']:
            col_name = list(data.keys())
            data['stations'] = ','.join(data['stations'])
            temp_df = pd.DataFrame(data, columns=col_name, index=[0])
            temp_df['datetime'] = day['datetime']+' '+temp_df['datetime']
            weather_df = pd.concat([weather_df, temp_df], ignore_index=True)

    # Convert DataFrame to CSV string
    csv_buffer = StringIO()
    weather_df.to_csv(csv_buffer, index=False)
    csv_string = csv_buffer.getvalue()

    # Create S3 client
    s3_client = boto3.client('s3')

    # Generate a unique filename (optional)
    filename = f"weather_data.csv" #_{pd.Timestamp.now().strftime('%Y-%m-%d_%H-%M-%S')}.csv"

    # Upload CSV data to S3 bucket
    s3_client.put_object(Body=csv_string, Bucket=bucket_name, Key=filename)

    return {
        'statusCode': 200,
        'body': json.dumps(f"Data uploaded to S3 bucket: {bucket_name}, filename: {filename}")
    }