#---------------------------------------------
#1 tried algorithm with white image
#---------------------------------------------
setwd("C:\\Users\\Thanis\\Desktop\\Data Science\\Term 2\\Machine Learning 2\\PCA")

image =  readJPEG("orange.jpg")
dim(image)

r = image[,,1]
g = image[,,2]
b = image[,,3]

image.r.pca = prcomp(r, center = FALSE)
image.g.pca = prcomp(g, center = FALSE)
image.b.pca = prcomp(b, center = FALSE)

rgb.pca = list(image.r.pca, image.g.pca, image.b.pca)

ncomp = 50

R = image.r.pca$x[,1: ncomp]%*%t(image.r.pca$rotation[,1:ncomp])
G = image.g.pca$x[,1: ncomp]%*%t(image.g.pca$rotation[,1:ncomp])
B = image.b.pca$x[,1: ncomp]%*%t(image.b.pca$rotation[,1:ncomp])

img = array(c(R,G,B), dim = c(dim(image)[1:2],3))

summary(img)
writeJPEG(img, "orange_compressed1.jpg")

#---------------------------------------------
#2 applied correction factor and observed
#---------------------------------------------
image =  readJPEG("orange.jpg")
dim(image)

r = image[,,1]
g = image[,,2]
b = image[,,3]

image.r.pca = prcomp(r, center = FALSE)
image.g.pca = prcomp(g, center = FALSE)
image.b.pca = prcomp(b, center = FALSE)

rgb.pca = list(image.r.pca, image.g.pca, image.b.pca)

ncomp = 50

R = image.r.pca$x[,1: ncomp]%*%t(image.r.pca$rotation[,1:ncomp])
G = image.g.pca$x[,1: ncomp]%*%t(image.g.pca$rotation[,1:ncomp])
B = image.b.pca$x[,1: ncomp]%*%t(image.b.pca$rotation[,1:ncomp])

#correction factor
R <- ifelse(R<0,0,R)
R <- ifelse(R>1,1,R)
G <- ifelse(G<0,0,G)
G <- ifelse(G>1,1,G)
B <- ifelse(B<0,0,B)
B <- ifelse(B>1,1,B)

img = array(c(R,G,B), dim = c(dim(image)[1:2],3))
writeJPEG(img, "orange_compressed2.jpg")

#observed that all the distorted pixels (less than zero and greater than one) are corrected
#using the correction factor

#---------------------------------------------
#3 proportion of variance explained
#---------------------------------------------
setwd("C:\\Users\\Thanis\\Desktop\\Data Science\\Term 2\\Machine Learning 2\\PCA")

image =  readJPEG("orange.jpg")
dim(image)

r = image[,,1]
g = image[,,2]
b = image[,,3]

image.r.pca = prcomp(r, center = FALSE)
image.g.pca = prcomp(g, center = FALSE)
image.b.pca = prcomp(b, center = FALSE)

#rgb.pca = list(image.r.pca, image.g.pca, image.b.pca)

ncomp = 50

R = image.r.pca$x[,1: ncomp]%*%t(image.r.pca$rotation[,1:ncomp])
G = image.g.pca$x[,1: ncomp]%*%t(image.g.pca$rotation[,1:ncomp])
B = image.b.pca$x[,1: ncomp]%*%t(image.b.pca$rotation[,1:ncomp])


R <- ifelse(R<0,0,R)
R <- ifelse(R>1,1,R)
G <- ifelse(G<0,0,G)
G <- ifelse(G>1,1,G)
B <- ifelse(B<0,0,B)
B <- ifelse(B>1,1,B)
img = array(c(R,G,B), dim = c(dim(image)[1:2],3))

cr = img[,,1]
cg = img[,,2]
cb = img[,,3]

#calculating the proportion of variance
var_org_r = sum(apply(r, 2, var))
var_comp_r = sum(apply(cr, 2, var))
pro_r = var_comp_r/var_org_r * 100

var_org_g = sum(apply(g, 2, var))
var_comp_g = sum(apply(cg, 2, var))
pro_g = var_comp_g/var_org_g * 100

var_org_b = sum(apply(b, 2, var))
var_comp_b = sum(apply(cb, 2, var))
pro_b = var_comp_b/var_org_b * 100

print(paste('proportion of variation explained by r:', pro_r))
print(paste('proportion of variation explained by g:', pro_g))
print(paste('proportion of variation explained by b:', pro_b))

writeJPEG(img, "orange_compressed1.jpg")

#---------------------------------------------
#4 95% of variance explained
#---------------------------------------------
setwd("C:\\Users\\Thanis\\Desktop\\Data Science\\Term 2\\Machine Learning 2\\PCA")

image =  readJPEG("orange.jpg")
dim(image)

#checking whether the number of row is greater than columns, if not replace the assign x value as (no of rows - 1)
if (dim(image)[1] > dim(image)[2])
{
  x = dim(image)[2]
} else
{
  x = dim(image)[1]-1
}

ncomp_count = c(seq(10,100,10))

r = image[,,1]
g = image[,,2]
b = image[,,3]

image.r.pca = prcomp(r, center = FALSE)
image.g.pca = prcomp(g, center = FALSE)
image.b.pca = prcomp(b, center = FALSE)

#rgb.pca = list(image.r.pca, image.g.pca, image.b.pca)

for (ncomp in ncomp_count)
{
  if (ncomp < x)
  {
    print('>>>>>>>')
    R = image.r.pca$x[,1: ncomp]%*%t(image.r.pca$rotation[,1:ncomp])
    G = image.g.pca$x[,1: ncomp]%*%t(image.g.pca$rotation[,1:ncomp])
    B = image.b.pca$x[,1: ncomp]%*%t(image.b.pca$rotation[,1:ncomp])
    
    R <- ifelse(R<0,0,R)
    R <- ifelse(R>1,1,R)
    G <- ifelse(G<0,0,G)
    G <- ifelse(G>1,1,G)
    B <- ifelse(B<0,0,B)
    B <- ifelse(B>1,1,B)
    
    img = array(c(R,G,B), dim = c(dim(image)[1:2],3))
    
    cr = img[,,1]
    cg = img[,,2]
    cb = img[,,3]
    var_org_r = sum(apply(r, 2, var))
    var_comp_r = sum(apply(cr, 2, var))
    pro_r = var_comp_r/var_org_r * 100
    
    var_org_g = sum(apply(g, 2, var))
    var_comp_g = sum(apply(cg, 2, var))
    pro_g = var_comp_g/var_org_g * 100
    
    var_org_b = sum(apply(b, 2, var))
    var_comp_b = sum(apply(cb, 2, var))
    pro_b = var_comp_b/var_org_b * 100
    
    
    if ((pro_r > 95) & (pro_g > 95) & (pro_b > 95))
    {
      print(paste('no of columns to achieve 95% variance: ', ncomp))
      writeJPEG(img, "orange_compressed2.jpg")
      break
    }
  }else
  {
    print('ncomp is greater than column count')
    break
  }
  
}

#---------------------------------------------
#5 Application
#---------------------------------------------
compression <- function()
{
  x = choose.dir(default = "", caption = "Select folder")
  y = choose.dir(default = "", caption = "Destination folder")
  z = as.integer(readline(prompt="How much clarity do you want in the image? (%): "))
  d = readline(prompt="Do you want to delete the original? (y/n): ")
  fils <- list.files(x, pattern="jpg$", full.names = TRUE, recursive = TRUE)
  ncomp_count = c(seq(10,100,10))
  for(i in 1:length(fils))
  {
    #print(fils[i])
    image =  readJPEG(fils[i])
    #print(dim(image))
    if (dim(image)[1] > dim(image)[2])
    {
      x = dim(image)[2]
    } else
    {
      x = dim(image)[1]-1
    }
    
    r = image[,,1]
    g = image[,,2]
    b = image[,,3]
    
    image.r.pca = prcomp(r, center = FALSE)
    image.g.pca = prcomp(g, center = FALSE)
    image.b.pca = prcomp(b, center = FALSE)
    
    #rgb.pca = list(image.r.pca, image.g.pca, image.b.pca)
    for (ncomp in ncomp_count)
    {
      if (ncomp < x)
      {
        R = image.r.pca$x[,1: ncomp]%*%t(image.r.pca$rotation[,1:ncomp])
        G = image.g.pca$x[,1: ncomp]%*%t(image.g.pca$rotation[,1:ncomp])
        B = image.b.pca$x[,1: ncomp]%*%t(image.b.pca$rotation[,1:ncomp])
        
        R <- ifelse(R<0,0,R)
        R <- ifelse(R>1,1,R)
        G <- ifelse(G<0,0,G)
        G <- ifelse(G>1,1,G)
        B <- ifelse(B<0,0,B)
        B <- ifelse(B>1,1,B)
        
        img = array(c(R,G,B), dim = c(dim(image)[1:2],3))
        
        cr = img[,,1]
        cg = img[,,2]
        cb = img[,,3]
        var_org_r = sum(apply(r, 2, var))
        var_comp_r = sum(apply(cr, 2, var))
        pro_r = var_comp_r/var_org_r * 100
        
        var_org_g = sum(apply(g, 2, var))
        var_comp_g = sum(apply(cg, 2, var))
        pro_g = var_comp_g/var_org_g * 100
        
        var_org_b = sum(apply(b, 2, var))
        var_comp_b = sum(apply(cb, 2, var))
        pro_b = var_comp_b/var_org_b * 100
        
        
        if ((pro_r > z) & (pro_g > z) & (pro_b > z))
        {
          print(paste('no of columns to achieve', z ,'percent clarity: ', ncomp))
          writeJPEG(img, paste(y,"\\new_image",i,".jpg",sep = ''))
          break
        }
        
      }else
      {
        print('ncomp is greater than column count')
        break
      }
      
    }

  }
  if(d == 'y')
  {
    unlink(fils, recursive = TRUE)
  }
}


compression()
