# from email import utils
import json
import sys
import requests
import pandas as pd
import sys
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient, __version__
import hcl

#----------------load the pipeline_metadata, pipeline_template_json and utils-----------------------
with open('../../adf/pipeline_template/pipeline_template.json') as f:
    pipeline = json.load(f)

with open('../../adf/pipeline_template/pipeline_utils.json') as f:
    utils = json.load(f)

file_name = sys.argv[4].split('.')[0]

#-----------------------------------download file from url and upload to blob storage----------------------------------------------
#download
r = requests.get(sys.argv[2])
open("../../adf/file_buffer_folder/{}".format(sys.argv[4]), 'wb').write(r.content)

#upload
blob_service_client = BlobServiceClient.from_connection_string(sys.argv[1])
blob_client = blob_service_client.get_blob_client(container="rawdata", blob=sys.argv[4])

with open("../../adf/file_buffer_folder/{}".format(sys.argv[4]), "rb") as data:
    blob_client.upload_blob(data)

#-----------------------------------create pipeline -----------------------------------
#define pipeline name
pipeline['name'] = sys.argv[6]

#define activity name
pipeline['properties']['activities'][0]['name'] = 'copy_{}_to_{}'.format(sys.argv[3],sys.argv[5])

#define source
if sys.argv[3] in ['excel','Excel', 'EXCEL', 'xls','xlsx']:
    src_blob_dataset = 'src_blob_excel' 
elif sys.argv[3] in ['csv','CSV']:
    src_blob_dataset = 'src_blob_csv'
elif sys.argv[3] in ['json','JSON','Json']:
    src_blob_dataset = 'src_blob_json'

pipeline['properties']['activities'][0]['typeProperties']['source'] = utils['source'][src_blob_dataset]

#define sink
if sys.argv[5] in ['csv','CSV']:
    dst_datalake_dataset = 'dst_datalake_csv'
    sink_file_suffix = '.csv'
elif sys.argv[5] in ['json','JSON','Json']:
    dst_datalake_dataset = 'dst_datalake_json'
    sink_file_suffix = '.json'
elif sys.argv[5] in ['parquet','Parquet','PARQUET']:
    dst_datalake_dataset = 'dst_datalake_parquet'
    sink_file_suffix = '.parquet'

pipeline['properties']['activities'][0]['typeProperties']['sink'] = utils['sink'][dst_datalake_dataset]

#define translator when needed
if dst_datalake_dataset == 'dst_datalake_parquet':
    pipeline['properties']['activities'][0]['typeProperties']['translator'] =  utils['translator'][dst_datalake_dataset]

#define input dataset
pipeline['properties']['activities'][0]['inputs'][0]['referenceName'] =  src_blob_dataset
pipeline['properties']['activities'][0]['outputs'][0]['referenceName'] =  dst_datalake_dataset

#save pipeline
with open('../../adf/pipeline/{}.json'.format(sys.argv[6]),'w') as f:
    json.dump(pipeline, f)

#-----------------------------------update metadata------------------------------------
with open('../../adf/pipeline_template/pipeline_metadata_template.json') as f:
    metadata = json.load(f)

metadata['source_path'] = sys.argv[2]
metadata['source_data_format'] = sys.argv[3]
metadata['source_file_name'] = sys.argv[4]
metadata['sink_format'] = sys.argv[5]

with open('../../adf/linkedService/AzureDataLakeStorage.json') as f:
    trigger = json.load(f)
    metadata['sink_path'] = trigger['properties']['typeProperties']['url'] + '/' + file_name + sink_file_suffix

metadata['transform_module'] = pipeline['name']


with open('../../adf/pipeline_metadata/metadata_{}.json'.format(pipeline['name']),'w') as f:
    json.dump(metadata, f)

#upload metadata file to raw blob storage 
blob_client = blob_service_client.get_blob_client(container="rawdata", blob="{}.json".format(sys.argv[6]))

with open("../../adf/pipeline_metadata/metadata_{}.json".format(pipeline['name']), "rb") as data:
    blob_client.upload_blob(data)