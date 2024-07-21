-- converted to lua/seamstress from daniel shiffman's nature of code (new edition)
-- version0.1 @jaseknighter
--
-- https://thecodingtrain.com/challenges/184-elastic-collisions
-- https://editor.p5js.org/codingtrain/sketches/z8n19RFz9


vector = include('lib/vector')
particle = include('lib/particle')
point,rectangle,circle,quadtree = include('lib/quadtree')

particles = {}
-- Making sure pairs of particles are not checked twice
checked_pairs = {}
palette = {
  {11, 106, 136},
  {45, 197, 244},
  {112, 50, 126},
  {146, 83, 161},
  {164, 41, 99},
  {236, 1, 90},
  {240, 99, 164},
  {241, 97, 100},
  {248, 158, 79},
  {252, 238, 33},
}
width = 500
height = 500

--------------------------------------------------------------------------------

function init()
  screen.set_size(width,height,1)
  screen.clear()
  for i = 1, 50 do
    x = math.random(width)
    y = math.random(height)
    mass = math.random(5, 200)
    table.insert(particles,particle.new(x, y, mass, i))
  end

  refresh_metro = metro.init(
    redraw, -- function to execute
    1/60, -- how often (here, 60 fps)
    -1 -- how many times (here, forever)
  )
  refresh_metro:start() -- start the timer
end


-- function screen.click (x, y, state, button)	
--   if state == 1 then init() end
-- end

--------------------------------------------------------------------------------
function redraw()  
  screen.clear()

  --create a quadtree
  local boundary = rectangle:new(width / 2, height / 2, width, height)
  local qtree = quadtree:new(boundary, 4)
  checked_pairs = {}

  -- insert all particles
  for i=1, #particles do
    local particle = particles[i]
    if type (particle.position.x) ~= "table" then
      local pt = point:new(particle.position.x, particle.position.y, particle)
      qtree:insert(pt)
    else
      print("ERROR: pos is table", particle.position.x,particle.position.y)
    end
  end

  for i=1, #particles do
    local particle_a = particles[i]
    local range = circle:new(
      particle_a.position.x,
      particle_a.position.y,
      particle_a.r * 2
    )
    -- check only nearby particles based on quadtree
    local points = qtree:query(range)

    for j=1, #points do
      local pt = points[j]
      local particle_b = pt.user_data

      -- here is where we divert from the p5js script
      -- because lua can't directly check for the equality of two tables
      -- (i think...)
      if particle_b.id ~= particle_a.id then
        local id_a = particle_a.id
        local id_b = particle_b.id
        local pair 
        if id_a < id_b then
          pair = {id_a,id_b}
        else
          pair = {id_b,id_a}
        end
        local checked_pairs_has_pair = false
        for k=j, #checked_pairs do
          local pair_to_check = checked_pairs[k] 
          if pair_to_check[1] == pair[1] and pair_to_check[2] == pair[2] then
            checked_pairs_has_pair = true
          end
        end
        if not checked_pairs_has_pair then
          particle_a:collide(particle_b)
          table.insert(checked_pairs,pair)
        end
    end
    end

  end

  for i=1, #particles do
    local particle = particles[i]
    particle:update()
    particle:edges()
    particle:show()
  end
  screen.update()
end

