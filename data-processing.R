## =============================== License ========================================
## ================================================================================
## This work is distributed under the MIT license, included in the parent directory
## Copyright Owner: University of Oxford
## Date of Authorship: 2016
## Author: Martin John Hadley (orcid.org/0000-0002-3039-6849)
## Academic Contact: Mireia Borrell-Porta (orcid.org/0000-0003-2328-1258)
## Data Source: local file
## ================================================================================

## ========================== Get from Figshare ================================

# start <- Sys.time()
# import_fs_xlsx <- read.xlsx("data/policies.xlsx", sheetIndex = 1,startRow = 2, header = F)
# ncol(import_fs_xlsx)
# 
# import_fs_xlsx_header <- read.xlsx("data/policies.xlsx", sheetIndex = 1, rowIndex = 1, header = F)
# 
# import_fs_xlsx %>% head()
# 
# new_headings <- import_fs_xlsx_header[1,] %>% 
#   unlist(use.names = F) %>% 
#   as.character() %>%
#   gsub("^[\n]","",.) %>%
#   gsub("[\n]"," ",.) %>%
#   trimws()

## =========================== Get data ====================================
## ==============================================================================

fs_deposit_id <- 3847776
deposit_details <- fs_details(fs_deposit_id)

deposit_details <- unlist(deposit_details$files)
deposit_details <- data.frame(split(deposit_details, names(deposit_details)),stringsAsFactors = F) %>%
  as_tibble()

deposit_details %>%
  filter(name == "Policies dataset - final figshare.xlsx") %>%
  select(download_url) %>%
  .[[1]] %>%
  download.file(destfile = "data/figshare_policies.xlsx")

figshare_policies <- read_xlsx("data/figshare_policies.xlsx")

colnames(figshare_policies) <- figshare_policies %>% 
  colnames() %>%
  trimws() %>%
  tolower() %>%
  make.names() %>%
  gsub("^X.", "", .) %>%
  gsub("[.]{2,}", ".", .) %>%
  trimws() %>%
  gsub("[.]$", "", .)

figshare_policies <- figshare_policies %>%
  mutate(valid.from.b = ymd(valid.from.b))

## =========================== Fix Excel Dates ====================================
## ==============================================================================

fix_ongoing_excel_dates <- function(
  data,
  column
){
  
  the_col <- enquo(column)
  col_name <- quo_name(the_col)
  
  
  data %>%
    mutate(!!col_name := if_else(UQ(the_col) == "ongoing",
                                 as.character(Sys.Date()),
                                 as.character(as.POSIXct(
                                   as.numeric(UQ(the_col)) * 60 * 60 * 24,
                                   origin = "1899-12-30"
                                 ))),
           !!col_name := ymd(UQ(the_col)))
  
}

figshare_policies <- figshare_policies %>%
  fix_ongoing_excel_dates(valid.until.c) %>%
  fix_ongoing_excel_dates(valid.from.childbirth.related.date.d) %>%
  fix_ongoing_excel_dates(valid.until.childbirth.related.date.e)

## =========================== Sort by earliest date ====================================
## ==============================================================================

figshare_policies <- figshare_policies %>%
  arrange(valid.from.b) %>%
  select(valid.from.b, name.of.policy, everything()) %>%
  mutate(name.of.policy = fct_reorder(name.of.policy, valid.from.b))

## =========================== \n to <br> ====================================
## ==============================================================================


new_lines_to_p_tags <- function(text) {
  gsub(pattern = "\n", replacement = "<br />", text)
}


figshare_policies <- figshare_policies %>%
  mutate_if(is.character, new_lines_to_p_tags)

timeline_data <- figshare_policies



