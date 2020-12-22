import os
import pickle
import pandas as pd
import numpy as np
import re
from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer

#path of saved pickle file
saved_path = 'C:\\Users\\Thanis\\Desktop\\Data Science\\Project\\multi lang v1\\Saved model\\'

files= [file for file in os.listdir(saved_path)]

#loading the pre-trained model
loaded_ar_model = pickle.load(open(saved_path + files[0], 'rb'))
loaded_da_model = pickle.load(open(saved_path + files[1], 'rb'))
loaded_en_model = pickle.load(open(saved_path + files[2], 'rb'))
loaded_fr_model = pickle.load(open(saved_path + files[3], 'rb'))
loaded_gr_model = pickle.load(open(saved_path + files[4], 'rb'))
loaded_hi_model = pickle.load(open(saved_path + files[5], 'rb'))
loaded_in_model = pickle.load(open(saved_path + files[6], 'rb'))
loaded_lang_model = pickle.load(open(saved_path + files[7], 'rb'))
loaded_tu_model = pickle.load(open(saved_path + files[8], 'rb'))

test_ar_transform = pickle.load(open(saved_path + files[9], 'rb'))
test_da_transform = pickle.load(open(saved_path + files[10], 'rb'))
test_en_transform = pickle.load(open(saved_path + files[11], 'rb'))
test_fr_transform = pickle.load(open(saved_path + files[12], 'rb'))
test_gr_transform = pickle.load(open(saved_path + files[13], 'rb'))
test_hi_transform = pickle.load(open(saved_path + files[14], 'rb'))
test_in_transform = pickle.load(open(saved_path + files[15], 'rb'))
test_lang_transform = pickle.load(open(saved_path + files[16], 'rb'))
test_tu_transform = pickle.load(open(saved_path + files[17], 'rb'))

def test_l_transform(test_X, tfidf_vectorizer):

    tfidf_matrix_test = tfidf_vectorizer.transform(test_X)
    vocabulary = tfidf_vectorizer.get_feature_names()
    return pd.DataFrame(data=tfidf_matrix_test.toarray(), columns=vocabulary).iloc[:,0::2]

def test_transform(test_X, tfidf_vectorizer):

    test_X = [test_X]
    tfidf_matrix_test = tfidf_vectorizer.transform(test_X)
    vocabulary = tfidf_vectorizer.get_feature_names()
    return pd.DataFrame(data=tfidf_matrix_test.toarray(), columns=vocabulary).iloc[:,0::2]

def speech_detector(pred_lang,test_X1):
    
    pred_list = []
    for i in range(0,len(pred_lang)):
        if pred_lang[i] == 'en':
            test_X = test_transform(test_X1[i], test_en_transform)
            pred = loaded_en_model.predict(test_X)
            pred_list.append(pred.tolist())
            
        elif pred_lang[i] == 'FR':
            test_X = test_transform(test_X1[i], test_fr_transform)
            pred = loaded_fr_model.predict(test_X)
            pred_list.append(pred.tolist())
            
        elif pred_lang[i] == 'AR':
            test_X = test_transform(test_X1[i], test_ar_transform)
            pred = loaded_ar_model.predict(test_X)
            pred_list.append(pred.tolist())
            
        elif pred_lang[i] == 'ID':
            test_X = test_transform(test_X1[i], test_in_transform)
            pred = loaded_in_model.predict(test_X)
            pred_list.append(pred.tolist())
            
        elif pred_lang[i] == 'DA':
            test_X = test_transform(test_X1[i], test_da_transform)
            pred = loaded_da_model.predict(test_X)
            pred_list.append(pred.tolist())
            
        elif pred_lang[i] == 'HI':
            test_X = test_transform(test_X1[i], test_hi_transform)
            pred = loaded_hi_model.predict(test_X)
            pred_list.append(pred.tolist())

        elif pred_lang[i] == 'TU':
            test_X = test_transform(test_X1[i], test_tu_transform)
            pred = loaded_tu_model.predict(test_X)
            pred_list.append(pred.tolist())

        elif pred_lang[i] == 'GR':
            test_X = test_transform(test_X1[i], test_gr_transform)
            pred = loaded_gr_model.predict(test_X)
            pred_list.append(pred.tolist())
    
    return pred_list

def final(pred):
    
    output_list = []
    for i in range(0,len(pred)):
        if pred[i] == 1:
            output = "Offensive comment"
            output_list.append(output)
        else:
            output = "Not offensive"
            output_list.append(output)
    return output_list

def prediction(pred_input):

    df = pd.DataFrame()
    df1 = pd.DataFrame()
    if type(pred_input) is str:
        df['tweet'] = [pred_input]
        df1['tweet'] = [pred_input]
    else:
        df = pred_input.copy()
        df1 = pred_input.copy()
    #print(df)  
    for index, row in df.iterrows():
        df.loc[index ,"tweet"] = df.loc[index ,"tweet"].lower()
        df.loc[index ,"tweet"] = re.sub(r'#fuck','fuck ',df.loc[index ,"tweet"])
        df.loc[index ,"tweet"] = re.sub(r'#bitch','bitch',df.loc[index ,"tweet"])
        df.loc[index ,"tweet"] = re.sub(r'#kill','kill ',df.loc[index ,"tweet"])
        df.loc[index ,"tweet"] = re.sub(r'@\w+', 'mention', df.loc[index ,"tweet"])
        df.loc[index ,"tweet"] = re.sub(r'#\w{6,}\b', ' ',df.loc[index ,"tweet"])

        df.loc[index ,"tweet"] = re.sub(r'https://\b','url',df.loc[index ,"tweet"])
        df.loc[index ,"tweet"] = re.sub(r'\n','',df.loc[index ,"tweet"])
    
    #handling space in the dataframe
    df['spaces'] = list(map(lambda x: x.isspace(), df['tweet']))
    df = df.loc[df.spaces!=True,]
    df = df.reset_index(drop=True)
    df.drop(['spaces'], axis = 1, inplace = True)
    test_X1 = df['tweet']
    test_X = test_l_transform(test_X1, test_lang_transform)
    pred_lang = loaded_lang_model.predict(test_X)
    #df['lang'] = pred_lang
    pred = speech_detector(pred_lang, test_X1)
    #converting list of list into list
    pred = [item for sublist in pred for item in sublist]
    final_prediction = final(pred)
    #df['pred'] = pred
    df['off_or_not'] = final_prediction
    df['tweet'] = df1['tweet']
    #print(df)
    return df