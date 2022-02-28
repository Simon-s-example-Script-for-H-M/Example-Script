import json
import sys

#csv
with open('../../adf/dataset/dst_datalake_csv.json') as f:
    data = json.load(f)

data["properties"]["typeProperties"]["location"]["fileSystem"] = data["properties"]["typeProperties"]["location"]["fileSystem"].replace(data["properties"]["typeProperties"]["location"]["fileSystem"] , sys.argv[1])

with open('../../adf/dataset/dst_datalake_csv.json', 'w') as f:
    json.dump(data, f)


#json
with open('../../adf/dataset/dst_datalake_json.json') as f:
    data = json.load(f)

data["properties"]["typeProperties"]["location"]["fileSystem"] = data["properties"]["typeProperties"]["location"]["fileSystem"].replace(data["properties"]["typeProperties"]["location"]["fileSystem"] , sys.argv[1])

with open('../../adf/dataset/dst_datalake_json.json', 'w') as f:
    json.dump(data, f)


#json-->csv
with open('../../adf/dataset/dst_datalake_parquet.json') as f:
    data = json.load(f)

data["properties"]["typeProperties"]["location"]["fileSystem"] = data["properties"]["typeProperties"]["location"]["fileSystem"].replace(data["properties"]["typeProperties"]["location"]["fileSystem"] , sys.argv[1])

with open('../../adf/dataset/dst_datalake_parquet.json', 'w') as f:
    json.dump(data, f)
