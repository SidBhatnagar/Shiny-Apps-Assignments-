library(shiny)

shinyUI(fluidPage(titlePanel("Assignment three Data Science in industry"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("outliers", "Show outliers", FALSE),
      sliderInput(
        "iqr",
        "Outlier IQR:",
        min = 0.5,
        max = 3.0,
        step = 0.25,
        value = 1.5
      ),
      sliderInput(
        "dist",
        "BoxplotRange:",
        min = 1,
        max = 61,
        value = 30
      ),
      sliderInput("range",
                  "Train/Test", 
                  min = .10,
                  max = 1,
                  value = .7),
      checkboxInput("missing", "MissingVals"),
      sliderInput("comps",
                  "Components", 
                  min = 1,
                  max = 31,
                  value = 5),
      sliderInput("compsx",
                  "Componentsx", 
                  min = 1,
                  max = 5,
                  value = 1),
      sliderInput("compsy",
                  "ComponentsY", 
                  min = 1,
                  max = 5,
                  value = 1),
    
    textAreaInput("Formula", label = "Formula", value = "Y ~ ."),
    textAreaInput("Ideal", label = "Ideal", value = "Ideal variable with pr<0.05 =  Y ~ Layer20 ")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Summary", 
                 h4(verbatimTextOutput("dim")), 
                 h4("Structure of Dataset"), 
                 verbatimTextOutput("structure"),
                 h4("Datastructure"),
                 plotOutput("vissdat"),
                 h4("Summary of Dataset"),
                 verbatimTextOutput("summary"),
                 h4("Head of Dataset"),
                 tableOutput("mytable")),
        tabPanel("Matplot",plotOutput("matplot")),
        tabPanel("Boxplot",
                 plotOutput("boxPlot"),
                 h4("Boxplot Statistics"),
                 verbatimTextOutput("boxplotstats"),
                 h4("Outliers by rows"),
                 verbatimTextOutput("boxplotrow")),
        tabPanel("Missingvalues",
                 h4("Datamissing"),plotOutput("vismiss"),
                 h4("Closerview"),plotOutput("ACC"),
                 h4("Missvalues"),tableOutput("keep")),
        tabPanel("Imputation",
                 h4("Imputeone"),verbatimTextOutput("imputed"),
                 h4("Imputesummary"),verbatimTextOutput("imputedsum"),
                 h4("Imputetwo"),tableOutput("imputee"),
                 h4("Imputethree"),verbatimTextOutput("imputee1"))
        ,
        tabPanel("DataSplit", tableOutput("Split")),
        tabPanel("PCASummaries",
                 h4("PCA summary"),verbatimTextOutput("pcasummary"),
                 h4("PCA structure"),verbatimTextOutput("pcastructure"),
                 h4("PCA names"), verbatimTextOutput("pcanames"),
                 h4("PCAoverallSummary"),verbatimTextOutput("sumpca")),
        tabPanel("PCAplots",
                 h4("Scree Plot"),plotOutput("screeplot"),
                 h4("Score Plot"),plotOutput("scoreplot"),
                 h4("Loading"),plotOutput("loading")),
        tabPanel("Linearmodel",
                 h4("Linear Model Summary"),verbatimTextOutput("lmsummary"),
                 h4("Linear Model"),plotOutput("ModelPlot"),
                 h4("Linear Model Plot"),plotOutput("lmplot")),
        tabPanel("Testing",
                h4("Testplot"),plotOutput("TestPlot"))
              
      )  
      
    )
  )
)
)

