#library call

library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(tidyr)
library(DT)

df1 <- read.csv("df1.csv")  # Assuming the file is named 'my_data.csv'



ui <- dashboardPage(
  dashboardHeader(title = "World Values Survey Data Analysis"),
  dashboardSidebar(
    selectInput("countryInput", "Choose a Country:", choices = unique(df1$country)),
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("info")),
      menuItem(
        "Attitudes to Democracy",
        tabName = "democracy",
        icon = icon("university")
      ),
      menuItem(
        "News Consumption",
        tabName = "news",
        icon = icon("newspaper")
      ),
      menuItem(
        "Attitudes to Science",
        tabName = "science",
        icon = icon("flask")
      ),
      menuItem(
        "Variable Definitions",
        icon = icon("book"),
        tabName = NULL,
        tags$a(
          href = "https://www.worldvaluessurvey.org/WVSDocumentationWV6.jsp",
          target = "_blank",
          "Link to Variable Definitions"
        )
      )
    )
  ),
  dashboardBody(tabItems(
    tabItem(
      tabName = "overview",
      h2("Overview of the Application"),
      p(
        "This application allows users to explore various aspects of the World Values Survey data. Select a country from the sidebar to see specific analyses."
      ),
      p(
        "Navigate through the tabs to explore different dimensions: Attitudes to Democracy, News Consumption, and Attitudes to Science."
      ),
      p("For questions or concerns please contact Chris Rice at crice127@umd.edu")
    ),
    tabItem(
      tabName = "democracy",
      h2("Exploring Attitudes to Democracy"),
      plotOutput("plotDemocracy"),
      DTOutput("tableDemocracy"),
      DTOutput("tableDemocracyGlobal")
    ),
    tabItem(
      tabName = "news",
      h2("Exploring News Consumption"),
      plotOutput("plotNews"),
      DTOutput("tableNews"),
      DTOutput("tableNewsGlobal")
    ),
    tabItem(
      tabName = "science",
      h2("Exploring Attitudes to Science"),
      plotOutput("plotScience"),
      DTOutput("tableScience"),
      DTOutput("tableScienceGlobal")
    )
  ))
)


# Define Server Logic
server <- function(input, output) {
  # Reactive data subset based on selected country
  country_data <- reactive({
    df1 %>% filter(country == input$countryInput)
  })
  
  
  calculate_democracy_proportions <- function(data, questions) {
    data %>%
      pivot_longer(
        cols = all_of(questions),
        names_to = "Question",
        values_to = "Response"
      ) %>%
      filter(Response %in% 1:4) %>%
      group_by(Question, Response) %>%
      summarise(Count = n(), .groups = 'drop') %>%
      group_by(Question) %>%
      mutate(Total = sum(Count)) %>%
      ungroup() %>%
      mutate(Proportion = Count / Total) %>%
      select(-Total, -Count)
  }
  
  
  
  output$plotDemocracy <- renderPlot({
    local_data <-
      calculate_democracy_proportions(country_data(), paste0("V228", LETTERS[1:8]))
    if (nrow(local_data) == 0) {
      return(ggplot() + labs(title = "No data available", x = "Question", y = "Proportion"))
    }
    
    ggplot(local_data, aes(
      x = Question,
      y = Proportion,
      fill = factor(Response)
    )) +
      geom_bar(stat = "identity", position = "dodge") +
      theme_minimal() +
      labs(title = "Proportions of Responses for Democracy Questions",
           x = "Question", y = "Proportion") +
      scale_fill_brewer(
        palette = "Set1",
        name = "Response Category",
        labels = c("Very Often", "Fairly Often", "Not Often", "Not at all Often")
      )
  })
  
  
  output$tableDemocracy <- renderDT({
    local_data <-
      calculate_democracy_proportions(country_data(), paste0("V228", LETTERS[1:8]))
    
    wide_data <- local_data %>%
      pivot_wider(
        names_from = Response,
        values_from = Proportion,
        names_prefix = "Resp_",
        values_fill = list(Proportion = 0)
      ) %>%
      rename_with(~ c("Very Often", "Fairly Often", "Not Often", "Not at all Often"),
                  .cols = starts_with("Resp_"))
    
    datatable(wide_data, options = list(pageLength = 10, scrollX = TRUE))
  })
  
  
  calculate_news_proportions <- function(data, questions) {
    data %>%
      pivot_longer(
        cols = all_of(questions),
        names_to = "Question",
        values_to = "Response"
      ) %>%
      filter(Response %in% 1:5) %>%  # Ensure only valid responses
      group_by(Question, Response) %>%
      summarise(Count = n(), .groups = 'drop') %>%
      group_by(Question) %>%
      mutate(Total = sum(Count)) %>%
      ungroup() %>%
      mutate(Proportion = Count / Total) %>%
      select(-Total,-Count)
  }
  
  output$plotNews <- renderPlot({
    local_data <-
      calculate_news_proportions(country_data(), paste0("V", 217:224))
    if (nrow(local_data) == 0) {
      return(ggplot() + labs(title = "No data available", x = "Question", y = "Proportion"))
    }
    
    ggplot(local_data, aes(
      x = Question,
      y = Proportion,
      fill = factor(Response)
    )) +
      geom_bar(stat = "identity", position = "dodge") +
      theme_minimal() +
      labs(title = "Proportions of News Consumption Responses", x = "Question", y = "Proportion") +
      scale_fill_brewer(
        palette = "Set1",
        name = "Response Category",
        labels = c("Daily", "Weekly", "Monthly", "Less than Monthly", "Never")
      )
  })
  
  
  output$tableNews <- renderDT({
    local_data <-
      calculate_news_proportions(country_data(), paste0("V", 217:224))
    
    # Pivot data to a wider format
    wide_data <- local_data %>%
      pivot_wider(
        names_from = Response,
        values_from = Proportion,
        names_prefix = "Resp_",
        values_fill = list(Proportion = 0)
      ) %>%
      rename_with( ~ c("Daily", "Weekly", "Monthly", "Less than Monthly", "Never"),
                   .cols = starts_with("Resp_"))
    
    datatable(wide_data, options = list(pageLength = 10, scrollX = TRUE))
  })
  
  calculate_science_proportions <- function(data) {
    data %>%
      pivot_longer(cols = V192:V197,
                   names_to = "Question",
                   values_to = "Response") %>%
      filter((Response == 1 | Response == 10) & Question != "V197" |
               (Response %in% c(1, 10) & Question == "V197")
      ) %>%
      group_by(Question, Response) %>%
      summarise(Count = n(), .groups = 'drop') %>%
      mutate(Total = sum(Count), Proportion = Count / Total) %>%
      select(-Total, -Count)
  }
  
  
  
  output$plotScience <- renderPlot({
    local_data <- calculate_science_proportions(country_data())
    if (nrow(local_data) == 0) {
      return(ggplot() + labs(title = "No data available", x = "Question", y = "Proportion"))
    }
    
    ggplot(local_data, aes(
      x = Question,
      y = Proportion,
      fill = factor(Response)
    )) +
      geom_bar(stat = "identity", position = "dodge") +
      theme_minimal() +
      labs(title = "Proportions of Extreme Responses for Science Questions",
           x = "Question", y = "Proportion") +
      scale_fill_brewer(
        palette = "Set1",
        name = "Response Category",
        labels = c("1 - Extreme Opinion A", "10 - Extreme Opinion B")
      )
  })
  
  output$tableScience <- renderDT({
    local_data <- calculate_science_proportions(country_data())
    
    wide_data <- local_data %>%
      pivot_wider(
        names_from = Response,
        values_from = Proportion,
        names_prefix = "Resp_",
        values_fill = list(Proportion = 0)
      )
    
    datatable(wide_data, options = list(pageLength = 10, scrollX = TRUE))
  })
  ###################################  End Shiny by Country
  
  #################  Begin Shiny Global tables
  calculate_global_proportions <- function(data, questions) {
    data %>%
      pivot_longer(
        cols = all_of(questions),
        names_to = "Question",
        values_to = "Response"
      ) %>%
      # Assuming valid responses for Democracy are 1 to 4
      filter(Response %in% 1:4) %>%
      group_by(Question, Response) %>%
      summarise(Count = n(), .groups = 'drop') %>%
      mutate(Total = sum(Count), Proportion = Count / Total) %>%
      select(-Total,-Count)
  }
  
  output$tableDemocracyGlobal <- renderDT({
    global_data <-
      calculate_global_proportions(df1, paste0("V228", LETTERS[1:8]))
    wide_data <- global_data %>%
      pivot_wider(
        names_from = Response,
        values_from = Proportion,
        names_prefix = "Global_Resp_",
        values_fill = list(Proportion = 0)
      )
    
    datatable(wide_data, options = list(pageLength = 10, scrollX = TRUE))
  })
  
  calculate_global_proportions_news <- function(data) {
    data %>%
      pivot_longer(cols = V217:V224,
                   names_to = "Question",
                   values_to = "Response") %>%
      filter(Response %in% 1:5) %>%
      group_by(Question, Response) %>%
      summarise(Count = n(), .groups = 'drop') %>%
      mutate(Total = sum(Count), Proportion = Count / Total) %>%
      select(-Total,-Count)
  }
  output$tableNewsGlobal <- renderDT({
    global_data <- calculate_global_proportions_news(df1)
    wide_data <- global_data %>%
      pivot_wider(
        names_from = Response,
        values_from = Proportion,
        names_prefix = "Global_Resp_",
        values_fill = list(Proportion = 0)
      )
    
    datatable(wide_data, options = list(pageLength = 10, scrollX = TRUE))
  })
  
  calculate_global_proportions_science <- function(data) {
    data %>%
      pivot_longer(cols = V192:V197,
                   names_to = "Question",
                   values_to = "Response") %>%
      filter((Question != "V197" & Response %in% c(1, 10)) |
               (Question == "V197" & Response %in% c(1, 10))) %>%
      group_by(Question, Response) %>%
      summarise(Count = n(), .groups = 'drop') %>%
      mutate(Total = sum(Count), Proportion = Count / Total) %>%
      select(-Total, -Count)
  }
  
  output$tableScienceGlobal <- renderDT({
    global_data <- calculate_global_proportions_science(df1)
    wide_data <- global_data %>%
      pivot_wider(
        names_from = Response,
        values_from = Proportion,
        names_prefix = "Global_Resp_",
        values_fill = list(Proportion = 0)
      )
    
    datatable(wide_data, options = list(pageLength = 10, scrollX = TRUE))
  })
  
  
  
}

# Run the application
shinyApp(ui, server)


###########################################################################
