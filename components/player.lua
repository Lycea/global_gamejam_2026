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

  self.on_object = false

  self.last_dir ={ x=0,y=-1}
end


function getTouchedTiles(x, y, w, h, tileSize)
  local tiles  = {}

  local left   = math.floor(x / tileSize)
  local right  = math.floor((x + w - 1) / tileSize)
  local top    = math.floor(y / tileSize)
  local bottom = math.floor((y + h - 1) / tileSize)

  -- If rectangle is fully inside ONE tile
  if left == right and top == bottom then
    tiles[1] = { x = left, y = top }
    return tiles
  end

  -- Otherwise, collect all overlapped tiles
  for tx = left, right do
    for ty = top, bottom do
      table.insert(tiles, { x = tx, y = ty })
    end
  end

  return tiles
end

function player:update()
  local new_x = self.pos.x + movement.x
  local new_y = self.pos.y + movement.y

  -- if g.var.map:check_collision({ x = new_x, y = new_y, width = self.width, height = self.height }) == false then
  --   self.pos.x = new_x
  --   self.pos.y = new_y
  -- end
  local tiles = getTouchedTiles(new_x, new_y, self.width, self.width, g.var.CELL_W)

  local death_tiles = 0
  local wall_tiles = 0
  local port_tiles = 0

    for _, tile in pairs(tiles) do
        death_tiles = death_tiles + (g.var.room:check_death(tile) and 1 or 0)
        port_tiles = port_tiles + (g.var.room:check_port(tile) and 1 or 0)
        wall_tiles = wall_tiles + (g.var.room:is_wall(tile) and 1 or 0)
    end
  
  print("port_tiles:",port_tiles,#tiles)

  if death_tiles == #tiles and self.on_object == false then
    if g.var.room:on_object(self.pos.x, self.pos.y, self.width, self.height) == false then
      print("reset placement")
      self.pos.x = self.pos.x - movement.x * g.var.CELL_W
      self.pos.y = self.pos.y - movement.y * g.var.CELL_H
      return
    else
      -- TODO insert platform case !
    end
  end

    if wall_tiles == 0 and port_tiles >= 1 then
        --find port tile:
      local port_id = -1
      for i, tile  in pairs(tiles) do
        if g.var.room:check_port(tile) then
                port_id = g.var.room.hitboxes[tile.y][tile.x]
                print("PORT ID FOUND", port_id)
                break
        end
      end

      print("switch rooms ~")
        g.var.room:switch(port_id)
      return
  end


    if wall_tiles == 0 then
      self.pos.x = new_x
      self.pos.y = new_y
    end
  -- self.pos.x = new_x
  -- self.pos.y = new_y

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
