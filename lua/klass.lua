
local setmetatable = setmetatable
local tostring     = tostring
local print        = print

module "klass"

local Klass = {}
setmetatable(Klass, Klass)
Klass.__index    = Klass
Klass.__tostring = function() return "Klass" end

function Klass:new(klass)
  klass = setmetatable(klass or {}, self)
  function klass:new(...)
    local object = setmetatable({}, self)
    self.__index = self
    self.__tostring = object.tostring
    object:init(...)
    return object
  end
  return klass
end

local Cat = Klass:new()

function Cat:init(name)
  self.name = name
end

function Cat:tostring()
  return self.name
end

function Cat:meow()
  print(tostring(self) .. ": Meow~")
end

local carol = Cat:new("Carol")
local marol = Cat:new("Marol")

carol:meow()
marol:meow()
carol:meow()

-- Carol: Meow~
-- Marol: Meow~
-- Carol: Meow~

return Klass
