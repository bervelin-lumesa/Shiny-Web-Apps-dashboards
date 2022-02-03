

#============================ Libraries ===========================

library(shiny)
library(shinydashboard)
library(tidyverse)
library(questionr)
library(plotly)
library(leaflet)
library(DT)

#============================ Data ===========================

data("hdv2003")
hdv2003 <- hdv2003[1:300, ]

# names of qualitative variables
quali <- hdv2003 %>% 
  select_if(is.factor) %>%
  names()

# names of quantitative variables
quanti <- hdv2003 %>% 
  select(-1) %>%
  select_if(is.numeric) %>%
  names()




