# coding=utf-8

s = u'¥'

# ¥
print(s)

# \
print(s.encode('shift_jis').encode('utf-8'))
