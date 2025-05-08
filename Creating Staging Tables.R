# Load libraries 
if (!require(pacman)) install.packages("pacman")
pacman::p_load(readxl, writexl, tidyverse, DBI, dplyr, httr, jsonlite, odbc, 
               DataCombine, lubridate, tidyr, purrr, openxlsx, stringr, janitor,
               glue)


##### Import the data #####

file_input_actuals <- "Staging_Tables.xlsx"

data_RTT <- read_excel(path='Staging_tables.xlsx',
                         sheet = 'RTT')

data_DIAG <- read_excel (path='Staging_tables.xlsx',
                         sheet = 'Diag')

# Uses the personal credentials to upload the data
source('personal_credentials.R')

# Connect to the server
message("Sort the pop up")

# Create the connection to UDAL environment
con_udal <-
  DBI::dbConnect(
    drv = odbc::odbc(),
    driver = "ODBC Driver 17 for SQL Server",
    server = serv,
    database = db,
    UID = user,
    authentication = "ActiveDirectoryInteractive"
  )

message("!!!! Message 2 of 2: Connection successful")

##### Upload the data to the datamart #####
dbWriteTable(
  
  con_udal,  
  
  DBI::Id(schema = 'SWPat',
          
          table = 'TABLE.STAGING.WLMDS_OPEN_PATHWAYS_TFC_LW'), 
  
  data_RTT, 
  
  overwrite = TRUE) 

dbWriteTable(
  
  con_udal,  
  
  DBI::Id(schema = 'SWPat',
          
          table = 'TABLE.STAGING.WLMDS_DIAG'), 
  
  data_DIAG, 
  
  overwrite = TRUE) 

print ('donsies:D')