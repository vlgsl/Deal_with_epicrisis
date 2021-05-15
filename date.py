dates = '20.02.21 30.03.20 20.12.20'


for date in dates.split():
  print('-'.join([j if i != 2 else str(20)+j for 
                  i,j in enumerate(date.split('.'))]))

  
  
  
  
  
import re
def change_date_format(dt):
        return re.sub(r'(\d{2})[.](\d{1,2})[.](\d{1,2}\D)', '\\1-\\2-20\\3', dt)
  
  
# dt1 = '31.12.20'
# print("Original date in DD-MM-YY Format: ",dt1)
print("New date in DD-MM-YYYY Format: ",change_date_format(file_))



import re

def change_date_format(dt):
        return re.sub(r'(0?[1-9]|[12]\d|30|31)[.](0?[1-9]|1[0-2])[.](\d{4}|\d{2})', '\\1-\\2-\\3', dt)
# dt1 = '31.12.20'
# print("Original date in DD-MM-YY Format: ",dt1)
print("New date in DD-MM-YYYY Format: ",change_date_format(file_))
