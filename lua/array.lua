
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

function lub.Array:join(delimiter)
  -- local result = ''
  -- self:each(function(v, i)
  --   if i < self:size()-1 then
  --     result = result .. v .. delimiter or ''
  --   end
  -- end)
  -- return result .. self:last()
  return table.concat(self['data'], delimiter or '')
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

function lub.Array:dup()
  local result = {}
  self:each(function(v, i)
    result[i+1] = v
  end)
  return lub.Array.new(result)
end

function lub.Array:range(first, last)
  local result = {}
  local step = first
  while step < last do
    result[step+1-first] = self:at(step)
    step = step + 1
  end
  return lub.Array.new(result)
end

function lub.Array:push(value)
  return self:assign(self:size(), value)
end

function lub.Array:concat(rhs)
  local result = self:dup()
  rhs:each(function(v, i)
    result:push(v)
  end)
  return result
end

-- use range_inplace instead???
function lub.Array:rotate(arg)
  local offset = arg or 1
  if offset > 0 then
    return lub.Array.concat(
      self:range(offset, self:size()),
      self:range(0, offset))
  else
    return lub.Array.concat(
      self:range(self:size() + offset, self:size()),
      self:range(0, self:size() + offset))
  end
end

function lub.Array:rotate_inplace(arg)
  self['data'] = self:rotate()['data']
  return self
end

local a = lub.Array.new({'a', 'b', 'c'})
print(a:first() == 'a')
print(a:at(0) == 'a')
print(a:size() == 3)
print(a:last() == 'c')
print(a:inspect() == '[a, b, c]')
print(a:concat(a):inspect() == '[a, b, c, a, b, c]')
print(a:dup():inspect() == a:inspect())
print(a:dup() ~= a)
a:dup():assign(0, 'd')
print(a:inspect() == '[a, b, c]')
print(a:assign(3, 'd') == 'd')
print(a:inspect() == '[a, b, c, d]')
print(a:range(1,3):inspect() == '[b, c]')
print(a:rotate( 1):inspect() == '[b, c, d, a]')
print(a:rotate( 2):inspect() == '[c, d, a, b]')
print(a:rotate( 3):inspect() == '[d, a, b, c]')
print(a:rotate(-1):inspect() == '[d, a, b, c]')
print(a:rotate(-2):inspect() == '[c, d, a, b]')
print(a:rotate(-3):inspect() == '[b, c, d, a]')
print(a:inspect() == '[a, b, c, d]')
print(a:rotate_inplace():inspect() == '[b, c, d, a]')
print(a:inspect() == '[b, c, d, a]')
a:reserve(5)
print(a:size() == 5)
print(a:assign(10, 5) == 5)
print(a:at(10) == 5)
print(a:size() == 11)
