from __future__ import print_function
from matplotlib.pyplot import axes    # (at top of module)
from spotipy.oauth2 import SpotifyClientCredentials
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from pandas import DataFrame,Series
import json
import spotipy
import time
import sys


sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id="44b6c1da36fc4598a23a028439422e13",
                                                           client_secret="78c32d30fc3d4adebd4e9a32fdfdbfa6"))

sp.trace = False

if len(sys.argv) > 1:
    artist_name = ' '.join(sys.argv[1:])
else:
    artist_name = 'Bad Bunny'

results = sp.search(q=artist_name, limit=50)
tids = []
df=pd.DataFrame()
for i, t in enumerate(results['tracks']['items']):
    datos =[[t['name'],t['album']['name']]]
    temp = pd.DataFrame(datos, columns = ['Track','Album'])
    df = pd.concat([df, temp])
    #print(' ', i, t['name'],t['album']['name'])
    tids.append(t['uri'])
#start = time.time()
features = sp.audio_features(tids)
#delta = time.time() - start
df2=pd.DataFrame()
for feature in features:
    datos =[[feature['danceability'],feature['energy'],feature['key'],feature['loudness'],feature['mode'],feature['speechiness'],feature['acousticness'],feature['instrumentalness'],feature['liveness'],feature['valence'],feature['tempo']]]
    temp = pd.DataFrame(datos, columns = ['Danceability','Energy','Key','Loudness','Mode','Speechiness','Acousticness','Instrumentalness','Liveness','Valence','Tempo'])
    df2 = pd.concat([df2, temp])
    #with open('json_data.json', 'w') as outfile:
    #    json.dump(feature, outfile)
    #temp = pd.read_json('json_data.json')
    #print(temp)
    #print(json.dumps(feature, indent=4))
    #print()
    #analysis = sp._get(feature['analysis_url'])
    #print(json.dumps(analysis, indent=4))
    #print()
#print("features retrieved in %.2f seconds" % (delta,))
final =  pd.concat([df, df2],axis=1)
print(final)
final.to_csv('datos_test.csv',index=False)
verano = final[final['Album'] == 'Un Verano Sin Ti']


 
fig = plt.figure(figsize =(10, 7))
 
# Creating plot
plt.boxplot(verano['Tempo'])
 
# show plot
plt.show()