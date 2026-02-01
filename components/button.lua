local button = class_base:extend()

function button:new(timed, x, y)
    self.pos = { x = x, y = y }
    self.w = 16
    self.h = 16

    self.timed = timed
    self.timer = g.lib.timer(5)
    
    self.is_active = false
    self.rect = {p1={},p2={}}
end

function button:update()
  if not self.active then
    
  end
  self.rect.p1, self.rect.p2 = g.helpers.rect_to_points({x=self.pos.x,y=self.pos.y,h=self.h,w=self.w})
  g.var.player:calc_rect()

  local tmp_p = g.var.player
  local collides = g.helpers.rect_collision_tables(self.rect.p1, self.rect.p2, tmp_p.rect.p1, tmp_p.rect.p2)

  if collides then
    self.is_active = true
    self.timer = g.lib.timer(5)
  end

  if self.is_active and self.timed then
    if self.timer:check() then
      self.is_active = false
    end
  end
end

function button:draw()
  gr = love.graphics
  col = g.lib.colors

  col.fg_set("grey")
  gr.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

  if self.timed then
    col.fg_set(self.is_active and "yellow" or "red")
    gr.rectangle("fill", self.pos.x + 3, self.pos.y + 3, self.w - 6, self.h - 6)
  else
    col.fg_set(self.is_active and "green" or "red")
    gr.rectangle("fill",self.pos.x + 3,self.pos.y +3 ,self.w -6,self.h -6)
  end
  col.reset()
end

return button
