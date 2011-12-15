
local setmetatable = setmetatable
local tostring     = tostring
local print        = print
local getmetatable = getmetatable

module "klass"

local Klass = {}
setmetatable(Klass, Klass)
Klass.__index    = Klass
Klass.__tostring = function() return "Klass" end

function Klass:new(klass)
  print("Klass' new called")
  klass = setmetatable(klass or {}, {__index    = Klass,
                                     __tostring = function()
                                                    return klass.name
                                                  end})
  function klass:new(object)
    print("Cat's new called")
    object = setmetatable(object or {}, {__index    = klass,
                                         __tostring = klass.tostring})
    return object
  end
  function klass:klass()
    return getmetatable(self).__index
  end
  return klass
end

local Cat = Klass:new{name = "Cat"}
print(Cat:klass())

function Cat:tostring()
  return self.name
end

function Cat:meow()
  print(tostring(self:klass()) .. ": " .. tostring(self) .. ": Meow~")
end

local carol = Cat:new{name="Carol"}
local marol = Cat:new{name="Marol"}

carol:meow()
marol:meow()
carol:meow()

-- Carol: Meow~
-- Marol: Meow~
-- Carol: Meow~

return Klass
