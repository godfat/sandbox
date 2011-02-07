# encoding: utf-8

s = '¥'

# ¥
puts(s)

# U+00A5 from UTF-8 to Shift_JIS (Encoding::UndefinedConversionError)
puts(s.encode('shift_jis').encode('utf-8'))
