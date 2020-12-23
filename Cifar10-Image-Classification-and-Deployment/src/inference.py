from .model import getModel
from pathlib import Path
import PIL
import torch
from torchvision import  transforms


class Inference:
    def __init__(self, user_name, save_model_filename=["saved_weights_googlenet.pt", "saved_weights_densenet.pt", "saved_weights_resnet.pt"]):
        self.user_name = user_name
        print("Inference: ", self.user_name)
        self.classes = ['airplane', 'automobile', 'bird', 'cat', 'deer', 'dog', 'frog', 'horse', 'ship','truck']
        self.model = getModel(training=False, u_name = user_name, num_classes=len(self.classes))
        device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        if self.user_name == 'GoogleNet':
            print('load weight: ',user_name)
            self.model.load_state_dict(torch.load(f"./src/saved_weights/{save_model_filename[0]}",map_location=device))
            return None
        elif self.user_name == 'DenseNet':
            print('load weight: ',user_name)
            self.model.load_state_dict(torch.load(f"./src/saved_weights/{save_model_filename[1]}",map_location=device))
            return None
        elif self.user_name == 'ResNet50':
            print('load weight: ',user_name)
            self.model.load_state_dict(torch.load(f"./src/saved_weights/{save_model_filename[2]}",map_location=device))
            return None

    def __call__(self,image):
        if isinstance(image,(Path,str)):
            image = PIL.Image.open(image).convert("RGB")
        elif not isinstance(image,PIL.JpegImagePlugin.JpegImageFile): 
            raise Exception("must be PIL image or path ")
        image_input = transforms.ToTensor()(image).unsqueeze(0)
        with torch.no_grad():
            out = self.model(image_input).squeeze(0)
            prob = torch.argmax(out).item()
            return self.classes[prob]

