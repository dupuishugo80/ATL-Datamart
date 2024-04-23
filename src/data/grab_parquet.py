from minio import Minio
import urllib.request
import pandas as pd
import sys
import os
import datetime

def main():
    grab_data()
    grab_data_last_month()
    write_data_minio()

def download_data(url, save_path):
    with urllib.request.urlopen(url) as response:
        with open(save_path, 'wb') as file:
            file.write(response.read())

def grab_data():
    base_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-{month:02d}.parquet"
    for month in range(11, 13):
        url_monthly = base_url.format(month=month)
        filename = url_monthly.split("/")[-1]
        save_path = f"C:/Ecole/Archi Decisionnel/ATL-Datamart/data/raw/{filename}"
        download_data(url_monthly, save_path)

def grab_data_last_month():
    date_actuelle = datetime.date.today()
    month = date_actuelle.month - 2
    if month < 1:
        month += 12
        year = date_actuelle.year - 1
    else:
        year = date_actuelle.year
    url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_{year:04d}-{month:02d}.parquet"
    url_last_month = url.format(year=year,month=month)
    filename = url_last_month.split("/")[-1]
    save_path = f"C:/Ecole/Archi Decisionnel/ATL-Datamart/data/raw/{filename}"
    download_data(url_last_month, save_path)

def write_data_minio():
    """
    This method put all Parquet files into Minio
    Ne pas faire cette méthode pour le moment
    """
    client = Minio(
        "localhost:9002",
        secure=False,
        access_key="minio",
        secret_key="minio123"
    )
    bucket: str = "tp1"
    found = client.bucket_exists(bucket)
    if not found:
        client.make_bucket(bucket)
    else:
        print("Bucket " + bucket + " existe déjà")

    directory = "C:/Ecole/Archi Decisionnel/ATL-Datamart/data/raw"
    for filename in os.listdir(directory):
        if filename.endswith(".parquet"):
            file_path = os.path.join(directory, filename)
            object_name = os.path.basename(file_path)
            try:
                client.fput_object(bucket, object_name, file_path)
                print(f"Upload du fichier {object_name} réussi.")
            except Exception as e:
                print(f"Erreur lors de l'upload du fichier {object_name}: {e}")

if __name__ == '__main__':
    sys.exit(main())
