--- !doctype module

--- @class loader
local loader ={}

function loader.loadTiles(file, width, height)
  --not sure if line is needed could be done as temp
  --tilesets_img[count+1]= gr.newImage(file

  local image = love.graphics.newImage(file)

  -- get hight / width of the tile atlas // image
  local img_h = image:getHeight()
  local img_w = image:getWidth()

  height = height or img_h
  width = width or img_w

  -- calc rows /lines
  local rows = math.floor(img_h / height)
  local cols = math.floor(img_w / width)

  local count = 1

  local quadset = {}

  local x_ = 0
  local y_ = 0


  --set also the image to the set ~
  quadset["image"] = image

  for i = 1, rows do
    quadset[i] = {}
    for j = 1, cols do
      quadset[i][j] = love.graphics.newQuad(x_, y_, width, height, img_w, img_h)
      count = count + 1
      x_ = x_ + height
    end
    x_ = 0
    y_ = y_ + height
  end

  return quadset
end

--- @return loader
return loader
