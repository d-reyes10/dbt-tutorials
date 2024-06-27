# Installing gcloud and access bigquery for dbt

## Run the install script
    bash install.sh

#### This should source the virtualenv 
#### If not:
    source venv/bin/activate

## Run the gcloud install script
    bash gcloud_install.sh

## Run gcloud init and follow the instructions
    gcloud init

## Finish oauth steps for bigquery
    gcloud auth application-default login \
    --scopes=https://www.googleapis.com/auth/bigquery,\
    https://www.googleapis.com/auth/drive.readonly,\
    https://www.googleapis.com/auth/iam.test

## Update bq_dbt/profiles.yml to reflect your project id and dataset

## Test that it works
    cd bq_dbt
    dbt run

#### This should create a view and table within your bigquery dataset