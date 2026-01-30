-- !doctype module

--- @class color
local colors = {}
colors.list = {}

--- @param name string
--- @param color table
function colors.add(name,color)
  colors.list[name] = color
end

function colors.bg_set(name)
  local s_col = colors.list[name]
  love.graphics.setBackgroundColor(s_col[1],s_col[2],s_col[3])
end

function colors.fg_set(name)
  local s_col = colors.list[name]
  love.graphics.setColor(s_col[1], s_col[2], s_col[3])
end

function colors.reset()
	love.graphics.setColor(255,255,255,255)
end


--- @return color
return colors
