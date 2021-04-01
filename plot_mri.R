plot_mri <- function(statfile,maxloc=c(77,58,39)) {

  layout(matrix(1:3,ncol=3))

  image(1:dim(statfile)[1],1:dim(statfile)[2],statfile[,,maxloc[3]],asp=dim(statfile)[2]/dim(statfile)[1]);points(maxloc[1],maxloc[2],pch=19,col='green')
  image(1:dim(statfile)[1],1:dim(statfile)[3],statfile[,maxloc[2],],asp=dim(statfile)[3]/dim(statfile)[1]);points(maxloc[1],maxloc[3],pch=19,col='green')
  image(1:dim(statfile)[2],1:dim(statfile)[3],statfile[maxloc[1],,],asp=dim(statfile)[3]/dim(statfile)[2]);points(maxloc[2],maxloc[3],pch=19,col='green')
  
}
  
