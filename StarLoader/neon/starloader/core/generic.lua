local _init = init or function() end
local _update = update or function() end
local _uninit = uninit or function() end

local vanillaTechList = {
    distortionsphere = "/tech/distortionsphere/distortionsphere.tech",
    aquasphere =       "/tech/distortionsphere/aquasphere.tech",
    spikesphere =      "/tech/distortionsphere/spikesphere.tech",
    sonicsphere =      "/tech/distortionsphere/sonicsphere.tech",
    dash =             "/tech/dash/dash.tech",
    airdash =          "/tech/dash/airjump.tech",
    sprint =           "/tech/dash/sprint.tech",
    blinkdash =        "/tech/dash/blinkdash.tech",
    doublejump =       "/tech/jump/doublejump.tech",
    multijump =        "/tech/jump/multijump.tech",
    rocketjump =       "/tech/jump/rocketjump.tech",
    walljump =         "/tech/jump/walljump.tech"
}
local function checkTechSlots()
    local slotFound = false
    local function doForSlot(slot)
        if slotFound then return end
        local equippedTech = player.equippedTech(slot)
        if equippedTech == nil then
            local techName = 'starloader' .. slot
            player.makeTechAvailable(techName)
            player.enableTech(techName)
            player.equipTech(techName)
            slotFound = true
        elseif equippedTech == 'starloader' .. slot then
            slotFound = true
        end
    end
    
    doForSlot('head')
    doForSlot('body')
    doForSlot('legs')
    


    local headTech = player.equippedTech('head')
    local bodyTech = player.equippedTech('body')
    local legsTech = player.equippedTech('legs')

    if not slotFound then
        if vanillaTechList[headTech] ~= nil then
            local techPath = vanillaTechList[headTech]
            local techConfig = root.assetJson(techPath)
            -- important
            -- techConfig.name type scripts animator shortDescription description rarity icon
            for _, script in ipairs(techConfig.scripts) do
                local absolutePath
                if string.sub(script, 1, 1) == "/" then
                    absolutePath = script
                else
                    absolutePath = techPath:match("(.*/)") .. script
                end
                --sb.logInfo('generic.lua: ' .. absolutePath)

                -- fake environment
                local env = {}

                local _ENV_MT = getmetatable(_ENV)
                setmetatable(_ENV, {
                    __index = function(t, k)
                        return rawget(env, k)
                    end,
                    __newindex = function(t, k, v)
                        rawset(env, k, v)
                        return v
                    end
                })
                require(absolutePath) -- it overrides update(), init(), uninit()

            end
        end
    end
end

function init(...)

    --player.makeTechAvailable('distortionsphere')
    --player.enableTech('distortionsphere')
    --player.equipTech('distortionsphere')
    --player.makeTechAvailable('dash')
    --player.enableTech('dash')
    --player.equipTech('dash')
    --player.makeTechAvailable('doublejump')
    --player.enableTech('doublejump')
    --player.equipTech('doublejump')

    -- !!!!! try emulating tech
    --    1. find free slot
    --    2. if not found, open gui

    checkTechSlots()




    return _init(...)
end

function update(...)

    return _update(...)
end

function uninit(...)
    return _uninit(...)
end