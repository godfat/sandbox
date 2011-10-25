
local Klass = {}
setmetatable(Klass, Klass)
Klass.__index    = Klass
Klass.__tostring = function() return "Class" end

function Klass:new()
  local klass = {}
  setmetatable(klass, Klass)
  klass.__index = klass
  function klass:new(...)
    local object = {}
    setmetatable(object, klass)
    -- i don't understand why this would work
    klass.__tostring = object.tostring
    -- i don't understand why this would work
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
