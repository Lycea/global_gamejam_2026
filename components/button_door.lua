local button = class_base:extend()

function button:new( x, y)
    self.pos = { x = x, y = y }
    self.w = 16
    self.h = 16

    self.closed =true
end

function button:update()
  local active_btns = 0
    for _, btn in pairs(g.var.room.buttons) do
        if btn.is_active then
            active_btns = active_btns + 1
        end
    end
  if active_btns == #g.var.room.buttons then
     self.closed = true
     g.var.room.hitboxes[self.pos.y/g.var.CELL_H][self.pos.x/g.var.CELL_W]="f"
  end
end

function button:draw()
end

return button
