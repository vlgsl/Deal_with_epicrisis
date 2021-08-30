library(lubridate)
library("readr")
library(stringi)


my_data <- read_file("d:/PhD/data/R_train/35_Хлистовский-С-И.txt" )
my_data
dmy(my_data)
d2 <- strptime("2016-06-27", "%Y-%m-%d")
dateCleanFormat <- function(file_){
  dd <- gsub('(0?[1-9]|[12]\\d|30|31)[.](0?[1-9]|1[0-2])[.](\\d{4})', 
           '\\1-\\2-\\3', file_)
  gsub('(0?[1-9]|[12]\\d|30|31)[.](0?[1-9]|1[0-2])[.](\\d{2})', 
     '\\1-\\2-20\\3', dd)
}

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
