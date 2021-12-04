library(shiny)
library(ggplot2)
library(dplyr)

data <- read.csv('~/Desktop/info201/final project/Data/survey.csv')

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
        choices = list("Male" = "Male", "Female" = "Female"),
        selected = "Male"),
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
