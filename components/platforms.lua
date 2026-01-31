local platform = class_base:extend()

function platform:new(type_, x, y )
    self.x = x
    self.y = y

    self.w = 1
    self.h = 1

    self.type = type

    self.is_v = type_ == "v" and 0 or 1
    self.is_h = type_ == "h" and 0 or 1

    self.move_x = type_ == "h" and 1 or 0
    self.move_y = type_ == "v" and 0 or 1


    self.size = 1
    self.speed_ = 1

    self.player_on = false
end

function platform:set_size(size)
  self.size = size
  self.w = math.max((is_h * size), 1) * g.var.CELL_W
  self.h = math.max((is_v * size), 1) * g.var.CELL_H
end

function platform:to_grid(x,y)
  return {x= math.floor(x/g.var.CELL_W),y=math.floor(y/g.var.CELL_H) }
end

function platform:update()
  self.x = self.x + self.move_x * self.speed_
  self.y = self.y + self.move_y * self.speed_

  local p1_grid = self:to_grid(self.x,self.y)

  if g.var.room.hitboxes[p1_grid.y][p1_grid.x]:match("[^we]") then
     self.speed_ = self.speed_* -1
     return
  end

  local p2_x = self.x + self.w
  local p2_y = self.y + self.h

  local p2_grid = self:to_grid(p2_x,p2_y)
  if g.var.room.hitboxes[p1_grid.y][p1_grid.x]:match("[^we]") then
    self.speed_ = self.speed_ * -1
    return
  end

end  

function platform:draw()
  love.graphics.setColor(150,0,150)
  love.graphics.rectangle("fill",self.x, self.y, self.w, self.h)
end

function platform:collides(obj)


end
