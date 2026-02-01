local room_handler = class_base:extend()

---@class Room
function room_handler:new(name)
  self.hitboxes = {}

  self.platforms = {}
  self.buttons = {}
  self.objects = {}

  self.ports ={}
  self.info = {}

  self.__parser_line_count = 1

  self:load_room(name,true)
end

-----------------
-- PARSER HELPERS

function room_handler:__csv(line)
  local val_list ={}
    for value in line:gmatch("[^,]+") do
        print(value)
        table.insert(val_list , value)
    end
 return val_list 
end

function room_handler:_room_layout(line,y)
  local floor_lu ={ floor = "f", empty ="e", water = "w" ,lava ="l"  }

    local row = {}
    local default_floor = floor_lu[self.info[type] or "floor"]

    local tok_cnt = 0
    for tok in line:gmatch(".") do
      tok_cnt = tok_cnt +1
        if tok == " " then
            table.insert(row, default_floor)
        elseif tok == "w" or tok == "e"  then
          table.insert(row,tok)
        elseif tok == "#" then
            table.insert(row, "#")
        elseif tok == "v" or tok == "h" then
            table.insert(row, "e")
            table.insert(self.platforms,
                g.obj.platform(tok, tok_cnt * g.var.CELL_W
                                         ,self.__parser_line_count * g.var.CELL_H)  )
        elseif tok == "p" then
            self.player_pos ={ tok_cnt, #self.hitboxes +1  }
            --set player position info
            table.insert(row, default_floor)
        elseif tok == "b" or tok == "B" then --buttons
          print("adding button:  ",tok)
          table.insert(self.buttons,
                       g.obj.button(tok == "b", tok_cnt * g.var.CELL_W, self.__parser_line_count * g.var.CELL_H))
            table.insert(row,default_floor)
        elseif tok:match("%d") then
            table.insert(row, tok)
            self.ports[tok] = {
                x = tok_cnt,
                y = self.__parser_line_count
            }
        else
          print("unknown tile found: ",tok)
            table.insert(row, default_floor)
        end
    end

    table.insert(self.hitboxes, row)
    self.__parser_line_count = self.__parser_line_count +1
end


function room_handler:_room_meta(line,y)
  key, value = line:match("(.-)=(.*)")
  self.info[key] = value
end


function room_handler:_ports(line,y)
  local entrance_coord={
    s={0,1},n={0,-1},e={1,0},w={-1,0}
  }
  
  local raw_list = self:__csv(line)
  -- local port_info = {
  --       id = raw_list[1],
  --       connected_room = raw_list[2],
  --       connected_id = raw_list[3],
  --       entrance = entrance_coord[raw_list[4]]
  --   }
  local id = raw_list[1]

  self.ports[id].id = id
  self.ports[id].connected_room = raw_list[2]
  self.ports[id].connected_id = raw_list[3]
  self.ports[id].entrance = entrance_coord[ raw_list[4] ]
end

function room_handler:_platforms(line,y)
    local raw_list = self:__csv(line)
    local id = tonumber( raw_list[1] )

    self.platforms[id].speed = raw_list[2]
    self.platforms[id]:set_size( raw_list[3] )
end

-----------------
-- ROOM FUNCTIONS

function room_handler:load_room(name,is_start)

  parsers = {
      layout = self._room_layout,
      meta = self._room_meta,
      rooms = self._ports,
      platform = self._platforms
    }
  print("loading room...", name)


  local full_path = "assets/rooms/" .. name .. ".rm"
  info = love.filesystem.getInfo(full_path)
  print(info)
  -- for k, v in pairs(info) do
  --     print(k, v)
  -- end
  if info == nil then
    print("room does not exist !!!")
    return false
  end

  if is_start == true then 
    cur_mode = ""
    for line in love.filesystem.lines("assets/rooms/" .. name .. ".rm") do
      parser_switch = string.match(line, "==(.*)")
      if parser_switch ~= nil then
        cur_mode = parser_switch
        print("switching to: " .. cur_mode)
      else
        print(line)
        parsers[cur_mode](self, line)
      end
    end
    if self.player_pos then
      g.var.player.pos.x = self.player_pos.x
      g.var.player.pos.y = self.player_pos.y
    end
  else
    return g.lib.room_handler(name)
  end
end


function room_handler:switch(id)

  print("---------------------------")
  print("switching out rooms...")
  local new_room = self:load_room(self.ports[id].connected_room)
  local exit_port = new_room.ports[self.ports[id].connected_id]
  print("exit_port:", exit_port.x, exit_port.y)
  print("entrances:", exit_port.entrance[1],exit_port.entrance[2])
  print("old player pos:", g.var.player.pos.x, g.var.player.pos.y)
  
  g.var.player.pos.x = (exit_port.x + exit_port.entrance[1] ) * g.var.CELL_W
  g.var.player.pos.y = (exit_port.y + exit_port.entrance[2] ) * g.var.CELL_H

  print("new player pos:", g.var.player.pos.x, g.var.player.pos.y)
  self = new_room
  print("switch done")
  print("---------------------------")

  return new_room
end

function room_handler:update()
  for i,platform in pairs(self.platforms) do
    platform:update()
  end

  for i,button in pairs(self.buttons) do
    button:update()
  end
end

-- x /y coordinates
function room_handler:is_wall(p)
  return self.hitboxes[p.y][p.x] == "#"
end

function room_handler:check_death(p)
    local g_val = self.hitboxes[p.y][p.x]
    if g_val == "e" or g_val == "w" or g_val == "l" then
        return true
    end
    return false
end

function room_handler:check_port(p)
  if self.hitboxes[p.y][p.x]:match("%d") then
    return true
  end
  return false
end

function room_handler:on_object(obj)
 -- TODO: do real collision test and connect player to plattform 
  for i, platform in pairs(self.platforms) do
        if platform:collides(obj) then
            return true
        end
    end

    for i, object in pairs(self.objects) do

    end

    return false
end

local color_lu = {
  ["#"] = "red",
   f = "grey",
   w = "blue",
   e = "black"
}
function room_handler:draw()
    for y, row in ipairs(self.hitboxes) do
        for x, cell in ipairs(row) do
            g.lib.colors.fg_set(color_lu[cell] or color_lu["f"] )

            love.graphics.rectangle("fill", x * g.var.CELL_W, y * g.var.CELL_H, g.var.CELL_W, g.var.CELL_H)
            if g.var.debug.show_grid then
                g.lib.colors.fg_set("black")
                love.graphics.print(cell,x*g.var.CELL_W, y*g.var.CELL_H)
                love.graphics.rectangle("line", x * g.var.CELL_W, y * g.var.CELL_H, g.var.CELL_W, g.var.CELL_H)
            end
        end
    end
    g.lib.colors.reset()
    for i, platform in pairs(self.platforms) do
        platform:draw()
    end

    for i, button in pairs(self.buttons) do
      button:draw()
    end
end

--NOTE: spacemacs evile replace mode : R

return room_handler
