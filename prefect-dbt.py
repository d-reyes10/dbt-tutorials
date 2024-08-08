from prefect import flow
from prefect_dbt import DbtCoreOperation

@flow
def dbt_flow():
    dbt_job = DbtCoreOperation(
        commands=["dbt build -s cln_early_voters_neighbors"],
        project_dir="bq_dbt",
        profiles_dir="bq_dbt",
    )
    dbt_job.run()


if __name__ == "__main__":
    dbt_flow.serve(
        cron="0 08 * * 1" ## 8AM every Monday
)
