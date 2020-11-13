#---------------------------------------------
#5 Application
#---------------------------------------------
compression <- function()
{
  x = choose.dir(default = "", caption = "Source folder")
  y = choose.dir(default = "", caption = "Destination folder")
  z = as.integer(readline(prompt="How much clarity do you want in the image? (%): "))
  d = readline(prompt="Do you want to delete the original? (y/n): ")
  fils <- list.files(x, pattern="jpg$", full.names = TRUE, recursive = TRUE)
  
  for(i in 1:length(fils))
  {
    #print(fils[i])
    image =  readJPEG(fils[i])
    #print(dim(image))
    if (dim(image)[1] > dim(image)[2])
    {
      a = dim(image)[2]
    } else
    {
      a = dim(image)[1]-1
    }
    
    ncomp_count = c(seq(10,a,10))
    
    r = image[,,1]
    g = image[,,2]
    b = image[,,3]
    
    image.r.pca = prcomp(r, center = FALSE)
    image.g.pca = prcomp(g, center = FALSE)
    image.b.pca = prcomp(b, center = FALSE)
    
    #rgb.pca = list(image.r.pca, image.g.pca, image.b.pca)
    for (ncomp in ncomp_count)
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
      
    }
    
  }
  if(d == 'y')
  {
    unlink(fils, recursive = TRUE)
  }
}


#
compression()
