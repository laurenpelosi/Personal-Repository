#Scraping from alarms.org and powertodecide.org

library(tidyverse) 
library(rvest)
library(robotstxt)

#url <- "https://www.alarms.org/std-statistics/"
#paths_allowed(url)

tables <- url %>% 
  read_html() %>% 
  html_nodes("table")

alarms <- tables %>%
  purrr::pluck(1) %>%
  html_table()

write.csv(alarms, "/Users/laurenpelosi/Desktop/git/Personal-Repository/STDs")

url2 <- "https://powertodecide.org/what-we-do/information/national-state-data/teen-birth-rate"
paths_allowed(url2)

tables <- url2 %>% 
  read_html() %>% 
  html_nodes("table")

power_to_decide <- tables %>%
  purrr::pluck(1) %>%
  html_table()

write.csv(power_to_decide, "/Users/laurenpelosi/Desktop/git/Personal-Repository/teen-birth")

View(alarms)
View(power_to_decide)
