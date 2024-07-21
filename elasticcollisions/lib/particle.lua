-- converted to lua/seamstress from daniel shiffman's nature of code (new edition)
-- version0.1 @jaseknighter
--
-- https://thecodingtrain.com/challenges/184-elastic-collisions
-- https://editor.p5js.org/codingtrain/sketches/z8n19RFz9

local particle ={}

width=500
height=500
particle.__index = particle

function particle.new(x, y, mass, id)
  local p = {}
  p.position = vector:new(x,y)
  p.velocity = vector:new(math.random(),math.random())
  p.velocity:mult(vector:new(0.1,5))
  p.acceleration = vector:new(0,0)
  p.mass = mass
  p.r = math.sqrt(p.mass) * 2
  p.id = id
  -- set the screen level here
  setmetatable(p, particle)
  return p
end

function particle:apply_force(force)
  f = vector:new(impact_vector.x,impact_vector.y)
  f:div(self.mass)
  self.accelleration:add(f)
end

-- function to update position
function particle:update()
  self.velocity:add(self.acceleration)
  self.position:add(self.velocity)
  self.acceleration:mult(0)
end

-- collision detection and resolution
function particle:collide(other)
  local impact_vector = vector:new(other.position.x,other.position.y)
  impact_vector:subtract(self.position)
  d = impact_vector:get_mag()
  if d < self.r + other.r then
    local overlap = d - (self.r + other.r)
    local dir = vector:new(impact_vector.x,impact_vector.y)
    dir:set_mag(overlap * 0.5)
    self.position:add(dir)
    other.position:subtract(dir)

    -- correct the distance!
    d = self.r + other.r
    impact_vector:set_mag(d)

    local m_sum = self.mass + other.mass
    local v_diff = vector:new(other.velocity)
    v_diff:subtract(self.velocity)
    
    -- particle a (self)
    local numerator = v_diff:dot(impact_vector)
    local denominator = m_sum * d* d
    local delta_va = vector:new(impact_vector.x,impact_vector.y)
    delta_va:mult((2 * other.mass * numerator) / denominator)
    self.velocity:add(delta_va)

    -- particle b (other)
    local delta_vb = vector:new(impact_vector.x,impact_vector.y)
    delta_vb:mult((-2 * self.mass * numerator) / denominator)
    other.velocity:add(delta_vb)
  end
end

-- bounc edges
function particle:edges()
  if self.position.x > width - self.r then
    self.position.x = width - self.r
    self.velocity.x = self.velocity.x * -1
  elseif self.position.x < self.r then
    self.position.x = self.r
    self.velocity.x = self.velocity.x * -1
  end

  if self.position.y > height - self.r then
    self.position.y = height - self.r
    self.velocity.y = self.velocity.y * -1
  elseif self.position.y < self.r then
    self.position.y = self.r
    self.velocity.y = self.velocity.y * -1
  end
end

-- function to display
local cr = 51
local cg = 188
local cb = 255

function particle:show(multx,multy)
  screen.color(cr,cg,cb)
  screen.move(math.floor(self.position.x), math.floor(self.position.y))
  screen.circle(self.r)
end


return particle