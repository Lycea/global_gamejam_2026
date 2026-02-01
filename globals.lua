local g = {}

g.helpers = require("helper.helpers")

g.lib={}

g.lib.console = require("helper.console")
g.lib.timer = require("helper.timer")

g.lib.room_handler = require("components.room_handler")

g.obj = {}
g.obj.platform = require("components.platforms")
g.obj.player = require("components.player")
g.obj.button = require("components.button")
g.obj.button_door = require("components.button_door")

g.lib.colors = require("helper.colors")
local col = g.lib.colors

col.add("black", { 0, 0, 0 })
col.add("grey", { 50, 50, 50 })
col.add("red", { 255, 0, 0 })
col.add("blue", { 0, 0, 255 })
col.add("yellow", { 255, 255, 0 })
col.add("green", { 0, 255, 0 })

g.var = {}
g.var.player = {} ---@type player
g.var.room ={} ---@type Room

g.var.CELL_W = 24
g.var.CELL_H = 24


--
g.var.debug ={}
g.var.debug.show_grid = false
return g



