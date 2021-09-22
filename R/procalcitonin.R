library(lubridate)
library(readr)
library(stringi)
library(stringr)
library(splitstackshape)
library(tidyr)
library(writexl)
library(dplyr)
list_of_files <- list.files(path = "c:/Users/Alex/D/phd/R/script", 
                            recursive = TRUE,
                            pattern = "\\.txt$",
                            full.names = TRUE)
DT <- sapply(list_of_files, read_file)



dateCleanFormat <- function(file_){
  dd <- gsub('(0?[1-9]|[12]\\d|30|31)[.](0?[1-9]|1[0-2])[.](\\d{4})', 
             '\\1-\\2-\\3', file_)
  gsub('(0?[1-9]|[12]\\d|30|31)[.](0?[1-9]|1[0-2])[.](\\d{2})', 
       '\\1-\\2-20\\3', dd)
}
prepareBloodAnalysisForParsing <- function(file_){
  # must be before spaces removment!
  #file_ -> stringr::str_to_lower(file_)
  str_replace_all(str_to_lower(file_), 'оак', 'общийанализкрови')
  str_replace_all(str_to_lower(file_), 'бак\\s', 'общийанализкрови')
  str_replace_all(str_to_lower(file_),
                  '[цcс]рб|\\w\\D(реактив.|реакт.|реак.)белок|crp', 
                  'C-реактивный белок')
  str_replace_all(str_to_lower(file_),
                  '(\\wреатини\\w|креатин|креат.)(?![а-яА-Я,])', 
                  'Креатинин')
}
removeComasAndSpaces <- function(file_){
  gsub('<|>|меньше|меньшн|больше|более|до|менее', '', gsub("[[:space:]]", "", 
                                                  stringi::stri_trans_tolower(stri_replace_all_regex(file_, ',', '.'))))
}
procalcitoninDateExtractor <- function(file_){
  str_extract_all(file_, 
                  "\\d{2}-\\d{2}-\\d{4}(?=:\\wр.кальцитони\\w|прокальцитон|прокальцит|прокальц|pct)")
}
procalcitoninValueExtractor <- function(file_){
  stringr::str_extract_all(file_,
                           "(?<=\\wр.кальцитони\\w|прокальцитон|прокальцит|прокальц|pct)\\d{1,3}.\\d{1,2}")
}
numberCaseReportExtractor <- function(file_){
  str_extract(file_, '(?<=а№)\\d{1,5}')
}

DT <- dateCleanFormat(DT)
DT <- prepareBloodAnalysisForParsing(DT)
DT <- removeComasAndSpaces(DT)


procalcitoninDate <- procalcitoninDateExtractor(DT)
nCR <- numberCaseReportExtractor(DT)
procalcitoninValue <- procalcitoninValueExtractor(DT)


procalcitoninDate[procalcitoninDate == 'character(0)'] <- NaN
procalcitoninValue[procalcitoninValue == 'character(0)'] <- NaN
nCR[nCR == 'character(0)'] <- NaN
procalcitoninDate
#-------------------------------------------------------------------------------


procalcitoninDate <- matrix(procalcitoninDate)
procalcitoninValue <- matrix(procalcitoninValue)
numberCaseReport <- matrix(nCR)
procalcitoninValue[1:50]

dd <- data.frame(procalcitoninDate, 
                 procalcitoninValue, 
                 numberCaseReport, stringsAsFactors=FALSE)
df <- cbind(newColName = rownames(dd), dd)
rownames(df) <- 1:nrow(df)
#df$procalcitoninDate <- lubridate::dmy(df$procalcitoninDate)
tdf1 <- df[, c(1, 3, 4)]
tdf2 <- df[, c(1, 2)]
procalcitoninTableValues <- cSplit(tdf1, "procalcitoninValue", sep=",", "long",
            type.convert = T, makeEqual = F, fixed = F)
procalcitoninTableDates <- cSplit(tdf2, "procalcitoninDate", sep=",", "long",
                                   type.convert = T, makeEqual = F, fixed = F)
procalcitoninTableValues$procalcitoninValue <- gsub('(', '', procalcitoninTableValues$procalcitoninValue)
procalcitoninTableValues
writexl::write_xlsx(procalcitoninTableDates, path = 'c:/Users/Public/Documents/ProcalcitoninDates.xlsx')
l <- tdf2$procalcitoninDate 
unnest(tdf2, procalcitoninDate)


