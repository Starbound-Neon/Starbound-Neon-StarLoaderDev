local screen_size_x = math.ceil(1730)--1680 / 2)--1730
local screen_size_y = math.ceil(685)--987 / 2)--685
local screen_size_max = {9600,4320}--root.imageSize(config.getParameter("gui.background.fileBody"))
local min_valid_resolution = {100,100}
local firstupdate = true
local check_interval = 1 -- check every 5 seconds
local timer = 0

local function populate()
  widget.setImage("back", "/neon/starloader/core/starhub/gui/pixel.png?multiply=000000BB?scalenearest=" .. 9600 .. ";" .. 4320)
  
  local sidebar_width = math.min(350, screen_size_x / 3)
  local label_length = math.min(100, screen_size_y / 8)
  local label_content = label_length - 20

  widget.setImage("sidebar", "/neon/starloader/core/starhub/gui/pixel.png?multiply=000000BB?scalenearest=" .. sidebar_width .. ";" .. screen_size_y)

  widget.setImage("sidebar_header", "/neon/starloader/core/starhub/gui/pixel.png?multiply=000000FF?scalenearest=" .. sidebar_width .. ";" .. label_length)
  widget.setPosition("sidebar_header", {0,(screen_size_y - label_length)})

  local size = root.imageSize("/neon/starloader/core/starhub/gui/starhub.png")
  size[1] = size[1] / 2
  size[2] = size[2] / 2

  widget.setImage("sidebar_logo", "/neon/starloader/core/starhub/gui/starhub.png?scale=" .. math.min((sidebar_width - 20) / size[1], label_content / size[2]))
  
  local adjustedsize = size[1] * math.min((sidebar_width - 20) / size[1], label_content / size[2])

  widget.setPosition("sidebar_logo", {((sidebar_width - adjustedsize) / 2),(screen_size_y - label_length + 10)})

  widget.setImage("sidebar_footer", "/neon/starloader/core/starhub/gui/pixel.png?multiply=000000FF?scalenearest=" .. sidebar_width .. ";" .. label_length)

  widget.setImage("separator", "/neon/starloader/core/starhub/gui/line.png?multiply=00000000?scale=" .. 1 .. ";" .. screen_size_y / 2) --?multiply=00000000
  widget.setPosition("separator", {sidebar_width, 0})
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
