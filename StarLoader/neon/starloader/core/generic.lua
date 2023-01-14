
local mainconfig

local moduleconf
local modulefuncs = {modulename = {}, init = {}, update = {}, uninit = {}, tables = {}}
local firstupdate = true

function init(...)
    getConfig()
    sb.logInfo("\n["..mainconfig["logname"].."] [INIT] Loading " .. mainconfig["name"] .. " Config")
    loadConfig()

    getModules()
    sb.logInfo("\n["..mainconfig["logname"].."] [INIT] Loading " .. mainconfig["name"] .. " Modules")
    loadModules()
    
    --sb.logInfo("%s", modulefuncs)

    local init = modulefuncs.init
    for i = 1, #init do
        init[i](...)
    end
end

function update(...)

    -- Run the table access procedure

    if not tech then
        tech = os.__tech
    end
    if not localAnimator then
        localAnimator = os.__localAnimator
    end
    -- Run the modules

    local update = modulefuncs.update
    --local tables = modulefuncs.tables
    for i = 1, #update do
        local canrun = true
        for table, enabled in pairs(modulefuncs.tables[i]) do
            --sb.logInfo("%s | %s",table, enabled)
            if table == "tech" and enabled == true and not tech then
                canrun = false
            end
            if table == "localAnimator" and enabled == true and not localAnimator then
                canrun = false
            end
        end
        if canrun == true then
            update[i](...)
        end 
        if canrun == false and firstupdate then
           sb.logWarn("\n["..mainconfig["logname"].."] [%s] Module dependency missing or could not load!\n["..mainconfig["logname"].."] [%s] Please check your modules.json or .patch file.",modulefuncs.modulename[i],modulefuncs.modulename[i])
        end
    end
    firstupdate = false
end

function uninit(...)
    local uninit = modulefuncs.uninit
    for i = 1, #uninit do
        uninit[i](...)
    end
end



function getConfig()
    mainconfig = root.assetJson("/neon/starloader/core/config.json")
    local name = mainconfig["name"]
    local logname = mainconfig["logname"]
    local version = mainconfig["version"]
    local thirdpartyenabled = mainconfig["thirdpartyenabled"]
    local thirdpartymods = mainconfig["thirdpartymods"]
    sb.logInfo("\n["..mainconfig["logname"].."] [INIT] Reading Config: \n["..mainconfig["logname"].."] [INIT] Name: " .. name .. "\n["..mainconfig["logname"].."] [INIT] Version: " .. version .. "\n["..mainconfig["logname"].."] [INIT] Thirdpartymods: %s", thirdpartyenabled)
    return mainconfig
end

function loadConfig()
    if thirdpartyenabled then
        local loaded, _ = pcall(loadHasibound())
        if loaded == false then
            sb.logWarn("\n["..mainconfig["logname"].."] [THIRDPARTY] Third-Party Mod could not load!\n["..mainconfig["logname"].."] [THIRDPARTY] Please check /neon/starloader/core/config.json")
        end
    end
    sb.logInfo("\n["..mainconfig["logname"].."] [INIT] Config loaded!")
end


function searchModule(name)
    if moduleconf.modules[name] then
        return moduleconf.modules[name]["path"]
    end
end

function getModules()
    moduleconf = root.assetJson("/neon/starloader/modules/modules.json")
    for modulename, moduleparams in next, moduleconf.modules do
        local name = modulename
        local path = moduleparams["path"]
        local description = moduleparams["description"] or "No description."
        local options = moduleparams["options"]
        local tables = moduleparams["tables"]
        sb.logInfo("\n["..mainconfig["logname"].."] [INIT] Reading Module: \n["..mainconfig["logname"].."] [INIT] Name: " .. name .. "\n["..mainconfig["logname"].."] [INIT] Path: " .. path .. "\n["..mainconfig["logname"].."] [INIT] Description: " .. description .. "\n["..mainconfig["logname"].."] [INIT] Options: %s \n["..mainconfig["logname"].."] [INIT] Tables: %s", options, tables)
    end
    return moduleconf
end

function loadModules()
    for modulename, moduleparams in next, moduleconf.modules do
        if moduleparams["options"]["autostart"] then
            local _init, _update, _uninit = init, update, uninit

            require(moduleparams["path"])

            table.insert(modulefuncs.modulename, modulename)
            table.insert(modulefuncs.init,       init)
            table.insert(modulefuncs.update,     update)
            table.insert(modulefuncs.uninit,     uninit)
            table.insert(modulefuncs.tables,     moduleparams["tables"])

            init, update, uninit = _init, _update, _uninit
        end
    end
    sb.logInfo("\n["..mainconfig["logname"].."] [INIT] Modules loaded!")
end

function loadHasibound()
    for k, v in pairs(_unsafe("unsafe")) do
        _ENV[k] = v
    end
end













----------------------------------------------------------------------

local function checkTechSlots()
    local slotFound = false
    local function doForSlot(slot)
        if slotFound then return end
        local equippedTech = player.equippedTech(slot)
        if equippedTech == 'starloader' .. slot then
            slotFound = true
        elseif equippedTech == nil then
            local techName = 'starloader' .. slot
            player.makeTechAvailable(techName)
            player.enableTech(techName)
            player.equipTech(techName)
            slotFound = true
        end
    end
    
    doForSlot('head')
    doForSlot('body')
    doForSlot('legs')
end