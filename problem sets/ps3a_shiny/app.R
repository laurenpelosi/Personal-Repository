#- copy the code from the `02-two-outputs.R` file (in the `two-outputs` code chunk below)
#-add a `textInput` widget that allows the user to change the title of the histogram (following code in `01-two-inputs.R`).  Update the #code in the server() function appropriately.  Run the app to make sure it works as you expect.
#- update the layout of the app to use a `navlistPanel` structure (following the code in `06-navlist.R`).  Hint: put `navlistPanel` around the output objects only.

#Make sure the app runs sucessfully, then save your changes in the app.R file, and push app.R to your GitHub repo.  You do not need to write anything here.  I will check your app in your GitHub repo.  If you get stuck, email me or the TA!


library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "num", 
              label = "Choose a number", 
              value = 25, min = 1, max = 100),
  textInput(inputId = "title", 
            label = "Write a title",
            value = "Histogram of Random Normal Values"),
  navlistPanel(              
    tabPanel(title = "Normal data",
             plotOutput("norm"),
             verbatimTextOutput("stats"),
             actionButton("renorm", "Resample")
    ),
    tabPanel(title = "Uniform data",
             plotOutput("unif"),
             verbatimTextOutput("stats"),
             actionButton("reunif", "Resample")
    ),
    tabPanel(title = "Chi Squared data",
             verbatimTextOutput("stats"),
             plotOutput("chisq"),
             actionButton("rechisq", "Resample")
    )
  )
) 

server <- function(input, output) {
  #output$hist <- renderPlot({
    #hist(rnorm(input$num), main = input$title)
  #})
  #output$stats <- renderPrint({
    #summary(rnorm(input$num))
  #})
  
  rv <- reactiveValues(
    norm = rnorm(500), 
    unif = runif(500),
    chisq = rchisq(500, 2))
  
  observeEvent(input$renorm, { rv$norm <- rnorm(500) })
  observeEvent(input$reunif, { rv$unif <- runif(500) })
  observeEvent(input$rechisq, { rv$chisq <- rchisq(500, 2) })
  
  output$norm <- renderPlot({
    hist(rv$norm, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard normal distribution")
  })
  output$unif <- renderPlot({
    hist(rv$unif, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a standard uniform distribution")
  })
  output$chisq <- renderPlot({
    hist(rv$chisq, breaks = 30, col = "grey", border = "white",
         main = "500 random draws from a Chi Square distribution with two degree of freedom")
  })
  output$stats <- renderPrint({
    summary(rnorm(input$num))
  })
}

shinyApp(ui = ui, server = server)

