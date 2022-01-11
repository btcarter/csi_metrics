# This script will get data and process it so it's ready for various reports

# libraries
library(dplyr)
library(readxl)
library(scholar)
library(httr)
library(jsonlite)
library(tidyr)

# load log data
fl_log <- file.path("C:",
                    "Users",
                    "CarteB",
                    "BILLINGS CLINIC",
                    "Collaborative Science & Innovation (CSI) - Documents",
                    "Ye Olde V Drive",
                    "RESEARCH COORDINATION COUNCIL",
                    "CSI Metrics",
                    "prototype_log.xlsx")

df_proposals <- read_xlsx(fl_log,
                          sheet = "irb_pe_proposals")

df_grants <- read_excel(fl_log,
                        sheet = "grants")

df_studies <- read_excel(fl_log,
                         sheet = "studies")

df_datasets <- read_excel(fl_log,
                          sheet = "datasets")

df_dissem <- read_xlsx(fl_log,
                       sheet = "publications")

df_authors <- read_xlsx(fl_log,
                        sheet = "authors")

df_pub_auth_key <- read_xlsx(fl_log,
                             sheet = "authors_and_publications")

df_si_key <- read_excel(fl_log,
                        sheet = "studies_and_investigators")

df_grants_studies_key <- read_excel(fl_log,
                                    sheet = "grants_studies")

df_prop_study_key <- read_excel(fl_log,
                                sheet = "proposal_study")

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

df_dissem$target_audience <- factor(df_dissem$target_audience,
                                    ordered = TRUE,
                                    levels = c("Organization",
                                               "Local",
                                               "State",
                                               "Regional",
                                               "USA",
                                               "International",
                                               "Not USA"))

df_dissem$csi_support <- factor(df_dissem$csi_support,
                                    ordered = TRUE,
                                    levels = c("None",
                                               "Editing or submission",
                                               "Regulatory",
                                               "Acknowledgements",
                                               "Authorship"))

# GET NCBI DATA via iCite API ##################################################
# https://icite.od.nih.gov/api
# journal subset
pmids <- unique(df_dissem$pmid)
pmids <- pmids[!is.na(pmids)]

q <- paste(pmids, collapse = ",")
q <- paste("https://icite.od.nih.gov/api/pubs?pmids=",
           sep = "",
           q)

# q <- paste("https://icite.od.nih.gov/api/pubs?pmids=",
#            sep = "",
#            34706876)

res <- GET(q)

# rawToChar(res$content)
man_meta <- fromJSON(rawToChar(res$content))
df_man_meta <- man_meta$data

df_man_meta$pmid <- as.character(df_man_meta$pmid)

# GET DATA ON ARTICLES THAT CITE US ############################################
df_cited_by <- df_man_meta %>% 
  select(
    manuscript_pmid = pmid,
    cited_by_pmid = cited_by
  ) %>% 
  unnest(
    cited_by_pmid
  ) %>% 
  mutate(
    cited_by_pmid = as.character(cited_by_pmid)
  )

pmids <- unique(df_cited_by$cited_by_pmid)
q <- paste(pmids, collapse = ",")
q <- paste("https://icite.od.nih.gov/api/pubs?pmids=",
           sep = "",
           q)

res <- GET(q)

man_meta <- fromJSON(rawToChar(res$content))
df_cited_by_meta <- man_meta$data

df_cited_by_meta$pmid <- as.character(df_cited_by_meta$pmid)


# tmp <- strsplit(df_man_meta$authors, split = ", ")
# cat(paste(tmp[[1]], collapse="\n"))

# Other potential sources
# https://www.ncbi.nlm.nih.gov/pmc/tools/get-metadata/
# https://www.ncbi.nlm.nih.gov/pmc/tools/developers/

# AUTHOR GOOGLE SCHOLAR DATA ##################################################
# get author citation history
# get_gs_stats <- function(x){
#   
#   googleScholarID <- x[1] 
#   
#   articleGSID <- x[2]
#   
#   
#   x <- get_article_cite_history(id = googleScholarID,
#                                 article = articleGSID)
#   
#   Sys.sleep(2)
#   
#   return(x)
# }


# test <- apply(df_manuscripts[c("gsID",
#                                "pi_gsID")], 
#               1, 
#               get_gs_stats)


# test <- get_article_cite_history(id = "Xj4zg4wAAAAJ", # author's GoogleScholarID
#                          article = "eflP2zaiRacC" # article's GoogleScholarID
# )

# glimpse(df_manuscripts)


# LOAD EMPLOYEE TIMESHEETS

# fl_nm <- file.path("C:",
#                    "Users",
#                    "CarteB",
#                    "OneDrive - BILLINGS CLINIC",
#                    "worklog.xlsx")
# 
# df_ts <- read_xlsx(fl_nm,
#                    sheet = "timeTrackerData")
# 
# df_ts_studies <- read_xlsx(fl_nm,
#                            sheet = "project_list")
# 
# df_ts <- df_ts %>%
#   mutate(
#     time = as.numeric(dts_out - dts_in)
#   ) %>%
#   mutate(
#     hrs = time/(60)
#   )

