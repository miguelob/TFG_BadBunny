import json
import requests
import pandas as pd


url = 'https://api.twitter.com/1.1/tweets/search/fullarchive/prod.json'
head = {'authorization': 'Bearer AAAAAAAAAAAAAAAAAAAAAA%2BKagEAAAAAvoqQNfRw9Lz9mqdxH9bQ4Mvfido%3DaTbGaVQg8YVDgol5oLRiugYWTUiTJg0050Iw4ztnOlnMZ1ZFCN',
           'content-type': 'application/json'}
dat = {
                "query":"X100 PRE",
                "maxResults": "100"
                }


response = requests.post(url, headers=head, data=json.dumps(dat))
data = json.loads(response.content.decode(response.encoding))
savejson = json.dumps(data)
datos = savejson[1:-1]
writejson = open('X100_PRE.json', 'w')
writejson.write(savejson)
data = json.load(open('X100_PRE.json'))

df = pd.DataFrame(data["results"])

df_nested_list = pd.json_normalize(
    data["results"])
print(df_nested_list)
df_nested_list.to_csv('X100_PRE.csv')