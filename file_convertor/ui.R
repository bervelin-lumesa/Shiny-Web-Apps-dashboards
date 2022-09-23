
########################################################
# By Bervelin Lumesa                                   #
# Date : 2022-05-13                                    #
#                                                      #
# Mail     : lumesabervelin@gmail.com                  #
# Github   : https://github.com/bervelin-lumesa        #
# Twitter  : https://twitter.com/bervelinL             #
# Linkedin : https://linkedin/in/bervelin-lumesa       #
########################################################

# add some informations about bugs in the "about.md" page
# excel to stata, spss does'nt work if the column names contains spaces -- add make_names function

library(shiny)
library(shinydashboard)
library(shinythemes)
library(DT)
library(readxl)
library(xlsx)
library(haven)
library(foreign)
library(markdown)
library(janitor)

# Define UI for application that draws a histogram---------
ui <- navbarPage("File Convertor v.1.2", theme = shinytheme("united"),
                 
                 tabPanel("Home",
                          tags$style(type = "text/css",
                                     ".shiny-output-error{visibility: hidden;}",
                                     ".shiny-output-error:before {visibility: hidden;}"),
                          fluidRow(
                            column(h1("Convert your file with Excel, CSV, SPSS and Stata formats", style = "font-size: 400%"), width = 8)
                          ),
                          tags$hr(),
                          column(wellPanel(
                            h3(tags$b("Input file")),
                            #radioButtons("formatin", label = "Select your file format", choices = c("CSV", "Excel", "Text", "SPSS", "Stata"), inline = T),

                            fileInput("file", label = "Choose the file to convert", accept = c(".csv", ".txt", ".xlsx", ".xls", ".sav", ".dta")),
                            uiOutput("sheet1"),
                            uiOutput("sep1"),
                            tags$hr(),
                            uiOutput("out1"),
                            uiOutput("out2"),
                            uiOutput("out3"),
                            #div(tags$img(src = "bervelin-logo.JPG", style = "width:200px; height:60px;"), style =  "text-align: center;")
                            ),width = 3),
                          
                          column(tabBox(
                            title = "",
                            # The id lets us use input$tabset1 on the server to find the current tab
                            id = "tabset1", height = "250px",
                            tabPanel("Info on input data", 
                                     h3("Some informations"),
                                     tags$hr(),
                                     h4(textOutput("filename")),
                                     h4(textOutput("rows")),
                                     h4(textOutput("cols"))),
                            tabPanel("Preview Data",
                                     dataTableOutput("table")
                                     )
                          ,width = 9)
                                 ,width = 9)),
                 
                 tabPanel("About",
                          includeMarkdown("about.Rmd"))
)

