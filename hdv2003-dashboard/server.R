
# load the libraries and data
source("libs_data.R")

#============================ Server  ===========================
server <- function(input, output){
    
    # scatterplot
    output$scatter <- renderPlotly({
        var_quali <- hdv2003[, input$var_quali]
        ggplot(data = hdv2003, aes_string(x = input$var_x, y = input$var_y, color = var_quali)) + 
            geom_point(size = 4) + 
            xlab(input$var_x) + 
            ylab(input$var_y) + 
            scale_color_brewer("Illustration", palette = "Set1") + 
            theme_classic() +
            theme(axis.title = element_text(size = 20),
                  axis.text = element_text(size = 10))
        
    })
    
    # barplot
    output$barplot <- renderPlotly({
        ggplot(data = hdv2003) + 
            geom_bar(aes_string(x = input$var_quali, fill = input$var_quali)) + 
            xlab(input$var_quali) + 
            ylab("Observations") + 
            theme_classic() + 
            theme(legend.position = "none",
                  axis.title = element_text(size = 15),
                  axis.text = element_text(size = 10)) + 
            coord_flip()
        
        
    })
    
    # boxplot
    output$boxplot <- renderPlotly({
        ggplot(data = hdv2003) + 
            geom_boxplot(aes_string(x = input$var_quali, y = input$var_x, fill = input$var_quali)) + 
            theme_classic() +
            theme(legend.position = "none",
                  axis.title = element_text(size = 20),
                  axis.text = element_text(size = 10),
                  axis.text.x = element_text(angle = 45))
        
    })
    
    # histogram
    output$histogram <- renderPlotly({
        ggplot(data = hdv2003) + 
            geom_histogram(aes_string(x = input$var_x), fill = "cornflowerblue") +
            theme_classic() +
            xlab(input$var_x) +
            ylab("Observations") +
            theme(axis.title = element_text(size = 20),
                  axis.text = element_text(size = 10),
                  axis.text.x = element_text(angle = 45))
    })
    
    # map
    output$map <- renderLeaflet({
        content <- paste(sep = "<br/>",
                         "<span style='font-size:15px'><b><a href=https://fr.wikipedia.org/wiki/Institut_sup%C3%A9rieur_de_statistiques_de_Kinshasa target='_blank' rel='noopener noreferrer'>ISS/KIN</a></b></span>",
                         "<span style='font-size:15px'>Where I studied Statistics</span>")
        
        leaflet() %>% 
            addTiles() %>%
            setView(lng = 15.322553, lat = -4.335567, zoom = 16) %>%
            addMarkers(lng = 15.322553,
                       lat = -4.335567, popup = content) %>%
            addPopups(lng = 15.322553, lat = -4.335567, content, popupOptions(closeButton = F))
    })
    
    # data
    output$df <- renderDataTable({
        hdv2003 %>% datatable(rownames = T, options = list(pageLength = 5))
        
    })
    
    # Inputs for the table [1]
    output$inputs_quanti <- renderUI({
        selectInput(inputId = "stat_varx", label = "Select a numeric variable", choices = quanti)
        
    })
    
    # Inputs for the table [2]
    output$inputs_quali <- renderUI({
        selectInput(inputId = "stat_group", label = "Select a categorical variable to group", choices = quali)
    })
    
    # Inputs for the table [3]
    output$stat_selection <- renderUI({
        checkboxGroupInput(inputId = "stat_selected", label = "Select statistics", choices = c("N", "mean", "min", "max", "q25", "q75"), selected = "N", inline = T)
    
    })
    
    # table with statistics
    output$stat <- renderDataTable({
        stat_varx <- hdv2003[, input$stat_varx]
        tab <- hdv2003 %>%
            group_by(hdv2003[, input$stat_group]) %>%
            summarise(N    = n(),
                      mean = round(mean(stat_varx, na.rm = T), 1),
                      min  = round(min(stat_varx, na.rm = T) ,1),
                      max  = round(max(stat_varx, na.rm = T), 1),
                      q25  = round(quantile(stat_varx, p = 0.25, na.rm = T), 1),
                      q75  = round(quantile(stat_varx, p = 0.75, na.rm = T), 1))
        names(tab)[1] <- input$stat_group
        
        # checking if the statistic (N, Mean, Min, Max, Q25, Q75) is checked
        N    <- ifelse(str_detect(input$stat_selected, "N"), "N", NA)
        Mean <- ifelse(str_detect(input$stat_selected, "mean"), "mean", NA)
        Min  <- ifelse(str_detect(input$stat_selected, "min"), "min", NA)
        Max  <- ifelse(str_detect(input$stat_selected, "max"), "max", NA)
        Q25  <- ifelse(str_detect(input$stat_selected, "q25"), "q25", NA)
        Q75  <- ifelse(str_detect(input$stat_selected, "q75"), "q75", NA)
        
        selection <- c(names(tab)[1], N, Mean, Min, Max, Q25, Q75)
        selection <-  selection[!is.na(selection)]
        
        datatable(tab[, selection], rownames = F)
        
    })
    

   # count the number of visits
    output$counter <- renderText({
        if(!file.exists("counter.Rdata"))
            counter <- 0
        else
            load("counter.Rdata")
        counter <- counter + 1
        save(counter, file = "counter.Rdata")
        paste("Number of visits: ", counter)
        
    })
    
}