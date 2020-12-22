import pandas as pd
from tweepy import OAuthHandler
from tweepy import API
from tweepy import Cursor
import twitter

CONSUMER_KEY = 'gXhmOe3OzvaVaWVl5tjf5fnCk'
CONSUMER_SECRET = 'V3quGNxODVTSwcpxo8NxXk0GkBqZlDWWMwjsUQrNYreQNbhZcd'
OAUTH_TOKEN = '440690894-EMxMTM0MAe3rKC87k8JoCv9IObeUkSvHHbcAWjIy'
OAUTH_TOKEN_SECRET = 'ApnsNE2CrViH2oa0NNNYDtNkxhFAiwnTOkduLfUo0OvaB'

auth = twitter.oauth.OAuth(OAUTH_TOKEN, OAUTH_TOKEN_SECRET,
CONSUMER_KEY, CONSUMER_SECRET)

twitter_api = twitter.Twitter(auth=auth)
auth = OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.set_access_token(OAUTH_TOKEN, OAUTH_TOKEN_SECRET)
auth_api = API(auth)

def hashtag(hashtag,number_of_tweets):
    
    tweet_content = []
    names = []

    q = hashtag
    count = number_of_tweets

    search_results = twitter_api.search.tweets(q=q, count=count,result_type='recent',tweet_mode='extended')
    
    #print(">>>>>>>>",len(search_results['statuses']))
    for i in range(1, len(search_results['statuses'])):
        #print(i)        
        names.append(search_results['statuses'][i]['user']['name'])
        
        if 'retweeted_status' in search_results['statuses'][i]:
            tweet_content.append(search_results['statuses'][i]['retweeted_status']['full_text'])
        else:
            tweet_content.append(search_results['statuses'][i]['full_text'])
        
    data = {'User Name' : names, 'tweet': tweet_content} 
    df = pd.DataFrame(data)
    return(df)