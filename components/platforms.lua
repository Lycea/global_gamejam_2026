local platform = class_base:extend()

function platform:new(type_, x, y )
  self.p1_grid ={x=0,y=0}
  self.p2_grid = { x = 0, y = 0 }

  self.x = x
  self.y = y

  self.w = 1
  self.h = 1

  self.rect ={p1={},p2={}}

  self.type = type_

  self.is_v = type_ == "v" and 1 or 0
  self.is_h = type_ == "h" and 1 or 0

  self.move_x = type_ == "h" and 1 or 0
  self.move_y = type_ == "v" and 1 or 0
    self.size = 1
    self.speed_ = 1

    self.player_on = false
end

function platform:set_size(size)
  self.size = size
  self.w = math.max((self.is_h * size), 1) * g.var.CELL_W
  self.h = math.max((self.is_v * size), 1) * g.var.CELL_H
end

function platform:to_grid(x,y)
  return {x= math.floor(x/g.var.CELL_W),y=math.floor(y/g.var.CELL_H) }
end

function platform:update()
  self.x = self.x + self.move_x * self.speed_
  self.y = self.y + self.move_y * self.speed_

  self.p1_grid = self:to_grid(self.x,self.y)

  -- print("platform pos:", self.x, self.y)
  -- print("platform grid:",p1_grid.x,p1_grid.y)


  -- check player on platform
  self.rect.p1 , self.rect.p2 = g.helpers.rect_to_points(self)
  g.var.player:calc_rect()

  local tmp_p = g.var.player
  local collides=g.helpers.rect_collision_tables(self.rect.p1,self.rect.p2,tmp_p.rect.p1,tmp_p.rect.p2)

  if collides then
    print("colliding with player !(move player)")
    local tmp_x = tmp_p.pos.x + self.move_x * self.speed_
    local tmp_y = tmp_p.pos.y + self.move_y * self.speed_
    
    if tmp_p:check_wall_col({ x = tmp_x, y = tmp_y }) == false then
          tmp_p:set_pos(tmp_x, tmp_y)
    end
  end
  
  if g.var.room.hitboxes[self.p1_grid.y][self.p1_grid.x]:match("[^we]") then
     self.speed_ = self.speed_* -1
     return
  end

  local p2_x = self.x + self.w -1
  local p2_y = self.y + self.h -1

  self.p2_grid = self:to_grid(p2_x,p2_y)
  if g.var.room.hitboxes[self.p2_grid.y][self.p2_grid.x]:match("[^we]") then
    self.speed_ = self.speed_ * -1
    return
  end

end  

function platform:draw()
  love.graphics.setColor(150,0,150)
  love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

    if g.var.debug.show_grid then
        g.lib.colors.fg_set("green")
    love.graphics.rectangle("line", self.p1_grid.x * g.var.CELL_W, self.p1_grid.y * g.var.CELL_H, g.var.CELL_W,
      g.var.CELL_H)
    love.graphics.rectangle("line", self.p2_grid.x * g.var.CELL_W, self.p2_grid.y * g.var.CELL_H, g.var.CELL_W,
      g.var.CELL_H)
  end

  g.lib.colors.reset()
end

function platform:collides(obj)
  return g.helpers.rect_collision_tables(self.rect.p1, self.rect.p2, obj.rect.p1, obj.rect.p2)
end

return platform
