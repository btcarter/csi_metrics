# Get data and process it
library(dplyr)
library(readxl)
library(scholar)
library(httr)
library(jsonlite)

# load admin data
fl_nm <- file.path("C:",
                   "Users",
                   "CarteB",
                   "BILLINGS CLINIC",
                   "Collaborative Science & Innovation (CSI) - Documents",
                   "Ye Olde V Drive",
                   "ADMINISTRATIVE",
                   "CSI Research Projects.xlsx")

fl_nm_dissem <- file.path("C:",
                          "Users",
                          "CarteB",
                          "BILLINGS CLINIC",
                          "Collaborative Science & Innovation (CSI) - Documents",
                          "Ye Olde V Drive",
                          "STAFF Folders",
                          "Ben",
                          "test_mule_CSI Dissemination Annual.xlsx")

df_studies <- read_excel(fl_nm,
                     sheet = "studies")

df_investigators <- read_excel(fl_nm,
                               sheet = "investigators")

df_si_key <- read_excel(fl_nm,
                        sheet = "studies_investigators")

# DATA CLEANING - Admin
df_studies$study_stage <- factor(df_studies$study_stage,
                                 ordered = TRUE,
                                 levels = c("Backlog",
                                            "Proposal",
                                            "PE/IRB",
                                            "Data",
                                            "Analysis",
                                            "Manuscript",
                                            "Submitted",
                                            "Accepted"))

# PUBLISHING DATA
# Load 
df_manuscripts <- list(2021,
                    2020,
                    2019,
                    2018)

df_manuscripts <- 
  lapply(df_manuscripts, 
       function(x){
         tmp_df <- read_excel(fl_nm_dissem,
                              sheet = as.character(x))
         
         tmp_df[["Year"]] <- x
         
         return(tmp_df)
       })

df_manuscripts <- do.call("rbind", df_manuscripts)

labels_df_manuscripts <- c("Authors",
                            "Type of Publication",
                            "Title",
                            "Publication/Meeting",
                            "Date of Publication/Presentation (per Pub Med)",
                           "Total Citations",
                           "Citations as of",
                           "Google Scholar ID",
                           "PubMed ID",
                           "Year")

names(df_manuscripts) <- c("authors",
                           "type",
                           "title",
                           "pub_body",
                           "pub_dts",
                           "total_citations",
                           "worthless",
                           "gsID",
                           "pmID",
                           "Year")

# GET NCBI DATA via iCite API
# https://icite.od.nih.gov/api
# journal subset
pmids <- unique(df_manuscripts$pmID)
pmids <- pmids[!is.na(pmids)]

q <- paste(pmids, collapse = ",")
q <- paste("https://icite.od.nih.gov/api/pubs?pmids=",
           sep = "",
           q)

res <- GET(q)

rawToChar(res$content)
man_meta <- fromJSON(rawToChar(res$content))
df_man_meta <- man_meta$data

# Other potential sources
# https://www.ncbi.nlm.nih.gov/pmc/tools/get-metadata/
# https://www.ncbi.nlm.nih.gov/pmc/tools/developers/

# AUTHOR GOOGLE SCHOLAR DATA
# get author citation history
get_article_cite_history(id = "Xj4zg4wAAAAJ", # author's GoogleScholarID
                         article = "eflP2zaiRacC" # article's GoogleScholarID
)
# glimpse(df_manuscripts)


# LOAD EMPLOYEE TIMESHEETS