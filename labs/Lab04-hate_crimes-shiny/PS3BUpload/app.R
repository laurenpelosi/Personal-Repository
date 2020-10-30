library(fivethirtyeight)
library(shinythemes)
library(tidyverse)

# get "division" info (New England, Pacific, South Atlantic, etc.) for each state 
#hate_crimes2 <- hate_crimes %>%
#left_join(fivethirtyeight::state_info, by = c("state", "state_abbrev"))

# define vectors for choice values and labels 
# can then refer to them in server as well (not just in defining widgets)
# for selectInput, needs to be named list
bball <- ncaa_w_bball_tourney %>%
    filter(conference %in% c("Atlantic Coast", "Pacific Coast", "Big Ten", "Big Eight", "Big 12", "Southeastern"))

x_choices <- as.list(names((bball)[(9:11)]))

x_choice_names <- c("regular season wins", "regular season losses", "reg season winning %")

names(x_choices) <- x_choice_names

# for radio button, can be separate (have choiceValues and choiceNames options, 
# rather than just choices)
y_choices = names(bball)[17:19]
y_choice_names <- c("total wins","total losses", "full season winning %")

#for checkboxGroupInput (only have "choices" option, but these labels are fine)

conference_choices <- (bball %>%
                           count(conference))$conference

# ui 
ui <- fluidPage(
    
    h1("Women's Basketball, 1982-2018"),
    
    sidebarLayout(
        sidebarPanel(
            
            selectInput(inputId = "x"
                        , label = "Choose a predictor variable of interest:"
                        , choices = x_choices
                        , selected = "reg_w"),
            radioButtons(inputId = "y"
                         , label = "Choose an outcome variable of interest:"
                         , choiceValues = y_choices
                         , choiceNames = y_choice_names
                         , selected = "full_w"),
            checkboxGroupInput(inputId = "conference"
                               , label = "Choose conference:"
                               , choices = conference_choices
                               , selected = "Atlantic Coast"
                               , inline = TRUE),
        ),
        
        mainPanel(
            
            tabsetPanel(type = "tabs"
                        , tabPanel("Histogram of the outcome"
                                   , plotOutput(outputId = "hist"))
                        , tabPanel("Scatterplot", plotOutput(outputId = "scatter"))
                        , tabPanel("Table", tableOutput(outputId = "table"))
            )
        )
    )
)

# server
server <- function(input,output){
    
    use_data <- reactive({
        data <- filter(bball, conference %in% input$conference)
    })
    
    output$hist <- renderPlot({
        ggplot(data=use_data(), aes_string(x = input$y)) +
            geom_histogram(color = "#00215c", fill = "#00215c", alpha = 0.7) +
            labs(x = y_choice_names[y_choices == input$y],
                 y = "Number of Teams")
    })
    
    output$scatter <- renderPlot({
        ggplot(data=use_data(), aes_string(x = input$x, y = input$y)) +
            geom_point() +
            labs(x = names(x_choices)[x_choices == input$x]
                 , y = y_choice_names[y_choices == input$y])
    })
    
    output$table <- renderTable({
        dplyr::select(bball, conference, input$x, input$y)
    })
}

#call to shinyApp
shinyApp(ui = ui, server = server)


# Your turn.  Copy this code as a template into a new app.R file (WITHIN A FOLDER
# named something different than your other Shiny app folders).  Then, either 
# (1) update this template to still explore the hate_crimes dataset, but with
#     different app functionality (e.g. different widgets, variables, layout, theme...); 
#   OR
# (2) use this as a template to create a Shiny app for a different dataset:
#      either mad_men (tv performers and their post-show career), 
#             bball (women's NCAA div 1 basketball tournament, 1982-2018), 
#             nfl_suspensions (NFL suspensions, 1946-2014), 
#             or candy_rankings (candy characteristics and popularity)
#      these four datasets are also part of the fivethirtyeight package
#      and their variable definitions are included in pdfs posted to the Moodle course page

