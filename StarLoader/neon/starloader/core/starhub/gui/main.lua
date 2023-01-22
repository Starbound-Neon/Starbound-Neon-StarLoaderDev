local screen_size_x = math.ceil(1730)--1680 / 2)--1730
local screen_size_y = math.ceil(685)--987 / 2)--685
local screen_size_max = {9600,4320}--root.imageSize(config.getParameter("gui.background.fileBody"))
local min_valid_resolution = {100,100}

local sidebar_width
local label_height
local label_content_height
local sidebar_content_width

local firstupdate = true

local check_interval = 1 -- check every 5 seconds
local timer = 0

local starhubstaticloaded = false

local slMainConf
local slModuleConf

local sidebarobjects = {authorname = {}, modulename = {}, modulepath = {}, moduledescription = {}, modulelogo = {}, moduleoptions = {}, moduletables = {}}

local function populate()
  sidebar_width = math.min(350, screen_size_x / 3)
  label_height = math.min(100, screen_size_y / 6)
  label_content_height = label_height - 20
  sidebar_content_width = sidebar_width - 20

  scrollableSideBarTop = screen_size_y - label_height


  if not starhubstaticloaded then
    widget.setImage("back", "/neon/starloader/core/starhub/gui/pixel.png?multiply=000000BB?scalenearest=" .. 9600 .. ";" .. 4320)

    widget.setImage("sidebar", "/neon/starloader/core/starhub/gui/pixel.png?multiply=000000BB?scalenearest=" .. sidebar_width .. ";" .. screen_size_y)
    
    widget.setImage("sidebar_header", "/neon/starloader/core/starhub/gui/pixel.png?multiply=000000FF?scalenearest=" .. sidebar_width .. ";" .. label_height)
    widget.setPosition("sidebar_header", {0,(screen_size_y - label_height)})

    widget.setSize("sidebarscrollarea", {sidebar_width, screen_size_y - 2 * label_height})
    widget.setPosition("sidebarscrollarea", {0, label_height})

    local size = root.imageSize("/neon/starloader/core/starhub/gui/starhub.png")
    size[1] = size[1] / 2
    size[2] = size[2] / 2

    widget.setImage("sidebar_logo", "/neon/starloader/core/starhub/gui/starhub.png?scale=" .. math.min(sidebar_content_width / size[1], label_content_height / size[2]))
  
    local adjustedsize = size[1] * math.min(sidebar_content_width / size[1], label_content_height / size[2])

    widget.setPosition("sidebar_logo", {((sidebar_width - adjustedsize) / 2),(screen_size_y - label_height + 10)})

    widget.setImage("sidebar_footer", "/neon/starloader/core/starhub/gui/pixel.png?multiply=000000FF?scalenearest=" .. sidebar_width .. ";" .. label_height)

    --widget.setImage("separator", "/neon/starloader/core/starhub/gui/line.png?multiply=00000000?scale=" .. 1 .. ";" .. screen_size_y / 2) --?multiply=00000000
    --widget.setPosition("separator", {sidebar_width, 0})

    -- Clear all widgets from the container and make new ones
    widget.removeAllChildren("sidebarscrollarea")

    -- Check if StarLoader has given its Modules to StarHub
    if slModuleConf then
      sidebarobjects = {authorname = {}, modulename = {}, modulepath = {}, moduledescription = {}, modulelogo = {}, moduleoptions = {}, moduletables = {}}
      --sb.logInfo("test")
      moduleindex = 0
      for modulename, moduleparams in next, slModuleConf.modules do
        local name = modulename
        local author = moduleparams["author"] or "unknown"
        local path = moduleparams["path"]
        local description = moduleparams["description"] or "No description."
        local logo = moduleparams["logo"] or "assetmissing.png"
        local options = moduleparams["options"]
        local tables = moduleparams["tables"]

        table.insert(sidebarobjects.authorname , author)
        table.insert(sidebarobjects.modulename , name)
        table.insert(sidebarobjects.modulepath , path)
        table.insert(sidebarobjects.moduledescription , description)
        table.insert(sidebarobjects.modulelogo , logo)
        table.insert(sidebarobjects.moduleoptions , options)
        table.insert(sidebarobjects.moduletables , tables)

        moduleindex = moduleindex + 1
        sb.logInfo("" .. moduleindex)
      end
      --table.sort(sidebarobjects.authorname, compare)
      -- Sort authornames
      -- Assuming that you have a list of authors in the authorname table, you could use the table.sort function to sort the table by authorname, like so:

      --  -- Sort authorname table alphabetically
      --table.sort(sidebarobjects.authorname)
      --local sidebarobjectstemp = {authorname = {}, modulename = {}, modulepath = {}, moduledescription = {}, modulelogo = {}, moduleoptions = {}, moduletables = {}}
      ---- Iterate through authorname table
      --for i, v in ipairs(sidebarobjects.authorname) do
      --  -- Get the index of the current author
      --  local index = i - 1
      --
      --  -- Rearrange the other tables in sync with the changes in authorname table
      --  sidebarobjectstemp.modulename[index] = sidebarobjects.modulename[v]
      --  sidebarobjectstemp.modulepath[index] = sidebarobjects.modulepath[v]
      --  sidebarobjectstemp.moduledescription[index] = sidebarobjects.moduledescription[v]
      --  sidebarobjectstemp.modulelogo[index] = sidebarobjects.modulelogo[v]
      --  sidebarobjectstemp.moduleoptions[index] = sidebarobjects.moduleoptions[v]
      --  sidebarobjectstemp.moduletables[index] = sidebarobjects.moduletables[v]
      --end
      --sidebarobjects = sidebarobjectstemp

      -- does not work rn, sorry :c


      local sidebarobjectsindex = 1
      local oldAuthor = "z" -- z, as it is the last letter
      local parentName = "sidebarscrollarea"

      local placeholderName = parentName .. ".placeholder"
      widget.addChild(parentName, {
        type = "image",
        file = "/assetmissing.png",
        zlevel = 5,
        maxSize	= {0,0},
        position = {0, 0}
      }, placeholderName)

      for i = 1, moduleindex do
        sb.logInfo("Author: " .. sidebarobjects.authorname[i])
        sb.logInfo("name: " .. sidebarobjects.modulename[i])
        if oldAuthor ~= sidebarobjects.authorname[i] then

          local size = root.imageSize("/neon/starloader/core/starhub/gui/arrow-down.png")
          size[1] = size[1] / 2
          size[2] = size[2] / 2
          local arrowName = parentName .. ".arrow" .. sidebarobjectsindex
          widget.addChild(parentName, {
            type = "image",
            file = "/neon/starloader/core/starhub/gui/arrow-down.png?scalenearest=" .. math.min(20 / size[1], 20 / size[2]),
            zlevel = 5,
            maxSize	= {20,20},
            position = {20, 10 + 40*-sidebarobjectsindex - 2}
          }, arrowName)
        
          local authorName = parentName .. ".author" .. sidebarobjectsindex
          widget.addChild(parentName, {
              type = "label",
              value = sidebarobjects.authorname[i],
              zlevel = 5,
              fontSize = 15,
              position = {60, 10 + 40*-sidebarobjectsindex}
          }, authorName)
          sb.logInfo("nya: " .. sidebarobjectsindex)
          oldAuthor = sidebarobjects.authorname[i]
          sidebarobjectsindex = sidebarobjectsindex + 1
        end
        local size = root.imageSize("/neon/starloader/core/starhub/gui/slider-on.png")
        size[1] = size[1] / 2
        size[2] = size[2] / 2
        local sliderName = parentName .. ".slider" .. sidebarobjectsindex
        widget.addChild(parentName, {
          type = "image",
          file = "/neon/starloader/core/starhub/gui/slider-on.png?scalenearest=" .. math.min(20 / size[1], 20 / size[2]),
          zlevel = 5,
          maxSize	= {20,20},
          position = {20, 10 + 40*-sidebarobjectsindex - 2}
        }, sliderName)
      
        local moduleName = parentName .. ".module" .. sidebarobjectsindex
        widget.addChild(parentName, {
            type = "label",
            value = sidebarobjects.modulename[i],
            zlevel = 5,
            fontSize = 15,
            position = {60, 10 + 40*-sidebarobjectsindex}
        }, moduleName)
        sb.logInfo("nya: " .. sidebarobjectsindex)
        sidebarobjectsindex = sidebarobjectsindex + 1
      end
    end
    --createWidgets("sidebarscrollarea",40)

    starhubstaticloaded = true
  end
end


function init()
  firstupdate = true
end


function displayed()
  firstupdate = false
end


function createTooltip(screenPosition)
end


local function scan_x(x, i, step)
  if i < 1 then
    if widget.getChildAt({x, 0}) then
      return x
    end
    return x - step
  end
  local child = widget.getChildAt({x, 0})
  if child then
    return scan_x(x + i, i / 2, step)
  end
  return scan_x(x - i, i / 2, -step)
end

local function scan_y(y, i, step)
  if i < 1 then
    if widget.getChildAt({0, y}) then
      return y
    end
    return y - step
  end
  local child = widget.getChildAt({0, y})
  if child then
    return scan_y(y + i, i / 2, step)
  end
  return scan_y(y - i, i / 2, -step)
end

function update(dt)
  if not slMainConf then
    slMainConf = os.__slmainconf
  end
  if not slModuleConf then
    slModuleConf = os.__slmoduleconf
  end
  if firstupdate then
    local scx = scan_x(screen_size_max[1], screen_size_max[1] / 2, -1)
    local scy = scan_y(screen_size_max[2], screen_size_max[2] / 2, -1)
    if scx < min_valid_resolution[1] then scx = min_valid_resolution[1] end
    if scy < min_valid_resolution[2] then scy = min_valid_resolution[2] end
    if screen_size_x == scx and screen_size_y == scy then
      firstupdate = false
    end
    if scx > screen_size_max[1] then scx = screen_size_max[1] end
    if scy > screen_size_max[2] then scy = screen_size_max[2] end
    screen_size_x = scx
    screen_size_y = scy
  end
  timer = timer + dt
  if timer >= check_interval then
    timer = 0
    local ToSmall = widget.getChildAt({screen_size_x-1, screen_size_y-1})
    local ToBig = widget.getChildAt({screen_size_x+1, screen_size_y+1})
    if ToSmall and not ToBig then
    else
      firstupdate = true
      starhubstaticloaded = false
    end
  end


  if screen_size_x > 0 and screen_size_y > 0 and firstupdate == false then
    populate()
  end
end


function cursorOverride(screenPosition)
  return "/neon/starloader/core/starhub/gui/cursor/neon.cursor"
end


function dismissed()
end


function uninit()
end


function compare(a,b)
  return a < b
end


-- Function to create widgets
function createWidgets(parentName, numWidgets)
  -- Loop to create the specified number of widgets
  local placeholderName = parentName .. ".placeholder"
  widget.addChild(parentName, {
    type = "image",
    file = "/assetmissing.png",
    zlevel = 5,
    maxSize	= {0,0},
    position = {0, 0}
  }, placeholderName)

  for i = 1, numWidgets do

    local size = root.imageSize("/neon/starloader/core/starhub/gui/slider-on.png")
    size[1] = size[1] / 2
    size[2] = size[2] / 2
    local sliderName = parentName .. ".slider" .. i
    widget.addChild(parentName, {
      type = "image",
      file = "/neon/starloader/core/starhub/gui/slider-on.png?scalenearest=" .. math.min(20 / size[1], 20 / size[2]),
      zlevel = 5,
      maxSize	= {20,20},
      position = {20, 10 + 40*-i - 2}
    }, sliderName)

    local labelName = parentName .. ".label" .. i
    widget.addChild(parentName, {
        type = "label",
        value = "TestModule " .. i,
        zlevel = 5,
        fontSize = 15,
        position = {60, 10 + 40*-i}
    }, labelName)
  end
end