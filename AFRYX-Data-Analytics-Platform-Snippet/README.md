# the repo structure

```
|___ adf                                               (Azure Data factory)

|    |__ dataset                                       (folder for data factory dataset templates for source and sink)

|    |__ linkedService                                 (folder for data factory linked services templates for blob storage and datalake)

|    |__ trigger                                       (folder for data factory trigger templates for event based triggers)

|    |__ pipeline                                      (folder for pipelines to be created using dataset,linkedSerivce and trigger, based on the given pipeline-configuration in "terraform_projects/Simons_example_infra/terraform.tfvars")

|    |__ create_pipeline.py                            (functions that creates the actual pipeline)

|    |__ functions                                     (folder for utility functions)

|    |__ file_buffer_folder                            (buffer folder for files downloaded from source path URL)

|    |__ pipeline_metadata                             (buffer folder for pipeline metadata to be uploaded to blob storage)



|___ terraform modules

|    |__ module_data_ingestion                         (terraform module that covers blob storage, datalake and data factory resources)

|    |__ module_github                                 (terraform module that covers github resources)

|__ terraform project

|    |__ Simons_example_infra

|    |        |__main.tf

|    |            |__ imports module_data_ingestion

|    |            |__ imports module_github

|    |        |__terraform.tfvars

|    |            |__ environment tag parameter        (used as suffix for created resources to avoid naming convention)

|    |            |__ github_repo parameters           (enter parameters for github account)

|    |            |__ pipeline_configuration           (enter parameters for adf-pipeline configuration)

|___ environment.yaml                                 (environmnet pakcages for the python scripts run by terraform)   

```


# run terraform

1. requirements:
    - terraform                                       (see https://learn.hashicorp.com/tutorials/terraform/install-cli)
    - Azure CLI                                       (see https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
    - Github account                                  (with granted "Authorized OAuth apps" access to "AzureDatafacotry", see https://docs.microsoft.com/en-us/azure/data-factory/source-control)
    - install environment.yaml
    
2. run terraform script from root: "terraform_projects/Simons_example_infra"
    - modify the terraform.tfvars
          - enter environment tag paramter (for example "test001" to avoid global naming convention on resources)
          - enter Github parameters
                  - organization
                  - account name
                  - PAD (see https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
          - enter datafactory pipeline configuration prameters:
                  - source path url (for xls, xlsx, csv or json)
                  - custom file name for the source file
                  - pipeline source (xls, xlsx, csv or json) and sink (csv, json or parquet) format
                  - custom name for the pipeline
    - run terraform script inside Azure CLI
          - az login + az account set __subscription=<your-subscription-id>
          - terraform init
          - terraform apply
          * due to lack of time, some depedencies between resources are not properly established, but this can be solved by running terraform apply several times if encounting errors.  

3. Validate the following infrastrcture has been created
    - resource group ("rg-imons-infra-<env>")
    - blob storage   ("stsimonsinfra<env>")
    - data lake      ("dlsimonsinfra<env>")
    - Azure data factory ("adf-simons-infra-<env>")
    - Github repo under given organization   ("simons-infra-repo-<env>")
    
4. Validate that data facotry pipeline has been created and runs
    - enter data factory studio
    - click on "author > pipeline > <your-pipeline>" and run "Debug"
          



