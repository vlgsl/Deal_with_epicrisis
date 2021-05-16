import re

def change_date_format(dt):
    """ на первом этапе переводим "нормальный формат" в формат через дефисы
     на втором этапе ищем вариант дд.мм.гг в формат через дефисы"""
    data_1 =  re.sub(r'(0?[1-9]|[12]\d|30|31)[.](0?[1-9]|1[0-2])[.](\d{4})', '\\1-\\2-\\3', dt)
    return re.sub(r'(0?[1-9]|[12]\d|30|31)[.](0?[1-9]|1[0-2])[.](\d{2})', '\\1-\\2-20\\3', data_1)


f=change_date_format(file_)
f = f.replace('.','')
f= ''.join(f.split())
patt1 = re.compile('(?<=прокальцитонин)\d{2}.\d{2}.\d{4}|\d{2}.\d{2}.\d{4}(?=прокальцитонин)')
patt1.findall(f)



def subit(m):
    """Replace everything except"""
    stuff, word = m.groups()
    return ("" * len(stuff)) + word

s = 'I am going home now, thank you.' # string to modify
#re.sub(r'(?!going|you)\b([\S\s]+?)(\b|$)', lambda x: (x.end() - x.start())*'_', s)
print(re.sub(r'(.+?)(going|you|$)', subit, s))
