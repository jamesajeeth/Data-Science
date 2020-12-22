import re
import pandas as pd
import twitter
from tweepy import OAuthHandler
from tweepy import API
from tweepy import Cursor
from datetime import datetime, date, time, timedelta
from collections import Counter
import sys

CONSUMER_KEY = 'gXhmOe3OzvaVaWVl5tjf5fnCk'
CONSUMER_SECRET = 'V3quGNxODVTSwcpxo8NxXk0GkBqZlDWWMwjsUQrNYreQNbhZcd'
OAUTH_TOKEN = '440690894-EMxMTM0MAe3rKC87k8JoCv9IObeUkSvHHbcAWjIy'
OAUTH_TOKEN_SECRET = 'ApnsNE2CrViH2oa0NNNYDtNkxhFAiwnTOkduLfUo0OvaB'

auth = OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.set_access_token(OAUTH_TOKEN, OAUTH_TOKEN_SECRET)
auth_api = API(auth)

def extraction(user_name,number_of_tweets):
    
    tweet_content = []
    names = []
    q = user_name
    user = auth_api.get_user(screen_name = q)
    user_id = user.id

    timeline = auth_api.user_timeline(user_id=user_id,count=number_of_tweets,tweet_mode="extended")

    for tweet in timeline:
        
        names.append(tweet._json['user']['name'])
        
        if 'retweeted_status' in tweet._json:
            tweet_content.append(tweet._json['retweeted_status']['full_text'])
        else:
            tweet_content.append(tweet._json['full_text'])
            
    data = {'name':names, 'tweet': tweet_content} 
    df = pd.DataFrame(data)
    return df