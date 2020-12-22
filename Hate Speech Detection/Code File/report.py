# import the module 
from tweepy import OAuthHandler
from tweepy import API

CONSUMER_KEY = 'gXhmOe3OzvaVaWVl5tjf5fnCk'
CONSUMER_SECRET = 'V3quGNxODVTSwcpxo8NxXk0GkBqZlDWWMwjsUQrNYreQNbhZcd'
OAUTH_TOKEN = '440690894-EMxMTM0MAe3rKC87k8JoCv9IObeUkSvHHbcAWjIy'
OAUTH_TOKEN_SECRET = 'ApnsNE2CrViH2oa0NNNYDtNkxhFAiwnTOkduLfUo0OvaB'


auth = OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.set_access_token(OAUTH_TOKEN, OAUTH_TOKEN_SECRET)
auth_api = API(auth)
  
# the account to be reported 
def report_user(name):

	screen_name = name  
	# reporting the account 
	auth_api.report_spam(screen_name = screen_name)
	print(screen_name)
	print("USER REPORTED!!!")