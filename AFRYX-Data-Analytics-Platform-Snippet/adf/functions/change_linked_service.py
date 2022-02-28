import json
import sys

# blob storage
with open('../../adf/linkedService/AzureBlobStorage.json') as f:
    data = json.load(f)

data["properties"]["typeProperties"]["serviceEndpoint"] = data["properties"]["typeProperties"]["serviceEndpoint"].replace(data["properties"]["typeProperties"]["serviceEndpoint"],"https://" + sys.argv[1] + ".blob.core.windows.net/")

with open('../../adf/linkedService/AzureBlobStorage.json', 'w') as f:
   json.dump(data, f)


# data lake
with open('../../adf/linkedService/AzureDataLakeStorage.json') as f:
    data = json.load(f)

data["properties"]["typeProperties"]["url"] = data["properties"]["typeProperties"]["url"].replace(data["properties"]["typeProperties"]["url"],"https://" + sys.argv[2] + ".dfs.core.windows.net/")

with open('../../adf/linkedService/AzureDataLakeStorage.json', 'w') as f:
   json.dump(data, f)
