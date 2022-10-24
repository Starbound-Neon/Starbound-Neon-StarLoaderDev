
function init()
    message.setHandler("tech.run", function(_, client, path, ...)
        if not client then return nil end
        local target = _ENV
        for token in string.gmatch(path, "[^.]+") do
            target = target[token]
        end
        return target(...)
    end)
end

local timer = 0
function update()
    timer = timer + 0.01
    tech.setParentOffset({ math.sin(timer), math.cos(timer) })
end

function uninit()
    while true do end
end

-- pause uninit function
-- 