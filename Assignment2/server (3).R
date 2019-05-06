library(pls)
library(shiny)
library(shinyjs)
library(ChemometricsWithR)

shinyServer(function(input, output){
  data(gasoline)
  datab<-gasoline
  the_data <- reactive({
   # Noisify <- function(data) {
   # if (is.vector(data)) {
     # noise <- runif(length(data), input$noise, input$noise2)
     # noisified <- data + noise
   # } else {
      #length <- dim(data)[1] * dim(data)[2]
      #noise <- matrix(runif(length, input$noise, input$noise2), dim(data)[1])
      #noisified <-data + noise
    #}
    #return(noisified)
    #}})
    
  
   
xx=seq(from=1,to=100)
      noise <- input$noise
      if(noise == "Low") sdx = 25
      if(noise == "Medium") sdx = 75
      if(noise == "High") sdx = 200
      yy <-rnorm(30*input$n, 0, sd=sdx) + 100
      data.frame( Y=yy)
    })
  
  
  output$PLSR<-renderPlot({
    data1<-the_data()
    gas<-plsr(octane ~ NIR, ncomp = 10,data = datab, method = input$Method, validation = input$valid)
    plot(RMSEP(gas), comps = input$Components,legendpos = "topright")
    summary(gas)
  })
  
  output$corr<-renderPlot({
    gas<-plsr(octane ~ NIR, ncomp = 10,data = datab, method = input$Method, validation = input$valid)
    plot(gas, ncomp = 1:input$Components, asp = 1, line = TRUE, xlab = input$noise)
  })
  
  output$scores<-renderPlot({
    data1<-the_data()
    gas<-plsr(octane ~ NIR, ncomp = 10,data = datab, method = input$Method, validation = input$valid)
    plot(gas, plottype = "scores", comps = 1:input$Components,line = TRUE,xlab = input$noise)
  })
  
  output$loadings<-renderPlot({
    data1<-the_data()
    gas<-plsr(octane ~ NIR, ncomp = 10 ,data = datab, method = input$Method, xlab = input$noise )
    plot(gas, "loadings", comps = 1:input$Components, legendpos= "topleft",
    labels = "numbers", xlab = "nm")
    abline(h = 0)
  })
  
})





