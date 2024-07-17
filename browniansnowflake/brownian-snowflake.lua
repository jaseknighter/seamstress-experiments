-- brownian motion snowflake
-- version0.1 @jaseknighter
--
-- particle class based on Daniel Shiffman's Coding Challenge 127: Brownian Motion Snowflake
-- https://thecodingtrain.com/CodingChallenges/127-brownian-snowflake.html
-- https://youtu.be/XUA8UREROYE
-- https://editor.p5js.org/codingtrain/sketches/SJcAeCpgE

vector = include('lib/vector')
particle = include('lib/particle')

current = nil
width = 500
height = 500

--------------------------------------------------------------------------------

function init()
  screen.set_size(width,height,1)
  screen.clear()
  snowflake = {}
  no_loop = false
  current = particle.new((height/2)-20, 0);

  refresh_metro = metro.init(
    redraw, -- function to execute
    1/60, -- how often (here, 60 fps)
    -1 -- how many times (here, forever)
  )
  refresh_metro:start() -- start the timer
end


function screen.click (x, y, state, button)	
  if state == 1 then init() end
end

--------------------------------------------------------------------------------
function redraw()  
  if no_loop == false then
    screen.clear()
    local count = 0
    while(current:finished() == false and current:intersects(snowflake) == false) do
      -- current:rotate(math.pi/6)
      current:update()
      count = count + 1
    end

    -- If a particle doesn't move at all we're done
    if (count == 0) then
      no_loop = true
      print('snowflake completed')
    end

    table.insert(snowflake,current)
    current = particle.new((height/2)-20, 0)

    for i=1,6 do
      -- current:show()
      for j=1, #snowflake do
        local p = snowflake[j]
        p:rotate(math.pi/3)
        p:show()
        p:show(1,-1)
      end
    end
    screen.update()
  end
end

