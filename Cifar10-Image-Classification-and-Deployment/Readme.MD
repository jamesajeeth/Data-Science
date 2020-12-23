Saved_weights drive link -->  https://drive.google.com/drive/folders/1hmhy9_7etJqpmr8AxG3O0tYYhsc2rOGg?usp=sharing

## Setting up the Environment

To setup the environment 

#install the virtualenv
python -m pip install -U virtualenv 

#creating an environment
virtualenv -p python dev_env

#activate environment
source dev_env/bin/activate 

#clone the repo
git clone https://github.com/jamesajeeth/Data-Science/tree/master/Cifar10-Image-Classification-and-Deployment

#save the saved_weights
Download the saved_file from the drive link and paste it in src/saved_weights
cd Image-Classification-and-Deployment
pip install -r requirements.txt # install the requirements



## For Training

This cifar10 model can be trained in GoogleNet, DenseNet, Resnet50.
open the file train_note.py and select any one then train the model by executing the below commad line....

cd Image-Classification-and-Deployment
python train_note.py 


## For Inference

 we need Cifar-10 data for inference. 10 sample image data is present in the data folder


Run InferenceNotebook.ipynb from jupyter notebook


## Model Serving on Flask (Deployment)

For Serving this model as a website. Execute the below code


python flask_api/app.py

(After running the above code the web actually looks like Web_interface.JPG )
