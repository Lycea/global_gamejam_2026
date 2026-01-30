local helper = {}

function helper.random_point_in_cirle(base_pos, min_dist, max_dist)
  local dist = love.math.random(min_dist, max_dist)
  local angle = love.math.random(0, 360)
  -- Convert angle from degrees to radians
  local angle_rad = math.rad(angle)
  -- Calculate the new point
  local x2 = base_pos.x + dist * math.cos(angle_rad)
  local y2 = base_pos.y + dist * math.sin(angle_rad)

  return x2, y2
end

function helper.calculate_point(x1, y1, angle, distance)
    -- Convert angle from degrees to radians
    local angle_rad = math.rad(angle)
    -- Calculate the new point
    local x2 = x1 + distance * math.cos(angle_rad)
    local y2 = y1 + distance * math.sin(angle_rad)
    return x2, y2
end

function helper.lerp_(x, y, t)
  local num = x + t * (y - x)
  return num
end

function helper.lerp_point(x1, y1, x2, y2, t)
  local x = helper.lerp_(x1, x2, t)
  local y = helper.lerp_(y1, y2, t)
  --print(x.." "..y)
  return x, y
end


function helper.distance(self ,other)
  local dx = other.x-self.x
  local dy = other.y-self.y
  return math.sqrt(math.pow(dx,2)+math.pow(dy,2))
end

function helper.rect_collision(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2)
  -- Check if there is no overlap
  if ax2 < bx1 or ax1 > bx2 or ay2 < by1 or ay1 > by2 then
    return false     -- No collision
  end
  return true        -- Collision detected
end

function helper.rect_collision_tables(a1,a2,b1,b2)
  return helper.rect_collision(a1.x,a1.y, a2.x,a2.y,
                               b1.x,b1.y, b2.x,b2.y)
end

function helper.pos_size_to_two_points(pos,size)
  local pos2={x= pos.x + size.w,
              y= pos.y + size.h }
  return {pos,pos2}
end

function helper.circ_collision(x1, y1, r1, x2, y2, r2)
  -- Calculate the distance between the two centers
  local dx = x2 - x1
  local dy = y2 - y1
  local distance_squared = dx * dx + dy * dy
  local radii_sum = r1 + r2
  -- Compare the squared distance to the squared radii sum
  return distance_squared <= radii_sum * radii_sum
end


function helper.circ_point_collision(x1,y1,r1,x2,y2)
  if helper.distance({x=x1,y=y1},{x=x2,y=y2}) < r1 then
    return true
  end
    return false
end


function helper.circle_rectangle_collision(cx, cy, r, rx, ry, rw, rh)
  -- Find the closest point on the rectangle to the circle's center
  local closestX = math.max(rx, math.min(cx, rx + rw))
  local closestY = math.max(ry, math.min(cy, ry + rh))

  -- Calculate the squared distance between the circle's center and the closest point
  local dx = closestX - cx
  local dy = closestY - cy
  local distanceSquared = dx * dx + dy * dy

  -- Check if the distance is less than or equal to the circle's radius squared
  return distanceSquared <= r * r
end


function helper.getPointAtAngle(baseX, baseY, angle, distance)
  -- Convert angle from degrees to radians
  local angleRad = math.rad(angle)

  -- Calculate new coordinates
  local newX = baseX + distance * math.cos(angleRad)
  local newY = baseY + distance * math.sin(angleRad)

  return newX, newY
end

function helper.getVectorAtAngle(angle)
  -- Convert angle from degrees to radians
  local angleRad = math.rad(angle)

  -- Calculate vector components
  local vecX = math.cos(angleRad)
  local vecY = math.sin(angleRad)

  return vecX, vecY
end

function helper.progressbar(pos, w, h, p)
  local bar_w = w
  local border_w = bar_w + 1

  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.rectangle("fill", pos.x, pos.y, border_w, h)
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.rectangle("fill", pos.x + 1, pos.y + 1, bar_w, h - 2)
  love.graphics.setColor(255, 255, 255, 255)

  local full_width = bar_w
  --local rest_width = math.max(full_width - (full_width * 0.01) * 100 - p, 0)
  local rest_width = full_width * ((100 - p) / 100)

  love.graphics.rectangle("fill", pos.x + 1, pos.y + 1, rest_width, h - 2)
  love.graphics.setColor(255, 255, 255, 255)
end


return helper
