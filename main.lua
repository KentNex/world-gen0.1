require("map")

function love.load()
  
  math.randomseed(os.time())
  
  xMap = map()
  xMap:load(400, {1920,1080}, {80,80})
  xMap:set_map()
  
  xMap:spawn_island(4000, 40, 40, 0.8, 0.4) --int Island Size, Int X, Int Y, Int island variance(0 - 0.99), Int sand percent(0 - 0.99)
  
  test = 0
  test1 = 0
  
  -- Inits
  love.window.setTitle("Map Generator")
  love.window.setMode(1920,1080)
  --graphics
end

function love.update(dt)
  xMap:map_update(dt)
  
  test = 0--xMap.map[0][0]["anim"].duration--test + dt
  test1 = 0--xMap.map[0][0]["anim"].currentTime --+ test1
end

function love.draw()  
  xMap:draw()
  --DEBUG TEXT
  love.graphics.print(test .. " " .. test1, 0, 0)
end