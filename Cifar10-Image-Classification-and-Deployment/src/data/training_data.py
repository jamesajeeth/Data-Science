from torchvision import datasets , transforms
from torch.utils.data import DataLoader
import torch

class Cifar10Data:
    def __init__(self,):
        self.train_transforms = transforms.Compose([transforms.RandomCrop(size=32 , padding=4 , padding_mode="symmetric",pad_if_needed=True),
                                                    transforms.RandomHorizontalFlip(p=0.5),
                                                    transforms.ToTensor()])
        self.val_transforms = transforms.Compose([transforms.ToTensor()])
        self.trainset = datasets.CIFAR10(train=True,root = "data/",download=True,transform=self.train_transforms)
        self.valset  = datasets.CIFAR10(train=False , root="data/",download=True,transform=self.val_transforms)

        return None

    def dataloader(self,batch_size=64 ,num_workers = 4,device_count=torch.cuda.device_count()):
        loader_param = { "batch_size":batch_size*device_count,
                        "pin_memory":True,
                        "num_workers":num_workers,
                        "shuffle":True}

        trainLoader = DataLoader(self.trainset,**loader_param)
        valLoader = DataLoader(self.valset  ,**loader_param)
        return {"train":trainLoader , "val":valLoader}
    
    @property
    def num_classes(self,): return len(self.trainset.classes)
