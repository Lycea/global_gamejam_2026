--- @class player
local player = class_base:extend()

gr = love.graphics

local function cell(num)
  return g.var.CELL_W * num
end

local function row(num)
  return g.var.CELL_H * num
end


function player:new(x, y,w,h)
  self.pos = { x = cell(3), y = row(3) }
  self.width = w
  self.height = h

  self.last_dir ={ x=0,y=-1}
end

function player:update()
  local new_x = self.pos.x + movement.x
  local new_y = self.pos.y + movement.y

  -- if g.var.map:check_collision({ x = new_x, y = new_y, width = self.width, height = self.height }) == false then
  --   self.pos.x = new_x
  --   self.pos.y = new_y
  -- end

  self.pos.x = new_x
  self.pos.y = new_y

  if movement.x ~= 0 or movement.y ~= 0 then
    self.last_dir.x, self.last_dir.y = movement.x, movement.y
  end

  movement.x = 0
  movement.y = 0

  
  -- self.pos.x = new_x
  -- self.pos.y = new_y
end

function player:draw()
  gr.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
  -- gr.rectangle("fill", self.pos.x + self.width / 4, self.pos.y - self.height / 2, self.width / 2, self.height / 2)

    gr.rectangle("fill",
                 self.pos.x + self.last_dir.x * self.width*2 + self.width/4,
                 self.pos.y + self.last_dir.y * self.height*2 + self.height/4, self.width/2, self.height/2)
end

return player
