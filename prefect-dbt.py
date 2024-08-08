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
    flow.from_source(
        source="https://github.com/Generation-Data/dbt-tutorials.git",
        entrypoint="prefect-dbt.py:dbt_flow"
    ).deploy(
        name="measurestudio-syncs",
        work_pool_name="bigquery-load",
        cron="0 08 * * 1" ## 8AM every Monday
)
    # run_dbt_job()
    # dbt_flow()
    # dbt_flow()