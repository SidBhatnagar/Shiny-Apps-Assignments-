#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(MASS)
library(ggplot2)
library(shinyBS)

shinyServer(function(input, output) {
  
  
  
  output$rPlot <- renderPlot({ boxplot( x= TPlot  , data = TPlot, main = "Boxplot" ,
                                        outline = input$outliers,col = topo.colors(10))
  })
  
  
  output$Checkone<-renderPlot({
    yaxis <-switch(input$var, 
                   "Specific gravity" =mydata2$gravity,
                   "Osmolarity" = mydata2$osmo,
                   "Conductivity" = mydata2$cond,
                   "Urea"=mydata2$urea,
                   "Calcium"=mydata2$calc)
    
    xaxis <-switch(input$vars, 
                   "Specific gravity" =mydata2$gravity,
                   "Osmolarity" = mydata2$osmo,
                   "Conductivity" = mydata2$cond,
                   "Urea"=mydata2$urea,
                   "Calcium"=mydata2$calc)
    
    ggplot( mydata2, mapping = aes(mydata2, x= xaxis, 
                                   y=yaxis, color = r,shape = r, title(main = Scatterplot))) +
      geom_point(position = position_jitter(1),size = 3 )  
    
    
  })
  
  output$checktwo<-renderPlot({
    corrplot(TPlot, method = "square", main = "Calcium oxalate crystals")
  })
  
  
  output$DataSummary <- renderPrint(width = getOption("width"),summary(mydata2))
  
  output$table <- renderTable(
    mydata2)
  
})