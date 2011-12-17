-- test.lua

local agent = require "agent"

a = agent.create(function (self)
    self:listen {
        login = function (self)
            self:listen {
                username = function(self, ...)
                    print("username", ...)
                    self:listen {
                        password = function(self, ...)
                            print("password", ...)
                            self:quit()
                        end
                    }
                    self:quit()
                end,
            }
        end,
        ok = function (self)
            self:quit()
        end,
    }
    print "login ok"
    local q = 0
    self:listen {
        chat = function (self, ...)
            print("chat", ...)
        end,
        question = function (self, ...)
            print("question", ...)
            local answer = "answer" .. q
            q = q + 1
            self:fork {
                [answer] = function (self, ...)
                    print("answer", ...)
                    self:quit()
                end
            }
        end,
    }
end)

a:send("login")
a:send("username", "alice")
a:send("username", "bob")
a:send("password", "xxx")
a:send("login")
a:send("username", "bob")
a:send("password", "yyy")
a:send("chat"    , "foobar")
a:send("ok")

a:send("chat"    , "hello")
a:send("question", "?0")
a:send("chat"    , "world")
a:send("question", "?1")
a:send("answer0" , "!0")
a:send("answer1" , "!1")

--[[
username	alice
username unknown	bob
password	xxx
username	bob
password	yyy
chat unknown	foobar
login ok
chat	hello
question	?0
chat	world
question	?1
answer	!0
answer	!1
--]]
