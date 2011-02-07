# coding=utf-8

s = '¥'

# ¥
print(s)

# \
print(str(s.encode('shift_jis'), 'shift_jis'))
