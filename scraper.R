library(rvest)
library(httr)

dates <- httr::GET(
  "https://www.lme.com/en-GB/Metals/Non-ferrous/Aluminium#tabIndex=0"
) %>% read_html() %>% html_nodes(xpath = '//*[@id="b5360d82-f8ed-4519-941a-87cefd4d5a58-tab-0"]/div/div[1]/div/div') %>% html_text()

dates <- httr::GET(
  "https://www.lme.com/en-GB/Metals/Non-ferrous/Aluminium#tabIndex=0"
) %>% read_html() %>% html_nodes(xpath = '//*[@id="b5360d82-f8ed-4519-941a-87cefd4d5a58-tab-0"]/div/div[1]/div/div') %>% html_text()

table <-
  httr::GET(
    "https://www.lme.com/en-GB/Metals/Non-ferrous/Aluminium#tabIndex=0"
  ) %>% read_html() %>%
  html_nodes(xpath='/html/body/div/div[2]/div[2]/div[2]/div[1]/div[2]/section[1]/div/div[2]/div/div[2]/table/tbody/tr[2]/td[2]') %>% html_text()

dates
table
