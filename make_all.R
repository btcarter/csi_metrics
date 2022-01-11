# Preamble ####
# Auther: Benjamin T. Carter, PhD
# Objective - create CSI portfolio reports and slides

# vars
SCRIPT_DIR = file.path("C:",
                       "Users",
                       "CarteB",
                       "BILLINGS CLINIC",
                       "Collaborative Science & Innovation (CSI) - Documents",
                       "Ye Olde V Drive",
                       "STAFF Folders",
                       "Ben",
                       "csi_portfolio"
                       )

OUT_DIR = file.path("C:",
                    "Users",
                    "CarteB",
                    "BILLINGS CLINIC",
                    "Collaborative Science & Innovation (CSI) - Documents",
                    "Ye Olde V Drive",
                    "STAFF Folders",
                    "Ben",
                    "csi_portfolio_output"
                    )


# run preprocessing - this returns a dataframe to the global environment called 
#                     'df' for use in the scripts that follow. Changes here will
#                     change thinge everywhere!

source(file = file.path(SCRIPT_DIR,
                        "preprocessing.R"))

# DEPARTMENT PUBLCATION CV ####
# rmarkdown::render(
#   input = file.path(SCRIPT_DIR,
#                     "report_pubs_list.Rmd"),
#   output_format = c("html_document",
#                     "word_document",
#                     "md_document"),
#   output_dir = OUT_DIR,
#   output_file = c("dept_pubs.html",
#                   "dept_pubs.docx",
#                   "dept_pubs.md")
# )

# DEPARTMENT REPORT ####
rmarkdown::render(
  input = file.path(SCRIPT_DIR,
                    "report_department.Rmd"),
  output_format = c("html_document"
                    ,"slidy_presentation"
                    # ,"powerpoint_presentation"
  ),
  output_dir = OUT_DIR,
  output_file = c("general_report1"
                  ,"general_report1_slides"
                  # ,"general_report1_slides"
  )
)

# CREATE INVESTIGATOR REPORTS


