-- agent.lua
-- modified from http://blog.codingnow.com/2011/12/dev_note_4.html

local setmetatable = setmetatable
local coroutine    = coroutine
local assert       = assert
local print        = print
local pairs        = pairs

module "agent"

local function create_event_group(agent, events, thread, parent_group)
    local group = {event  = {}          ,
                   thread = thread      ,
                   parent = parent_group}

    if parent_group then
        for msg in pairs(parent_group.event) do
            agent.group[msg] = nil
        end
    end

    for msg, fun in pairs(events) do
        group.event[msg] = fun
        assert(agent.group[msg] == nil, msg)
        agent.group[msg] = group
    end
end

local function pop_event_group(agent, group)
    for msg in pairs(group.event) do
        agent.group[msg] = nil
    end
    if group.parent then
        for msg in pairs(group.parent.event) do
            assert(agent.group[msg] == nil, msg)
            agent.group[msg] = group.parent
        end
    end
end

function create(main)
    local thread = coroutine.create(main)
    local agent  = setmetatable({ group = {} }, { __index = _M })
    local r, command, events = coroutine.resume(thread, agent)
    assert(r, command)
    assert(command == "listen", command)
    create_event_group(agent, events, thread)
    return agent
end

function send(agent, msg, ...)
    local group = agent.group[msg]
    if group == nil then
        print(msg .. " unknown", ...)
    else
        local thread = coroutine.create(group.event[msg])
        while true do
          local r, command, events = coroutine.resume(thread, agent, ...)
          assert(r, command)

          if command == "quit" then
              pop_event_group(agent, group)
              thread = group.thread
              group  = group.parent

          elseif command == "listen" then
              create_event_group(agent, events, thread, group)
              break

          elseif command == "fork" then
              create_event_group(agent, events, thread)
              break

          else
              break
          end
        end
    end
end

function listen(agent, msg)
    coroutine.yield("listen", msg)
end

function quit(agent)
    coroutine.yield("quit")
end

function fork(agent, msg)
    coroutine.yield("fork", msg)
end
