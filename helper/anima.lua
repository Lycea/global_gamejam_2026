print("finding components base path ...")
local BASE = (...) .. '.'
print(BASE)
local i = BASE:find("anima.$")
print(i)
local BASE = BASE:sub(1, i - 1)
print(BASE)


--- !doctype module


--- @module "load_helper"
local loader = require(BASE.."load_helper")



local anima = class_base:extend()

--anima libera ...
--- @class anima
function anima:new()
  self.__loaded_files = {}
  self.__anims = {}
end

function anima:load_file(file_path, name, options)
  self.__loaded_files[name] = loader.loadTiles(file_path, options.w, options.h)
end

function anima:set_loaded(obj, name)
    if self.__loaded_files[name] ~= nil then
        print("warning: " .. name .. " already loaded")
        return
    end

    self.__loaded_files[name]=obj
end


function anima:update(dt)
    for _, sub in pairs(self.__anims) do
    if sub.timer:check() then
            sub.cur_frame = sub.cur_frame + 1
      if sub.cur_frame > sub.frame_end then
        sub.cur_frame = sub.frame_start
      end
    end
  end
end

---@description draws cur frame to pos
function anima:draw(anim_name, pos)
    sub_thing = self.__anims[anim_name]
    love.graphics.draw(self.__loaded_files[sub_thing.q_name].image,
                       self.__loaded_files[sub_thing.q_name][sub_thing.quad_y][sub_thing.cur_frame],
                       pos.x,pos.y )
end

--- @description sample structure
-- <name>,<q_y>,{<start>,<end>},<f_time>
-- s={
--   {
--     "walk",{1},{1,5},{0.2}
--   },
--   {
--     "run",{2},{1,3},{0.1}
--   }
-- }
--- @param base_name string
--- @param sub_info_table table
function anima:gen_animations(base_name, sub_info_table)

  if self.__loaded_files[base_name] == nil then
    print("Did not find quad set with name " .. base_name)
    return false
  end

    for _, sub_struct in pairs(sub_info_table) do
     print(sub_struct[1], sub_struct[2],sub_struct[3],sub_struct[4])
    self.__anims[sub_struct[1]] = {
      quad_y = sub_struct[2],
      frame_start = sub_struct[3][1],
      frame_end = sub_struct[3][2],
      anim_speed = sub_struct[4],
      timer = g.lib.timer(sub_struct[4]),
            cur_frame = sub_struct[3][1],
      q_name = base_name
    }
  end
end

---@return anima
return anima
