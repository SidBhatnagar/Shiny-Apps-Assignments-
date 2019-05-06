library(shiny)
library(caret)
library(visdat)
library(mice)
library(DT)
library(outliers)
library(maptools)
library(lubridate)
library(tidyverse)

Dataset<- read.csv(file="D:/DataScienceinindustry/Assignment3/Ass3Data (1).csv", 
                   header=TRUE, sep=",",stringsAsFactors = T)
ymd(Dataset$Date)
df<-Dataset %>% 
column_to_rownames(var="ID")
dfr<-as.data.frame(df)
numeric <- sapply(dfr, is.numeric)
numData <- dfr[,numeric]
samp1 <- createDataPartition(y=dfr$Price, p = 0.7, list = F)
train1 <- dfr[samp1,]
test2 <-dfr[-samp1,]
num2<-sapply(train1,is.numeric)
num<-train1[,numeric]
num3<-sapply(test2,is.numeric)
num1<-test2[,numeric]

shinyServer(function(input, output) {
  
  output$dim <- renderPrint({
    datainformation <- paste("There are", nrow(dfr), "rows and", ncol(dfr), "columns for ass3.")
   print(datainformation)
  })
  output$mytable <- renderTable({
    head(get("dfr"),12)
    })
  output$structure <- renderPrint({
    str(dfr)
  })
  output$summary <- renderPrint({
   summary(dfr)
  })
  output$matplot<-renderPlot({
    matplot(y=dfr,
            type = 'l', lwd = 0.5, lty = 1, col = 1:5,
            xlab = 'Y', ylab = 'Pred',
            main = 'MatPlot of the dataset')
  
})
  output$vissdat<-renderPlot({
    b<-dfr %>%
      vis_dat()
    b
  })
  #Boxplot
  output$boxPlot <- renderPlot({
    boxplot(numData,las = 2,range = input$dist, outline = input$outliers,col = topo.colors(20),main = "Boxplot of the Dataset")
  })
  
  output$boxplotstats<-renderPrint({ 
    boxplot.stats(numData, coef = input$iqr, do.conf = T, do.out = T)
  })  
  
  output$boxplotrow<-renderPrint({
    rows <- outlierRows(numData, mult=2.1)
    numData[rows,]
    
  })  
  #missingvalues     
  output$vismiss<-renderPlot({
    a<-dfr %>%
      vis_miss(sort_miss = T,show_perc_col=T)
    a
  })
  
  output$ACC<-renderPlot({
    c<-VIM::aggr(dfr, col=c('Dark Grey','Blue'),
                   numbers=TRUE, sortVars=TRUE,
                   labels=names(Dataset), cex.axis=.7,
                   gap=3, ylab=c("Missing data","Pattern"))
      c
    })
    
    output$keep<-renderTable({
    na.omit(dfr,cols = seq_along(dfr),invert = input$missing)
    })
    
    impute<-reactive({
      mice::mice(dfr, m=1, maxit = 1, method='pmm', print=TRUE)
    })
    
    output$imputed<-renderPrint({
    str(impute())
    })  
    output$imputedsum<-renderPrint({
    summary(impute())
    })
    
    imp<-reactive({mice::mice(dfr, m=1, maxit = 1, method='pmm', print=TRUE)})
    
    output$imputee<-renderPrint({
    imputed1<- mice::complete(imp(),2) 
    })
    
    imputed3<-reactive({ mice::complete(imp(),1)})
    
    output$imputee1<-renderPrint({
    summary(imputed3())
    })
    
    
#Data Split    
Splitval<-reactive({
samp <- createDataPartition(y=Dataset$Agreed, p = input$range, list = F)
train <- Dataset[samp,]
test <-Dataset[-samp,]
})
output$Split<-renderTable({
Splitval()
  })

#PCAstructure
k<-reactive({prcomp(na.omit(dfr)[,c(1,14:43)],center = TRUE,scale. = TRUE)
})
output$pcasummary<-renderPrint({
  summary(k())
})
output$pcastructure<-renderPrint({
  str(k())
})
output$pcanames<-renderPrint({
  names(k())
})
output$sumpca<-renderPrint({
  k()
})

#PCAplots
output$screeplot<-renderPlot({
  screeplot(k(),npcs = input$comps,type = "line")
})

#pcascore<-reactive({k$x})
#PCAcolors<-reactive({ c("#66c2a5","#fc8d62","#8da0cb","green","red")[as.integer(input$class)]
#})
PCAvarAxis <- function(PCA, decimal=1) {
  pcavar <- round((PCA$sdev^2)/sum((PCA$sdev^2)),3)*100 
  PC1var <- paste("Principal Component 1 (", pcavar[1], "%)", sep="")
  PC2var <- paste("Principal Component 2 (", pcavar[2], "%)", sep="")
  PC3var <- paste("Principal Component 3 (", pcavar[3], "%)", sep="")
  PC4var <- paste("Principal Component 4 (", pcavar[4], "%)", sep="") 
  PC5var <- paste("Principal Component 5 (", pcavar[5], "%)", sep="")
  return(list(PC1=PC1var, PC2=PC2var, PC3=PC3var, PC4=PC4var, PC5=PC5var))
}   

output$scoreplot<-renderPlot({
  m<-prcomp(na.omit(dfr)[,c(14:43)],center = TRUE)
  pcascore<-m$x
  explainPCAvar <- PCAvarAxis(m)
  #PCAcolors <- c("#66c2a5","#fc8d62","#8da0cb","green","red","black")[as.integer(input$class)]
  plot(pcascore[,input$compsx:input$compsy],
       pch=21,
       xlab = "",
       ylab = "",# point shape
       #col=as.integer(input$class),    # point border color
       #bg=as.integer(input$class),     # point color
       cex=1.5          # point size
  )
  title(xlab=explainPCAvar[[input$compsx]],    
        ylab=explainPCAvar[[input$compsy]],    
        main="Scores"                 
)
})

output$loading<-renderPlot({
  m<-prcomp(na.omit(dfr)[,c(1,14:43)],center = TRUE)
  explainPCAvar <- PCAvarAxis(m)
  PCAloadings <- m$rotation
  text(PCAloadings[,input$compsx:input$compsy],            
  labels=rownames(PCAloadings)
  )
  
  t<-plot(PCAloadings[,input$compsx:input$compsy],   
       pch=21,            
       bg="black",          
       cex=1.0,            
        #type="n",           
       axes=FALSE,          
       xlab="",            
       ylab=""              
  )
  pointLabel(PCAloadings[,input$compsx:input$compsy],             
             labels=rownames(PCAloadings),  
             cex=0.75                          
  ) 
  axis(1,                
       cex.axis=1,      
       lwd=1.5            
  )
  axis(2,                 
       las=1,            
       cex.axis=1,      
       lwd=1.5            
  )
  box(lwd=1.5             
  )
  title(xlab=explainPCAvar[[input$compsx]],    
        ylab=explainPCAvar[[input$compsy]],    
        main="Loading",                 
        cex.lab=1.0,                    
        cex.main=1.3 
        
  )
})

getModel <- reactive({
a<-lm(formula = as.formula(input$Formula), data=num, x = TRUE)
})  

output$lmsummary <- renderPrint({
summary(getModel())
})

output$lmplot<-renderPlot({
 plot(getModel())
})

output$ModelPlot <- renderPlot({
  d <- num
  v <- getModel()
  pred = predict(v,d[,-1])
  plot(d[,1], pred, xlab = "Actual Risk", ylab="Predicted Risk")
  abline(0,1)
})
#Testplot
output$TestPlot<-renderPlot({
  Newdata <- dfr[c(2:12)]
  new<-as.data.frame(Newdata)
  NewData1<-dfr[c(14:43)]
  new1<-as.data.frame(NewData1)
#Datasplit 
  pcax.train<-new[1:nrow(train1),]#factor
  pcax.test<-new[-(1:nrow(train1)),]#factor
  pcay.train<-new1[1:nrow(train1),]#numeric
  pcay.test<-new1[-(1:nrow(train1)),]#numeric
  #
  Combitest<-cbind(pcax.test,pcay.test)#mixedtest
  Combitrain<-cbind(pcax.train,pcay.train)#mixedtrain
  #
  
  t<-prcomp(na.omit(train1)[,c(14:43)], center = TRUE)
  pcascore<-t$x[,1:5]
  joined <- rownames(train1) %in% rownames(pcascore)#joined
  Y <- train1$Y[joined]#no.2
  train.data<-data.frame(Y=Y,pcascore)
  train.data<-train.data[,1:5]
  pca.test1<-pcay.test
  mod2 <- lm(Y ~ ., train.data, x=TRUE)
  mod2
  test.data <- predict(t, newdata = pcay.test)
  test.data<-as.data.frame(test.data)
  test.data<-test.data[,1:5]
  
  LM<-predict(mod2,test.data)
  plot(LM,
  xlab = "Actual Risk", ylab="Predicted Risk")
  abline(0,1)
})
})