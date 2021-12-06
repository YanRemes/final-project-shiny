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

page_one <- tabPanel(
  "Introduction",
  mainPanel(
    ui <- fluidPage(
      h1("Introduction"),
      p("....")
    )
  )
)

page_two <- tabPanel(
  "number of employees by country and gender",
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "country",
        label = "Select a country: ",
        choices = data$Country,
        selected = "United States"),
      
      radioButtons(
        inputId = "radio",
        label = "Pick a gender",
        choices = list("MALE" = "MALE", "FEMALE" = "FEMALE"),
        selected = "MALE"),
    ),
    mainPanel(
      ui <- fluidPage(
        h1("number of employees"),
        plotOutput("box"), 
      )
    )
  )
)


ui <- navbarPage(
  "survey Data Exploration",
  page_one,
  page_two
)
