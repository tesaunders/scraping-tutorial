# Load packages

library(rvest)
library(stringr)
library(dplyr)

# Define page to read in as html

html_imdb <- read_html("https://www.imdb.com/chart/tvmeter/")

# Use CSS selectors to select title, type, and 'metadata' 

top_title <- 
  html_imdb |> 
  html_elements(".ipc-metadata-list-summary-item .ipc-title") |> 
  html_text()

top_type <- 
  html_imdb |> 
  html_elements(".cli-title-type-data") |> 
  html_text()

top_metadata <- 
  html_imdb |> 
  html_elements(".cli-title-metadata-item") |> 
  html_text()

# Use regular expressions to extract year and episodes from metadata

top_year <- 
  top_metadata |> 
  str_subset("\\d{4}-?")

top_episodes <- 
  top_metadata |> 
  str_subset("eps") |> 
  str_extract("[0-9]+")

# Assemble a dataframe

top_tv <- 
  data.frame(
    title = top_title,
    date = Sys.Date(),
    type = top_type,
    year = top_year,
    episodes = top_episodes) |> 
  mutate(
    position = row_number(),
  ) |> 
  relocate(position, .after = title)

# Save a .csv file where the filename is appended with the date

write.csv(top_tv, paste0("data/top_tv-", Sys.Date(), ".csv"))
