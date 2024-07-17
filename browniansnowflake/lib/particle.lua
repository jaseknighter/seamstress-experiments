-- particle class based on Daniel Shiffman's Coding Challenge 127: Brownian Motion Snowflake
-- https://thecodingtrain.com/CodingChallenges/127-brownian-snowflake.html
-- https://youtu.be/XUA8UREROYE
-- https://editor.p5js.org/codingtrain/sketches/SJcAeCpgE



local particle ={}

width=500
height=500
particle.__index = particle

function particle.new(radius, angle)
  local p = {}
  setmetatable(p, particle)
  p.pos = vector:new()
  p.pos = p.pos.from_angle(angle)
  p.pos:mult(radius)
  p.r = 4;
  return p
end

function particle:rotate(angle)
  self.pos = self.pos:rotate(angle)
end

function particle:update()
  self.pos.x = self.pos.x - 1
  self.pos.y = self.pos.y + math.random(-5,5)
  local angle = self.pos:heading()
  angle = util.clamp(angle, 0, math.pi/6)
  local magnitude = self.pos:get_mag()
  self.pos = vector:new()
  self.pos = self.pos.from_angle(angle)
  self.pos:set_mag(magnitude)
end

cr = 51
cg = 188
cb = 255

function particle:show(multx,multy)
  multx = multx or 1
  multy = multy or 1
  screen.color(cr,cg,cb)
  local x = (width/2)+self.pos.x*multx
  local y = (height/2)+self.pos.y*multy
  screen.move(math.floor(x), math.floor(y))
  screen.circle(self.r * 2)
end

function particle.distance(x1,y1,x2,y2)
  return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end

function particle:intersects(snowflake)
  local result = false
  if #snowflake == 0 then return result end
  for i=1,#snowflake do
    local s = snowflake[i]
    local d = self.distance(s.pos.x, s.pos.y, self.pos.x, self.pos.y) 
    if d < self.r * 2 then
      result = true
      break
    end
  end
  return result
end

function particle:finished()
  return self.pos.x < 1
end

return particle