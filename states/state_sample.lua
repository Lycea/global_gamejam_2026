local sample_state =class_base:extend()


function sample_state:new()

    
    print("initialised!!")
end




function sample_state:startup()
  g.var.room = g.lib.room_handler("start",true)
  g.var.player = g.obj.player(0,0,16,16)
end





function sample_state:draw()
  g.var.room:draw()
  g.var.player:draw()
end




function sample_state:update(dt)
    g.var.room:update(dt)
    g.var.player:update(dt)
end

function sample_state:shutdown()
    
end





return sample_state()
