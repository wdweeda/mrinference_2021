#Finit impulse response function
#onset in seconds
#tslength in TR
#hrflen in seconds (total length to be captured)
#window in seconds (length of each window)
#TR is TR

FIR <- function(onset, tslength, hrflen, window, TR) {
  
  onset_in_TR <- round(onset/TR)
  num_windows <- round(hrflen/window)
  firlen <- round(window/TR)
  
  mat <- matrix(0,nrow=tslength,ncol=num_windows)
  
  for(i in 1:length(onset_in_TR)) {
    
    cur_onset <- onset_in_TR[i]
    
    for(j in 1:ncol(mat)) {
      
      mat[(cur_onset+(firlen)*(j-1)):((cur_onset+(firlen-1)+((firlen)*(j-1)))),j] <- 1
      
    }
    
  }

  return(mat)
}