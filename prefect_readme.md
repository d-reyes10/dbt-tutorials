# Prefect Readme

## Get started with Prefect and Codespaces

### Create a Prefect API key

Go to [Prefect Cloud](https://app.prefect.cloud/auth/sign-up) and create an account and workspace.

Once logged in, create an API key.

Navigate to the account dropdown in the top right, and select "API keys".

<img src="images/api-key.png" alt="isolated" width="200"/>

Once on the API Keys page, click the plus at the top of the page to open the "Create API Key" form. Enter a name and click "Create".

<img src="images/key-create.png" alt="isolated" width="400"/>

Copy and save your API key for later use.

### Start your Codespaces instance

Fork this repository and start a codespaces instance from it.

### Install Prefect and log in to Prefect Cloud

Connect to Codespaces and install `prefect` and `prefect-dbt`:

`pip install prefect prefect-dbt`

Once installed, log in to Prefect Cloud with your API key:

`prefect cloud login -k <your-api-key>`

Once you see the following message in your terminal, you're good to go!

`Authenticated with Prefect Cloud! Using workspace 'your-account/your-workspace'.`

## Run your first flow

### Write and execute a flow script

Clone this repository or create a file called `simple_flow.py` with the following contents:

```python
from prefect import flow, task


@flow(log_prints=True)
def simple_flow(name: str):
    message = generate_message(name)
    log_message(message)


@task
def generate_message(name: str):
    return f"Welcome to Prefect, {name}!"


@task
def log_message(message: str):
    print(message)


if __name__ == "__main__":
    simple_flow("Kevin")
```

Replace the name "Kevin" on the last line with your own name, and save the file.
Run your flow by executing `python simple_flow.py` in your terminal.

Each time a function with a `@flow` decorator is called, a flow run is created.
Cmd+Click on the link generated in your terminal, or navigate to the "Runs" page in the [Prefect Cloud UI](app.prefect.cloud) and click on the **blue, generated flow run name** to view your flow run.

<img src="images/flow-run.png" alt="isolated" width="600"/>

### Understanding the flow run graph

Each flow run has an accompanying flow run graph.

<img src="images/flow-run-graph.png" alt="isolated" width="500"/>

At the center are **task runs**, a visual representation of `@task` decorated functions displayed at the time they were executed.
Task runs that share data are connected by an arrow. Since the `message` returned by the first task was passed as a parameter to the second task, `generate_message` points to `log_message`.

The colors across the bottom, which are also lightly shaded in the background of the graph, indicate the **state** of the flow run over time. This flow run went from `Pending` to `Running`, then to `Completed`. There are many other states, like `Scheduled`, `Paused`, `Failed`, and `Crashed`, each indicated by their own color.

Finally, the purple dots are **events**, which are small pieces of data emitted during a flow run that can trigger actions in other parts of the Prefect ecosystem.

**Task runs**, **states**, and **events** can all be clicked on for additional details.

### Create a dbt flow

dbt is supported though a Prefect integration package, `prefect-dbt`. You can execute `dbt run` against your existing dbt project by importing `DbtCoreOperation` from `prefect_dbt`.

In `dbt_flow.py`, a dbt job is defined by specifying a command and referencing the directory where the dbt project and profile are located relative to the flow script.

```python
from prefect import flow
from prefect_dbt import DbtCoreOperation

@flow
def dbt_flow():
    dbt_job = DbtCoreOperation(
        commands=["dbt run"],
        project_dir="bq_dbt",
        profiles_dir="bq_dbt",
    )
    dbt_job.run()


if __name__ == "__main__":
    run_dbt_job()
```

Run your dbt flow by executing `python dbt_flow.py` in your terminal. Though this flow only runs your dbt job, it can easily be extended to do additional work, like calling APIs, transforming data, or running other dbt commands!

## Schedule your flow

### Create a deployment

In Prefect, flows can be scheduled by promoting them to **deployments**. Deployments are containers for instructions about how, where, and when your flows should run.

Creating a deployment for a flow is as simple as calling `.serve()` on your flow function.

`dbt_deployment.py` contains the same flow as before, but instead of calling it directly as a Python function, you'll deploy it inside your Codespaces instance to run once every 5 minutes.

```python
# Flow code above remains the same

if __name__ == "__main__":
    run_dbt_job.serve(
        cron="*/5 * * * *",
    )
```

Execute `python dbt_deployment.py` in your terminal to create your deployment. Cmd+Click on the link generated in your terminal to visit the `simple-flow` deployment page.

An auto-scheduled run for this deployment will appear under the "Runs" tab of the deployment page. Prefect deployments can have multiple schedules. You can disable all schedules with the top toggle, or disable schedules with their individual corresponding toggles.

<img src="images/schedules.png" alt="isolated" width="250"/>

Clicking the "Run"->"Quick run" buttons in the top right of the deployment page will create a scheduled run with a start time of _now_. Give it a try!

### The limitations of `.serve()`

Creating a deployment with `.serve()` is only useful in places where your flow code is already present and runnable as a script, like your local computer or Codespaces instance. This is because `.serve()` creates a flow runner to execute your flows right where you run your script. However, these environments don't persist forever — a served deployment won't run on your laptop if it's shut off!

`.serve()` is a convenient way to to get something off the ground and schedulable quickly, but its production readiness is limited. Keep this in mind as you think about building your data pipelines.

Press Ctrl+C in your terminal to shut down your served flow.

## Work Pools

To make your deployment truly resilient, it needs to be deployed to the cloud, where there are compute resources always ready to run your code. In Prefect, those execution environments are represented as **work pools**.

### Create a managed work pool

Go to the "Work Pools" page in the [Prefect Cloud UI](app.prefect.cloud) and click the plus button at the top of the page. Select "Prefect Managed" and name work your pool "managed-pool". Click "Next", then click "Create".

Let's deploy your `simple-flow` from earlier to your Prefect Managed work pool.
First, since this deployment will be running your flow in a remote execution environment where the code isn't currently present, we'll need to tell Prefect where to find your code. `flow.from_source()` allows you to specify a repository where your code is stored, as well as an `entrypoint`, which is the path to your `<flow_file>:<flow_function>` from the root of the repository.
Then all we need to do is swap `serve` with `deploy`, and add the `name="simple-flow-managed"` and `work_pool_name="managed-pool"` parameters.

```python
# Flow code above remains the same

if __name__ == "__main__":
    flow.from_source(
        source="https://github.com/Generation-Data/prefect-examples.git",
        entrypoint="simple_flow.py:simple_flow",
    ).deploy(
        name="simple-flow-managed",
        work_pool_name="managed-pool",
        cron="*/5 * * * *",
        parameters={"name": "Kevin"}
    )
```

Execute `python simple_deployment_managed.py` in your terminal to create your new work pool-based deployment. Cmd+Click on the link generated in your terminal to visit the `simple-flow-managed` deployment page. When this deployment is run, it'll be executed on always-available cloud infrastructure managed by Prefect.

Note that Prefect Managed work pools are free, but offer a limited number of compute hours per month. For unlimited compute, consider a Cloud Run v2 push work pool managed within your organization's GCP project.

Don't forget to shut off the schedule or delete your deployment to preserve your remaining Prefect Managed compute time.



