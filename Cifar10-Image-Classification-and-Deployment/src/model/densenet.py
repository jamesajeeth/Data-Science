import torch
import torch.nn as nn
import torch.nn.functional as F
from collections import OrderedDict

class DenseLayer(nn.Module):
    def __init__(self,num_channels,growth_rate,bn_size,drop_rate):
        super(DenseLayer,self).__init__()
        mid_channel = int(growth_rate*bn_size)
        self.add_module("bn1",nn.BatchNorm2d(num_channels))
        self.add_module("relu1",nn.ReLU(inplace=True))
        self.add_module("conv1",nn.Conv2d(num_channels,mid_channel ,kernel_size=1 , bias=False))
        self.add_module("bn2",nn.BatchNorm2d(mid_channel))
        self.add_module("relu2",nn.ReLU(inplace=True))
        self.add_module("conv2",nn.Conv2d(mid_channel ,growth_rate,kernel_size=3,padding=1 , bias=False))
        self.drop_rate=drop_rate
    def forward(self,*prev_features):
        concated_features = torch.cat(prev_features, 1)
        bottleneck_output = self.conv1(self.relu1(self.bn1(concated_features)))
        new_features = self.conv2(self.relu2(self.bn2(bottleneck_output)))
        if self.drop_rate > 0:
            new_features = F.dropout(new_features, p=self.drop_rate, training=self.training)
        return new_features

class Transition(nn.Module):
    def __init__(self,num_channels,num_out_channels):
        super(Transition,self).__init__()
        self.add_module("bn",nn.BatchNorm2d(num_channels))
        self.add_module("relu",nn.ReLU(inplace=True))
        self.add_module("conv",nn.Conv2d(num_channels,num_out_channels ,kernel_size=1 , bias=False))
        self.add_module("pool",nn.AvgPool2d(kernel_size=2, stride=2))
    def forward(self,x):
        out = self.conv(self.relu(self.bn(x)))
        out = self.pool(out)
        return out

class DenseBlock(nn.Module):
    
    def __init__(self,num_layers,num_channels,growth_rate,bn_size,drop_rate):
        super(DenseBlock,self).__init__()
        for i in range(num_layers):
            layer = DenseLayer(num_channels=num_channels+i*growth_rate,
                               growth_rate=growth_rate,
                               bn_size=bn_size,
                               drop_rate=drop_rate)
            self.add_module(f"denselayer{i+1}",layer)
    
    def forward(self, init_features):
        features = [init_features]
        for name, layer in self.named_children():
            new_features = layer(*features)
            features.append(new_features)
        return torch.cat(features, 1)



class DenseNet(nn.Module):
    def __init__(self,growth_rate=32,block_config=(6,12,24,16),
                num_init_features=64,bn_size=4, drop_rate=0.1,num_classes=10):
        super(DenseNet,self).__init__()
        
        self.features = nn.Sequential(OrderedDict([
            ("conv0",nn.Conv2d(3,num_init_features,kernel_size=3,bias=False)),
        ]))
        
        num_features=num_init_features
        for i, num_layers in enumerate(block_config):
            block  = DenseBlock(num_layers = num_layers,
                               num_channels=num_features,
                                growth_rate=growth_rate,
                                bn_size=bn_size,
                                drop_rate=drop_rate)
            self.features.add_module(f"denseblock{i+1}",block)
            num_features = num_features + num_layers * growth_rate
            if i<len(block_config)-1:
                transition = Transition(num_features,num_features//2)
                num_features=num_features//2
                self.features.add_module(f"transition{i+1}",transition)
        self.features.add_module("norm5",nn.BatchNorm2d(num_features))
        self.classifier = nn.Linear(num_features,num_classes)

    def forward(self, x):
        features = self.features(x)
        out = F.relu(features, inplace=True)
        out = F.adaptive_avg_pool2d(out, (1, 1))
        out = torch.flatten(out, 1)
        out = self.classifier(out)
        return out
