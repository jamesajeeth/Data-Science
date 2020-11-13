install.packages("jpeg")
library(jpeg)

setwd("C:\\Users\\Thanis\\Desktop\\Data Science\\Term 2\\Machine Learning 2\\PCA")

image =  readJPEG("orange.jpg")
dim(image)

writeJPEG(image, "pianist.jpg")

r = image[,,1]
g = image[,,2]
b = image[,,3]

writeJPEG(r, "katia_red.jpg")
writeJPEG(b, "katia_blue.jpg")
writeJPEG(g, "katia_green.jpg")

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

summary(as.vectory(R))
R <- ifelse(R<0,0,R)
R <- ifelse(R>1,1,R)
G <- ifelse(G<0,0,G)
G <- ifelse(G>1,1,G)
B <- ifelse(B<0,0,B)
B <- ifelse(B>1,1,B)


View(image.r.pca$rotation)
View(image.r.pca$x)

apply(r,2,var)
sum(apply(r, 2, var))

apply(b,2,var)
sum(apply(b, 2, var))

apply(g,2,var)
sum(apply(g, 2, var))

apply(image.r.pca$x,2,var)
sum(apply(image.r.pca$x, 2, var))

apply(image.b.pca$x,2,var)
sum(apply(image.b.pca$x, 2, var))

apply(image.g.pca$x,2,var)
sum(apply(image.g.pca$x, 2, var))

#---------------------------------------------
sum(apply(image.r.pca$x[,1:30], 2, var))
sum(apply(image.b.pca$x[,1:10], 2, var))
sum(apply(image.g.pca$x[,1:10], 2, var))
95/100*4.076665
95/100*127.1782
95/100*36.53806
#---------------------------------------------


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

if (pro_r > 95 & pro_g > 95 & pro_b > 95)
{
  writeJPEG(img, "orange_compressed1.jpg")
}

