library(lubridate)
library(readr)
library(stringi)
library(stringr)

list_of_files <- list.files(path = "c:/Users/Alex/D/phd/R/script", recursive = TRUE,
                            pattern = "\\.txt$",
                            full.names = TRUE)
DT <- sapply(list_of_files, read_file)

DT[1]
dateCleanFormat <- function(file_){
  dd <- gsub('(0?[1-9]|[12]\\d|30|31)[.](0?[1-9]|1[0-2])[.](\\d{4})', 
             '\\1-\\2-\\3', file_)
  gsub('(0?[1-9]|[12]\\d|30|31)[.](0?[1-9]|1[0-2])[.](\\d{2})', 
       '\\1-\\2-20\\3', dd)
}
DT <- dateCleanFormat(DT)

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
DT <- prepareBloodAnalysisForParsing(DT)

removeComasAndSpaces <- function(file_){
  gsub("[[:space:]]", "", 
       stringi::stri_trans_tolower(stri_replace_all_regex(file_, ',', '.')))
}
DT <- removeComasAndSpaces(DT)
procalcitoninDateExtractor <- function(file_){
  str_extract_all(file_, 
                  "\\d{2}-\\d{2}-\\d{4}(?=:\\wр.кальцитони\\w|прокальцитон|прокальцит|прокальц|pct)")
}
procalcitonin <- procalcitoninDateExtractor(DT)
procalcitonin
procalcitoninValueExtractor <- function(file_){
  stringr::str_extract_all(file_,
                           "(?<=\\wр.кальцитони\\w|прокальцитон|прокальцит|прокальц|pct)\\d{1,3}.\\d{1,2}")
}
nCR <- numberCaseReportExtractor(DT)
proc <- procalcitoninValueExtractor(DT)
m1 <- matrix(procalcitonin)
m2 <- matrix(proc)
m3 <- matrix(nCR)
dd <- data.frame(m1, m2, m3)
df <- cbind(newColName = rownames(dd), dd)
rownames(df) <- 1:nrow(df)
df
library(tidyr)
names(proc) <- procalcitonin
mutate(proc, C=strsplit(C, ","))
proc[1:3]
procalcitonin[1:3]
do.call(data.frame, proc[1:3])
data.frame(unlist(procalcitonin[1:3]), unlist(proc[1:3]))
data.frame(colnames('data', 'value'), names(proc), unlist(proc))
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
  

  
  
  
  
  
  
  
file_ <- 'Гемостазиограмма 20.11.2020: Активир. 
частичное тромбопластин. время 36.8  сек ( 22-35 ) 
сек; Протромбированное время 13.8  сек ( 9.4-12.5 ) 
сек; Активн. протромбирован.комплекса (по Квику) 72 % 
( 83-150 )%; Международное нормализованное отношение 
1.19 ( 0.85-1.3 ); Фибриноген 8.14 г/л ( 2.7-4.7 )г/л;
Гемостазиограмма 22.11.2020
Гемостазиограмма 20.11.2020: Активир. 
частичное тромбопластин. время 36.8  сек ( 22-35 ) 
сек; Протромбированное время 13.8  сек ( 9.4-12.5 ) 
сек; Активн. протромбирован.комплекса (по Квику) 72 % 
( 83-150 )%; Международное нормализованное отношение 
1.19 ( 0.85-1.3 ); Фибриноген 8.14 г/л ( 2.7-4.7 )г/л;
Гемостазиограмма 22.11.2020' 

removeStopwordComasSpaces <- function(file_){
  gsub('<|>|меньше|меньшн|больше|более|до|менее|iultra|от', '',
       gsub("[[:space:]]", "", 
            stringi::stri_trans_tolower(stri_replace_all_regex(file_, ',', '.'))))
}
dateCleanFormat <- function(file_){
  dd <- gsub('(0?[1-9]|[12]\\d|30|31)[.](0?[1-9]|1[0-2])[.](\\d{4})', 
             '\\1-\\2-\\3', file_)
  gsub('(0?[1-9]|[12]\\d|30|31)[.](0?[1-9]|1[0-2])[.](\\d{2})', 
       '\\1-\\2-20\\3', dd)
}

file_ <-  removeStopwordComasSpaces(file_)
file_ <-  dateCleanFormat(file_)

file_
ids = c()
fibrinogenValues = c()
getFibrinogen <- function(file_){
  file_ <- gsub('(\\d{2}-\\d{2}-\\d{4})(гемостазиограмма)', '\\2\\1', file_)
  for(date in stri_extract_all(file_, regex='(?<=гемостазиограмма)(\\d{2}-\\d{2}-\\d{4}|)' )){
    id <- str_extract(file_, "\\d+")
    append(ids, id)
  }
  file_1 = gsub('(гемостазиограмма)(\\d{2}-\\d{2}-\\d{4})', '\\2\\1', file_)
  for(value in stri_extract_all(file_1, regex='(?<=гемостазиограмма)(\\d{2}-\\d{2}-\\d{4}|)')){
    value <-  gsub('(.*)(фибриноген)(\\d.\\d*)', '\\3\\2\\1', file_1)
    value <- gsub('(фибриноген|гемостазиограмма).*', '', value)
    append(fibrinogenValues, value)
    }
  return(value)
}
