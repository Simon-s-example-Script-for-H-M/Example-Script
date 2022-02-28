import json
import sys


with open('../../adf/trigger/universal_trigger.json') as f:
    data = json.load(f)

data["properties"]["typeProperties"]["scope"] = data["properties"]["typeProperties"]["scope"].replace(data["properties"]["typeProperties"]["scope"], sys.argv[1])

with open('../../adf/trigger/universal_trigger.json', 'w') as f:
    json.dump(data, f)
