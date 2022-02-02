
# load the libraries and data
source("libs_data.R")

#============================ Header  ===========================

header <- dashboardHeader(
    title =  "Data visualization with Shiny | hdv2003",
    titleWidth = "400px",
    dropdownMenu(
        type = "messages",
        messageItem(
            from = "Bervelin Lumesa",
            message = "Visit my website !",
            href = "https://bervelin-lumesa.netlify.app"
        )
    ),
    dropdownMenu(
        type = "tasks",
        badgeStatus = "success",
        taskItem(value = 100, color = "green", "Deployment"))
    
)

#============================ Sidebar  ===========================

sidebar <- dashboardSidebar(
    width = "350px",
    sidebarSearchForm(textId = "dff", buttonId = "ddd", label = "Search", icon = shiny::icon("search")),
    sidebarMenu(id = "tab1", 
        menuItem("Dashboard", icon = icon("dashboard"),
                 menuSubItem("Visualizations", icon = shiny::icon("bar-chart"),
                             tabName = "viz_1"),
                 menuSubItem("Tables", icon = icon("table"),
                             tabName = "viz_2")),
        menuItem("Maps", icon = icon("map"),
                 tabName = "map"),
        menuItem("Data", icon = icon("table"),
                 tabName = "data")
    ),
    
selectInput(inputId = "var_x", label = "Select the first quanti variable", choices = quanti),
selectInput(inputId = "var_y", label = "Select the second quanti variable", choices = quanti, selected = quanti[2]),
selectInput(inputId = "var_quali", label = "Select a quali variable", choices = quali),

h4(textOutput("counter")),
tags$hr(),
tags$a(href = "https://bervelin-lumesa.netlify.app", target="_blank", rel="noopener noreferrer", " By Bervelin Lumesa")
)

#============================ Body /Outputs ===========================

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "viz_1", 
                infoBox(title = "Sumple size", value = nrow(hdv2003), icon = icon("table"), width = 6, fill = T),
                infoBox(title = "Mean age", value = round(mean(hdv2003$age),1), icon = icon("user"), width = 6, fill = T),
                
                box(title = "Scatterplot", plotlyOutput("scatter")),
                box(title = "Barplot", plotlyOutput("barplot")),
                box(title = "Boxplot", plotlyOutput("boxplot")),
                box(title = "Histogram", plotlyOutput("histogram"))),
        
        tabItem(tabName = "viz_2",
                box(title = tags$b("Inputs for the table"), uiOutput("inputs_quanti"), uiOutput("inputs_quali"), uiOutput("stat_selection"), width = 4),
                box(title = tags$b("Descriptive table"),  dataTableOutput("stat"), width = 8)),
        
        tabItem(tabName = "map",
                box(title = "Map", leafletOutput("map"), width = 12)),
        
        tabItem(tabName = "data",
                dataTableOutput("df"),
                h2("About"),
                h4("Data in this dashboard are from the questionr package (hdv2003). 
               hdv2003 is a sample from 2000 people and 20 variables taken from the Histoire de Vie survey, 
               produced in France in 2003 by INSEE. In this example, we just use the first 300 rows. 
               This dashboard is not for analytical purpose, but just to show what can be done with", 
                   a(href ="https://shiny.rstudio.com/", "shiny"), "and", 
                   a(href = "http://rstudio.github.io/shinydashboard/", "shinydashboard"), "packages"))
    )
)

#============================ Ui ===========================

ui <- dashboardPage(header, 
                    sidebar,
                    body)


