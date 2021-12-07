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

data_2 <- data %>%
  filter(Age <= 100)%>%
  group_by(state)%>%
  group_by(no_employees)

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

page_three <- tabPanel(
  "Age Distribution",
  
  sidebarLayout(
    sidebarPanel(
      
      radioButtons(
        inputId = "treatment",
        label = "Did the surveyor receive treatment or not: ",
        choices = list("Yes" = "Yes", "No" = "No"),
        selected = "Yes"
      ),
      
      
      selectInput(
        inputId = "size",
        label = "Select the size of the company: ",
        choices = data_2$no_employees,
        selected = "1-5"),
    ),
    
    mainPanel(  
      ui <- fluidPage(
        
        h1("Age distribution of mental health in work place"),
        plotOutput("line"),
        
      )   
    )
  )
)

page_four <- tabPanel(
  "Consequences of Mental Health",
  
  sidebarLayout(
    sidebarPanel(
      
      
      checkboxGroupInput(
        inputId = "stateChoice", 
        label = h3("States"), 
        choices = list("CA" = "CA", "IN" = "IN", "MA" = "MA", "NY" = "NY", "OH" = "OH", "OR" = "OR", "TN" = "TN", "TX" = "TX", "WA" = "WA"),
        selected = "WA"
      ),
      selectInput(
        inputId = "employees",
        label = "Select the size of the company: ",
        choices = df$no_employees,
        selected = "1-5"),
    ),
    
    mainPanel(  
      ui <- fluidPage(
        
        h1("Mental Health and Company Size"),
        plotOutput("bar")
        
      )   
    )
  )
)

ui <- navbarPage(
  "Mental health Survey Data Exploration",
  page_one,
  page_two,
  page_three,
  page_four
)
