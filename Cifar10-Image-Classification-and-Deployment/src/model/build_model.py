from .densenet import DenseNet
from .googlenet import GoogLeNet
from .resnet import ResNet50
import torch
#user_name = ' '
def getModel(training=False, u_name= ' ', **kwargs):
    print("getModel: ", u_name)
    device  = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    if u_name == 'GoogleNet':
        model = GoogLeNet()
    elif u_name == 'DenseNet':
        model = DenseNet()
    elif u_name == 'ResNet50':
        model = ResNet50()
    else:
        model = GoogLeNet()

    model.eval()
    if training :
        model.train()
        model = torch.nn.DataParallel(model)
        print("The model is in training mode")
    print("No of params in model is " , sum(p.numel() for p in model.parameters() if p.requires_grad))
    model  = model.to(device)
    print(f"model is loaded on GPU {next(model.parameters()).is_cuda}")
    return model
