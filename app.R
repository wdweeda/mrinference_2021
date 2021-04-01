#app.R v2

library(shiny)

if(length(dim(tdat))==3) tdat = array(tdat,dim=c(dim(tdat)[1],dim(tdat)[2],dim(tdat)[3],1))

maxvalz = dim(tdat)[3]
maxvalx = dim(tdat)[1]
maxvaly = dim(tdat)[2]

volume = 1

maxvol = dim(tdat)[4]

xloc = round(maxvalx/2)
yloc = round(maxvaly/2)
zloc = round(maxvalz/2)
title = 'nothing'

cat('done\n')

ui <- fluidPage(
  fluidRow(
    column(4,
           verbatimTextOutput('text1')
    ),
    column(4,
           sliderInput("size","Size",
                       min = 1,
                       max = 11,
                       value = 1,
                       step = 2
           )
    ),
    column(4,
           sliderInput("volume","Volume",
                       min = 1,
                       max = maxvol,
                       value = 1,
                       step=1
           )
    )
  ),
  
  fluidRow(
    column(4,
           plotOutput('axial_plot',click='plot_click_axial')
    ),
    column(4,
           plotOutput('sagittal_plot',click='plot_click_sagittal')
    ),
    column(4,
           plotOutput('coronal_plot',click='plot_click_coronal')
    )
  ),
  fluidRow(
    column(4,
           verbatimTextOutput("plot_clickinfo_axial")
    ),
    column(4,
           verbatimTextOutput("plot_clickinfo_sagittal")
    ),
    column(4,
           verbatimTextOutput("plot_clickinfo_coronal")
    )
  ),
  
  fluidRow(
    column(6,
           plotOutput('time_series_plot',click='plot_click_ts')
    ),
    column(6,
           verbatimTextOutput("ev_info")
           )
  )
  
)



server <- function(input, output, session) 
{
  
  x = xloc
  y = yloc
  z = zloc
  
  #output$text1 <- renderText({paste0('fMRI Viewer (c) Wouter Weeda')})
  output$text1 <- renderText({paste0('fMRI Viewer (c) Wouter Weeda','\n')})
  
  output$axial_plot <- renderPlot({eval(plotFmriImage('axial',input))})
  output$coronal_plot <- renderPlot({eval(plotFmriImage('coronal',input))})
  output$sagittal_plot <- renderPlot({eval(plotFmriImage('sagittal',input))})
  output$time_series_plot <- renderPlot({eval(plotTs())})
  
  output$plot_clickinfo_axial <- renderText(eval(showValues()))
  output$plot_clickinfo_sagittal <- renderText(eval(showValues()))
  output$plot_clickinfo_coronal <- renderText(eval(showValues()))
  
  output$ev_info <- renderText({title})
  
  observeEvent(input$plot_click_axial,{
    if(!is.numeric(input$plot_click_axial$x)) xloc = x else xloc = round(input$plot_click_axial$x*dim(tdat)[1])
    if(!is.numeric(input$plot_click_axial$y)) yloc = y else yloc = round(input$plot_click_axial$y*dim(tdat)[2])
    x <<- xloc
    y <<- yloc
    
    if(x>dim(tdat)[1]) x <<- dim(tdat)[1]
    if(x<1) x <<- 1
    if(y>dim(tdat)[2]) y <<- dim(tdat)[2]
    if(y<1) y <<- 1
    if(z>dim(tdat)[3]) y <<- dim(tdat)[3]
    if(z<1) z <<- 1
    
    output$coronal_plot <- renderPlot({eval(plotFmriImage('coronal',input))})
    output$sagittal_plot <- renderPlot({eval(plotFmriImage('sagittal',input))})
    output$axial_plot <- renderPlot({eval(plotFmriImage('axial',input))})
    output$time_series_plot <- renderPlot({eval(plotTs())})
    
    output$plot_clickinfo_axial <- renderText(eval(showValues()))
    output$plot_clickinfo_sagittal <- renderText(eval(showValues()))
    output$plot_clickinfo_coronal <- renderText(eval(showValues()))
    output$ev_info <- renderText({title})
  })
  
  observeEvent(input$plot_click_sagittal,{
    if(!is.numeric(input$plot_click_sagittal$x)) xloc = y else xloc = round(input$plot_click_sagittal$x*dim(tdat)[2])
    if(!is.numeric(input$plot_click_sagittal$y)) yloc = z else yloc = round(input$plot_click_sagittal$y*dim(tdat)[3])
    y <<- xloc
    z <<- yloc
    
    if(x>dim(tdat)[1]) x <<- dim(tdat)[1]
    if(x<1) x <<- 1
    if(y>dim(tdat)[2]) y <<- dim(tdat)[2]
    if(y<1) y <<- 1
    if(z>dim(tdat)[3]) y <<- dim(tdat)[3]
    if(z<1) z <<- 1
    
    output$coronal_plot <- renderPlot(eval(plotFmriImage('coronal',input)))
    output$sagittal_plot <- renderPlot(eval(plotFmriImage('sagittal',input)))
    output$axial_plot <- renderPlot(eval(plotFmriImage('axial',input)))
    output$time_series_plot <- renderPlot(eval(plotTs()))
    
    output$plot_clickinfo_axial <- renderText(eval(showValues()))
    output$plot_clickinfo_sagittal <- renderText(eval(showValues()))
    output$plot_clickinfo_coronal <- renderText(eval(showValues()))
    output$ev_info <- renderText({title})
  })
  
  observeEvent(input$plot_click_coronal,{
    if(!is.numeric(input$plot_click_coronal$x)) xloc = x else xloc = round(input$plot_click_coronal$x*dim(tdat)[1])
    if(!is.numeric(input$plot_click_coronal$y)) yloc = z else yloc = round(input$plot_click_coronal$y*dim(tdat)[3])
    x <<- xloc
    z <<- yloc
    
    if(x>dim(tdat)[1]) x <<- dim(tdat)[1]
    if(x<1) x <<- 1
    if(y>dim(tdat)[2]) y <<- dim(tdat)[2]
    if(y<1) y <<- 1
    if(z>dim(tdat)[3]) y <<- dim(tdat)[3]
    if(z<1) z <<- 1
    
    output$coronal_plot <- renderPlot(eval(plotFmriImage('coronal')))
    output$sagittal_plot <- renderPlot(eval(plotFmriImage('sagittal')))
    output$axial_plot <- renderPlot(eval(plotFmriImage('axial')))
    output$time_series_plot <- renderPlot(eval(plotTs()))
    
    output$plot_clickinfo_axial <- renderText(eval(showValues()))
    output$plot_clickinfo_sagittal <- renderText(eval(showValues()))
    output$plot_clickinfo_coronal <- renderText(eval(showValues()))
    output$ev_info <- renderText({title})
  })
  
  observeEvent(input$plot_click_ts,{
    updateSliderInput(session,"volume",value=round(input$plot_click_ts$x))
    output$coronal_plot <- renderPlot(eval(plotFmriImage('coronal')))
    output$sagittal_plot <- renderPlot(eval(plotFmriImage('sagittal')))
    output$axial_plot <- renderPlot(eval(plotFmriImage('axial')))
    
   })
  
  observeEvent(input$volume,{
    output$ev_info <- renderText({title}) 
  })
}

showValues <- function() {
  return(expression({
    paste0('x = ',x,', y = ',y,', z = ',z,input$volume,'\nvalue = ',round(tdat[x,y,z,input$volume]))
  }))
}

#functions
plotFmriImage <- function(what,input) {
  if(what=='axial') return(expression({
    par(mar=c(0,0,0,0))
    image(tdat[,,z,input$volume],col=gray(seq(0,1,length.out=64)),asp=dim(tdat)[2]/dim(tdat)[1])
    
    xpos = x/dim(tdat)[1]
    ypos = y/dim(tdat)[2]
    sizex = ((input$size-1)/dim(tdat)[1])/2
    sizey = ((input$size-1)/dim(tdat)[2])/2
    
    rect(xpos-sizex,ypos-sizey,xpos+sizex,ypos+sizey,col='green',border='green')
    points(xpos,ypos,pch=15,col='green')
  })
  )
  
  if(what=='sagittal') return(expression({
    par(mar=c(0,0,0,0))
    image(tdat[x,,,input$volume],col=gray(seq(0,1,length.out=64)),asp=dim(tdat)[3]/dim(tdat)[2])
    
    xpos = y/dim(tdat)[2]
    ypos = z/dim(tdat)[3]
    sizex = ((input$size-1)/dim(tdat)[2])/2
    sizey = ((input$size-1)/dim(tdat)[3])/2
    
    rect(xpos-sizex,ypos-sizey,xpos+sizex,ypos+sizey,col='green',border='green')
    points(xpos,ypos,pch=15,col='green')
    
  })
  )
  
  if(what=='coronal') return(expression({
    par(mar=c(0,0,0,0))
    image(tdat[,y,,input$volume],col=gray(seq(0,1,length.out=64)),asp=dim(tdat)[3]/dim(tdat)[1])

    xpos = x/dim(tdat)[1]
    ypos = z/dim(tdat)[3]
    sizex = ((input$size-1)/dim(tdat)[1])/2
    sizey = ((input$size-1)/dim(tdat)[3])/2
    
    rect(xpos-sizex,ypos-sizey,xpos+sizex,ypos+sizey,col='green',border='green')
    points(xpos,ypos,pch=15,col='green')
  })
  )
}

plotTs <- function() {
  return(expression({
    par(las=1,mar=c(5,4,0,0))
    size = (input$size-1)/2
    seldat = tdat[(x-size):(x+size),(y-size):(y+size),(z-size):(z+size),]
    
    
    if(is.null(dim(seldat))) {
      plot(NA,NA,xlim=c(1,dim(tdat)[4]),ylim=range(seldat),bty='n',xlab='',ylab='')
      lines(tdat[x,y,z,],lwd=2,col=rainbow(64)[1])
      points(input$volume,tdat[x,y,z,input$volume],col='blue',pch=19,cex=1.2)
    } else {
      cm = matrix(seldat,nrow=dim(seldat)[1]*dim(seldat)[2]*dim(seldat)[3],ncol=dim(seldat)[4])
      ccm = cov(t(cm))
      ev = princomp(cov=ccm)
      evts = as.vector(ev$loadings[,1]%*%cm)
      if(cor(apply(cm,2,mean),evts)<0) evts = evts*-1
      plot(NA,NA,xlim=c(1,dim(tdat)[4]),ylim=range(evts),bty='n',xlab='',ylab='')
      lines(evts,lwd=2,col=rainbow(64)[1])
      points(input$volume,evts[input$volume],col='blue',pch=19,cex=1.2)
    }
    
  }))
}

shinyApp(ui = ui, server = server)


