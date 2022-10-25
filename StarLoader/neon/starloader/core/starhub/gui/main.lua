
function init()
end


function displayed()
  firstrun = true
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

  --local screen_size_max = root.imageSize(config.getParameter("gui.background.fileBody"))
  local screen_size_x = 1000--scan_x(screen_size_max[1], screen_size_max[1] / 2)
  local screen_size_y = 800--scan_y(screen_size_max[2], screen_size_max[2] / 2)

  if screen_size_x > 0 and screen_size_y > 0 and firstrun == true then
    firstrun = false
    
    pane.addWidget({
      zlevel = 0,
      type = "image",
      file = "/neon/starloader/core/starhub/gui/pixel.png?multiply=000000BF?scalenearest=" .. screen_size_x .. ";" .. screen_size_y
    })
    
    local sidebar_width = math.min(700, screen_size_x / 3)

    pane.addWidget({
      zlevel = 1,
      type = "image",
      file = "/neon/starloader/core/starhub/gui/pixel.png?multiply=0000007F?scalenearest=" .. sidebar_width .. ";" .. screen_size_y
    })
  end
end


function cursorOverride(screenPosition)
  return "/neon/starloader/core/starhub/gui/cursor/neon.cursor"
end


function dismissed()
end


function uninit()
end
