#Shows the list of all songs sung by the artist or the band
import argparse
import logging
import pandas as pd
from pandas import DataFrame,Series

from spotipy.oauth2 import SpotifyClientCredentials
import spotipy

logger = logging.getLogger('examples.artist_discography')
logging.basicConfig(level='INFO')

def get_args():
    parser = argparse.ArgumentParser(description='Shows albums and tracks for '
                                     'given artist')
    parser.add_argument('-a', '--artist', required=True,
                        help='Name of Artist')
    return parser.parse_args()


def get_artist(name):
    results = sp.search(q='artist:' + name, type='artist')
    items = results['artists']['items']
    if len(items) > 0:
        return items[0]
    else:
        return None


def show_album_tracks(album,df):
    tracks = []
    results = sp.album_tracks(album['id'])
    tracks.extend(results['items'])
    while results['next']:
        results = sp.next(results)
        tracks.extend(results['items'])
    for i, track in enumerate(tracks):
        logger.info('%s. %s', i+1, track['name'])
        results = get_audio_features(track['id'])
        for feature in results:
            datos=[[album['name'],track['name'],feature['danceability'],feature['energy'],feature['key'],feature['loudness'],feature['mode'],feature['speechiness'],feature['acousticness'],feature['instrumentalness'],feature['liveness'],feature['valence'],feature['tempo']]]
            temp = pd.DataFrame(datos, columns = ['Album','Track','Danceability','Energy','Key','Loudness','Mode','Speechiness','Acousticness','Instrumentalness','Liveness','Valence','Tempo'])
            df = pd.concat([df, temp])
    print(df)
    return df

def get_audio_features(track_id):
    results = sp.audio_features(track_id)
    return results

def show_artist_albums(artist,df):
    albums = []
    results = sp.artist_albums(artist['id'], album_type='album')
    albums.extend(results['items'])
    while results['next']:
        results = sp.next(results)
        albums.extend(results['items'])
    logger.info('Total albums: %s', len(albums))
    unique = set()  # skip duplicate albums
    for album in albums:
        name = album['name'].lower()
        if name not in unique:
            print("entra")
            logger.info('ALBUM: %s', name)
            unique.add(name)
            df = show_album_tracks(album,df)
            #df = pd.concat([df, temp])
    return df

def show_artist(artist):
    logger.info('====%s====', artist['name'])
    logger.info('Popularity: %s', artist['popularity'])
    if len(artist['genres']) > 0:
        logger.info('Genres: %s', ','.join(artist['genres']))

def main():
    df=pd.DataFrame()
    args = get_args()
    artist = get_artist(args.artist)
    show_artist(artist)
    df = show_artist_albums(artist,df)
    df.to_csv('discografia.csv',index=False)


if __name__ == '__main__':
    sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id="44b6c1da36fc4598a23a028439422e13",
                                                           client_secret="78c32d30fc3d4adebd4e9a32fdfdbfa6"))
    main()