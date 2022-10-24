require('/scripts/starloader/core.lua')

SL_API = {}

SL_API.Modules = {}

function SL_API.import()

end

function SL_API.register(config)
    assert((type(id) == 'string' and id:find('^%w+_%w+$')) == 1, 'module.id is missing or in a bad format. Use the "<author>_<module>" format')
    if config.description == nil then
        config.description = "No description"
        sb.logWarn('module.description is preferable')
    end
    config.public = config.public or true
    
end