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
  select(state, no_employees, Age, Timestamp, treatment)%>%
  filter(Age <= 100)%>%
  group_by(state)%>%
  group_by(no_employees)
data_2 <- na.omit(data_2)

df <- 
  data %>%
  group_by(Country) %>%
  filter(family_history == "No") %>%
  filter(Country == "United States") %>% 
  subset(select = c(Timestamp, Age, Gender, Country, state, family_history, no_employees, mental_vs_physical))

mostCommon <-
  df %>%
  count(state, sort = TRUE)

keepState <- as.vector(unlist(mostCommon$state))[1:10]

df <- df[df$state %in% keepState, ]

server <- function(input, output) {
#Page 2
  
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
      labs(x = "number of employees", y = "count of surveyors") + 
      geom_bar()
  })
  
# Page 3
  
  new_data_treatment <- reactive({
    data_2 %>%
      filter(treatment == input$treatment, na.rm = TRUE)
  })
  
  new_data_size <- reactive({
    new_data_treatment() %>% 
      filter(no_employees == input$size, na.rm = TRUE)
  }) 
  
  
  output$line <- renderPlot({
    ggplot(new_data_size(), aes(y = Age, x= state,color = state)) +
      labs(x = "States", y = "Age") + 
      geom_boxplot()
  })
  
# Page 4
  
  new_data_check <- reactive({
    df %>%
      filter(state == input$stateChoice, na.rm = TRUE)
    
  })
  new_data_employee <- reactive({
    new_data_check() %>% 
      filter(no_employees == input$employees, na.rm = TRUE)
  })
  
  output$bar <- renderPlot({
    ggplot(new_data_employee(), aes(x = no_employees)) +
      geom_bar(aes(fill = state)) + facet_grid(. ~ state) + 
      theme(axis.text.x=element_text(angle=90, hjust=1)) + labs(title="Mental health Issues count per company size", y="Mental Health Issues count", x="Number of Employees in Company")
  })
  
}
