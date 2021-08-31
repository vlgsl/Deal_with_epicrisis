library(lubridate)
library("readr")
library(stringi)
library(stringr)

dateCleanFormat <- function(file_){
  dd <- gsub('(0?[1-9]|[12]\\d|30|31)[.](0?[1-9]|1[0-2])[.](\\d{4})', 
           '\\1-\\2-\\3', file_)
  gsub('(0?[1-9]|[12]\\d|30|31)[.](0?[1-9]|1[0-2])[.](\\d{2})', 
     '\\1-\\2-20\\3', dd)
}
  
prepareBloodAnalysisForParsing <- function(file_){
  # must be before spaces removment!
  file_ -> stri_trans_tolower(file_)
  str_replace_all(file_, 'оак', 'общийанализкрови')
  str_replace_all(file_, 'бак\\s', 'общийанализкрови')
  str_replace_all(file_,
                  '[цcс]рб|\\w\\D(реактив.|реакт.|реак.)белок|crp', 
                  'C-реактивный белок')
  str_replace_all(file_,
                  '(\\wреатини\\w|креатин|креат.)(?![а-яА-Я,])', 
                  'Креатинин')
}


removeComasAndSpaces <- function(file_){
  gsub("[[:space:]]", "", 
       stringi::stri_trans_tolower(stri_replace_all_regex(file_, ',', '.')))
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

birthdayExtractor <- function(file_){
  str_extract(file_, '\\d{2}-\\d{2}-\\d{4}')
}

dischargeExtractor <- function(file_){
  str_extract(file_, '(?<=выписан.)\\d{1,2}-\\d{1,2}-\\d{4}')
}

admissionExtractor <- function(file_){
  str_extract(file_, '(?<=поступил.)\\d{1,2}-\\d{1,2}-\\d{4}')
}


procalcitoninAndCovidFinder <- function(file_){
  # fuction returns TRUE or FALSE (presence procalcitonin and covid19)
  ifelse(stri_count(file_, regex = "(c|с).vid19|к.р.н.вирусная|(b|в)34(|2)|sarscov2|торсков2|cov19")!=0 & 
           stri_count(file_, regex = "\\wр.кальцитони\\w|прокальцитон|прокальцит|прокальц|pct" )!=0,
         return(TRUE), return(FALSE))

my_data <- read_file("d:/PhD/data/R_train/35_Хлистовский-С-И.txt" )
my_data
dmy(my_data)
d2 <- strptime("2016-06-27", "%Y-%m-%d")

  
f  <-  dateCleanFormat(my_data)
f  <-  sub('.','', f) 
f <- tolower(gsub("[[:space:]]", "", f)) # remove all spaces
#f= ''.join(f.split())
f <- sub(':', '', f)
f
stri_match_all_regex(f, '\\d{2}.\\d{2}.\\d{4}')
str_extract_all(f, "\\d{2}.\\d{2}.\\d{4}(?=:прокальцитонин)") # find date before procalcitonine!

lubridate::dmy("06-01-2021") # convert to date!
str_extract_all(f, "(?<=гемостазиограмма)\\d{2}.\\d{2}.\\d{4}")# find date after pattern
str_extract_all(f, "(?<=фибриноген)\\d{1,2}.\\d{1}")# find value after pattern


SqlRender::writeSql("CREATE TABLE test (
                    ID INT NOT NULL
                    )","myParamStatement.sql") # creates sql file in DOCS
  
  
  
  # sorceConcept <- c('\\wреатини\\w|креатин|креат.|креат$',
#                   '[цcс]рб|\\w\\D(реактив.|реакт.|реак.)белок|crp',
#                   'тромбоциты|тромбоцит|тромб$|тромб.'
#                  )
# standardConcepts <- c('креатинин',
#                       'c-реактивныйбелок',
#                       'тромбоциты'
#                      )
# test <- 'креат срб тромбоцит'
# for(i in 1:length(unlist(str_split(test, ' ')))){
#   test <- str_replace_all(test, sorceConcept[i], standardConcepts[i])
# }
# test
