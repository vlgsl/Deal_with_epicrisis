dates = '20.02.21 30.03.20 20.12.20'


for date in dates.split():
  print('-'.join([j if i != 2 else str(20)+j for 
                  i,j in enumerate(date.split('.'))]))
