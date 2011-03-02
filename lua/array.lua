
lub = {}
lub.Array = {}
lub.Array.__index = lub.Array

function lub.Array.new(table)
   local array = {}
   setmetatable(array, lub.Array)
   array['data'] = table
   return array
end

function lub.Array:first()
  return self['data'][1]
end

function lub.Array:at(index)
  return self['data'][index+1]
end

function lub.Array:size()
  return #self['data']
end

function lub.Array:last()
  return self['data'][self:size()]
end

function lub.Array:each(yield)
  for i, v in ipairs(self['data']) do
    yield(v, i-1)
  end
  return self
end

function lub.Array:join(separate)
  local result = ''
  self:each(function(v, i)
    if i < self:size()-1 then
      result = result .. v .. separate or ''
    end
  end)
  return result .. self:last()
end

function lub.Array:inspect()
  return '[' .. self:join(', ') .. ']'
end

function lub.Array:reserve(size, default)
  if self:size() < size then
    local step = self:size()
    while step < size do
      self['data'][step+1] = default or ''
      step = step + 1
    end
  end
  return self
end

function lub.Array:assign(index, value, default)
  if index <= self:size() then
    self['data'][1+index] = value
    return value
  else
    self:reserve(index, default)
    return self:assign(index, value, default)
  end
end

-- function lub.Array:rotate(arg)
--   local offset = arg or 1
--   local result = {}
--   for i, v in ipair(self['data'])
--
--   end
--   return Array.new(result)
-- end
--
-- function lub.Array.rotate_inplace(arg)
--   self['data'] = self:rotate()['data']
--   return self
-- end

local a = lub.Array.new({'a', 'b', 'c'})
print(a:first() == 'a') -- a
print(a:at(0) == 'a') -- a
print(a:size() == 3) -- 3
print(a:last() == 'c') -- c
print(a:inspect() == '[a, b, c]')
a:reserve(5)
print(a:size() == 5) -- 5
print(a:assign(10, 5) == 5) -- 5
print(a:at(10) == 5) -- 5
print(a:size() == 11) -- 11
