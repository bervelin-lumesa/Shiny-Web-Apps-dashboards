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
library(tools)

options(shiny.maxRequestSize = 20*1024^2)


server <- function(input, output) {
  

  data <- reactive({
    
    infile <- input$file
    req(infile)
    ext <- file_ext(infile$name)
    switch (ext,
      csv  = read.csv(infile$datapath, sep = input$sep),
      xlsx = read_excel(infile$datapath, input$sheet) %>% clean_names(),
      xls  = read_excel(infile$datapath, input$sheet) %>% clean_names(),
      txt  = read.table(infile$datapath, sep = input$sep, header = T),
      sav  = read.spss(infile$datapath, to.data.frame = T),
      dta  = read_dta(infile$datapath),
      validate("This is not a validate data format !"))
    
  })
  
  output$sheet1 <- renderUI({
    infile <- input$file
    req(infile)
    ext <- file_ext(infile$name)
    if(ext %in% c("xlsx", "xls")){numericInput("sheet", label = "Select the position of the sheet (ex:1,2..)", value = 1, min = 1, max = 20)}
  })
  
  output$sep1 <- renderUI({
    infile <- input$file
    req(infile)
    ext <- file_ext(infile$name)
    if(ext %in% c("txt", "csv")){radioButtons("sep", label = "Select the separator", choices = c("Semi-Colon" = ";", "Comma" = ",", "Tab" = "\t", "Space" = " "), inline = T)}
  })
  
  output$filename <- renderText({
    infile <- input$file
    paste("File name : ", ifelse(is.null(infile), "NA", infile[1]))
    
  })
  
  output$rows <- renderText({
    infile <- input$file
    paste("# Rows : ", ifelse(is.null(infile), "NA", dim(data())[1]))
    
  })
  
  output$cols <- renderText({
    infile <- input$file
    paste("# Cols : ", ifelse(is.null(infile), "NA", dim(data())[2]))
    
  })
  
  output$table <- renderDataTable({
    datatable(data(), rownames = F, options = list(
      #dom = "Bfrtip",
      scrollY = 400, 
      scrollX = 400
    ))
  })
  
  
  output$out1 <- renderUI({
    if(is.null(input$file))
      return(NULL)
    h3(tags$b("Output file"))
  })
  
  output$out2 <- renderUI({
    if(is.null(input$file))
      return(NULL)
    radioButtons("formatout", label = "Select your output file format", choices = c("CSV" = "csv", "Excel" = "xlsx", "Text" = "txt",  "SPSS" = "sav", "Stata" = "dta"), inline = T)
  })
  
  output$out3 <- renderUI({
    if(is.null(input$file))
      return(NULL)
    downloadButton("downloadData", "Convert now")
  })
  
  
  output$downloadData <- downloadHandler(

    filename = function() {
     paste(input$file[1], input$formatout, sep = ".")
    },
    
    content = function(file) {
      switch (input$formatout,
        csv  = write.csv(data(), file, row.names = F),
        xls  = write.xlsx(data(), file, row.names = F),
        xlsx = write.xlsx(data(), file, row.names = F),
        txt  = write.table(data(), file, row.names = F),
        sav  = write_sav(data(), file),
        dta  = write_dta(data(), file)
      )

    }
  )
  
  
  
}
