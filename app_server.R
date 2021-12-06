library(shiny)
library(ggplot2)
library(dplyr)

data <- read.csv('~/Desktop/info201/final project/Data/survey.csv')
data <- data %>% filter(grepl('2014', data$Timestamp))
data$Gender <- toupper(data$Gender)
data$Gender[grep("\\bM\\b",data$Gender)] <- 'MALE'
data$Gender[grep("\\bF\\b",data$Gender)] <- 'FEMALE'
data$Gender[grep("\\bWOMAN\\b",data$Gender)] <- 'FEMALE'
keepGender <- c("MALE", "FEMALE")
data <- data[data$Gender %in% keepGender, ]

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
