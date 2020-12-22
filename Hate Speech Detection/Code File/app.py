from flask import Flask, request, render_template
import prediction_final
import extraction
import hashtag
import report
import os
import pandas as pd

app = Flask(__name__)

@app.route('/')
def my_form():
    return render_template('upload.html')

@app.route("/", methods=["POST","GET"])
def my_form_post():
	notOffensive=True
	if request.method == "POST":
		text = request.form['message']
		processed_text = prediction_final.prediction(text)
		res = processed_text['off_or_not'].tolist()[0]
		if res == "Offensive comment":
			notOffensive=False
		return render_template('upload.html', tweet=text+' : ', result=res, notOffensive=notOffensive)
	else:
		return render_template('upload.html')

@app.route("/username", methods=["POST", "GET", "PUT"])
def my_form_post1():
	isIndex=False
	if request.method == "POST":
		user_name = request.form['message']
		number = request.form.get('count')
		extracted_tweet = extraction.extraction(user_name,number)
		if len(extracted_tweet) != 0:
			processed_text = prediction_final.prediction(extracted_tweet)
			process_json = processed_text.to_dict('records')
			columnNames = processed_text.columns.values
			return render_template('upload1.html', records=process_json, colnames=columnNames, isIndex=True, username=user_name)
		else:
			return render_template('upload1.html', result = '**No records found**')
	else:
		return render_template('upload1.html')

@app.route("/hashtag", methods=["POST", "GET", "PUT"])
def my_form_post2():
	isIndex=False
	if request.method == "POST":
		user_name = request.form['message']
		number = request.form.get('count')
		hashtag_tweet = hashtag.hashtag(user_name,number)
		if len(hashtag_tweet) != 0:

			processed_text = prediction_final.prediction(hashtag_tweet)
			#print(processed_text)
			processed_text = processed_text.loc[processed_text.off_or_not!='Offensive',['User Name','tweet']]
			process_json = processed_text.to_dict('records')
			columnNames = processed_text.columns.values
			return render_template('upload2.html', records=process_json, colnames=columnNames, isIndex=True, username=user_name)
		else:
			return render_template('upload2.html', result = '**No records found**')
	else:
		return render_template('upload2.html')

@app.route("/report", methods=["POST"])
def report_spam():
	user_name = request.form['message']
	report.report_user(user_name)
	return render_template('basic.html')

app.run(debug=True, host = '127.0.0.1', port=5000)
