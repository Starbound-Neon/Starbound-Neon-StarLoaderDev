local screen_size_x = math.ceil(1730)--1680 / 2)--1730
local screen_size_y = math.ceil(685)--987 / 2)--685
local screen_size_max = {9600,4320}--root.imageSize(config.getParameter("gui.background.fileBody"))
local firstupdate = true

local function populate()
  widget.setImage("back", "/neon/starloader/core/starhub/gui/pixel.png?multiply=000000BB?scalenearest=" .. screen_size_max[1] .. ";" .. screen_size_max[2])
  
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
end


function displayed()
  firstupdate = true
end


function createTooltip(screenPosition)
end


function update(dt)
  local getChildAt = widget.getChildAt

  local function scan_x(x, i)
    if i < 1 then
      if getChildAt({x, 0}) then
        return x
      end
      return x - 1
    end
    if getChildAt({x, 0}) then
      return scan_x(x + i, i / 2)
    end
    return scan_x(x - i, i / 2)
  end
  local function scan_y(y, i)
    if i < 1 then
      if getChildAt({0, y}) then
        return y
      end
      return y - 1
    end
    if getChildAt({0, y}) then
      return scan_y(y + i, i / 2)
    end
    return scan_y(y - i, i / 2)
  end
  if firstupdate then
    local screen_size_x = scan_x(screen_size_max[1], screen_size_max[1] / 2)
    local screen_size_y = scan_y(screen_size_max[2], screen_size_max[2] / 2)
    if screen_size_x < 1 then screen_size_x = 1 end
    if screen_size_y < 1 then screen_size_y = 1 end
    firstupdate = false
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
