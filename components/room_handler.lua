local room_handler = class_base:extend()

---@class Room
function room_handler:new(name)
  self.hitboxes = {}

  self.platforms = {}
  self.buttons = {}
  self.objects = {}

  self.ports ={}
  self.info = {}

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

function room_handler:_room_layout(line)
  local floor_lu ={ floor = "f", empty ="e", water = "w" ,lava ="l"  }

    local row = {}
    local default_floor = floor_lu[self.info[type] or "floor"]

    local tok_cnt = 0
    for tok in line:gmatch(".") do
      tok_cnt = tok_cnt +1
        if tok == " " then
            table.insert(row, default_floor)
        elseif tok == "w" then
          table.insert(row,"w")
        elseif tok == "#" then
            table.insert(row, "#")
        elseif tok == "p" then
            self.player_pos ={ tok_cnt, #self.hitboxes +1  }
            --set player position info
            table.insert(row, default_floor)
        elseif tok:match("%d") then
            table.insert(row, default_floor)
        else
          print("unknown tile found: ",tok)
            table.insert(row, default_floor)
        end
    end

    table.insert( self.hitboxes ,row)
end


function room_handler:_room_meta(line)
  key, value = line:match("(.-)=(.*)")
  self.info[key] = value
end


function room_handler:_ports(line)
  local entrance_coord={
    s={0,-1},n={0,1},e={1,0},w={-1,0}
  }
  
  local raw_list = self:__csv(line)
  local port_info = {
        id = raw_list[1],
        connected_room = raw_list[2],
        connected_id = raw_list[3],
        entrance = entrance_coord[raw_list[4]]
    }

  self.ports[port_info.id] = port_info
end

function room_handler:_platforms(line)
    local raw_list = self:__csv(line)
    local platform = {
    id = raw_list[1]
  }

  -- self.platforms[platform.id].speed = raw_list[2]
  -- self.platforms[platform.id].size = raw_list[3]
  -- self.platforms[platform.id].min = raw_list[4]
  -- self.platforms[platform.id].max = raw_list[5]
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

  cur_mode = ""
  for line in love.filesystem.lines("assets/rooms/"..name..".rm") do
    parser_switch = string.match(line, "==(.*)")
    if parser_switch ~= nil then
      cur_mode = parser_switch
      print("switching to: " .. cur_mode)
    else
      print(line)
      parsers[cur_mode](self, line)
    end
  end
end




function room_handler:update()
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
            g.lib.colors.fg_set(color_lu[cell])

            love.graphics.rectangle("fill", x * g.var.CELL_W, y * g.var.CELL_H, g.var.CELL_W, g.var.CELL_H)
            if g.var.debug.show_grid then
                g.lib.colors.fg_set("black")
                love.graphics.rectangle("line", x * g.var.CELL_W, y * g.var.CELL_H, g.var.CELL_W, g.var.CELL_H)
            end
        end
    end
  g.lib.colors.reset()
end

--NOTE: spacemacs evile replace mode : R

return room_handler
