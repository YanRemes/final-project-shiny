library(shiny)
library(ggplot2)
library(dplyr)

data <- read.csv('~/Desktop/info201/final project/Data/survey.csv')

server <- function(input, output) {
  
  new_data_gender <- reactive({
    data %>%
      filter(Gender == input$radio)
  })
  
  new_data_country <- reactive({
    new_data_gender() %>% 
    filter(Country == input$country)
  })
  
  output$box <- renderPlot({
    ggplot(new_data_country(), aes(x = no_employees)) +
      labs(x = "number of employees", y = "count of employees") + 
      geom_bar()
  })
}