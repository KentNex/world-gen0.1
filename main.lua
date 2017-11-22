require("map")

function love.load()
  
  math.randomseed(os.time())
  
  xMap = map()
  xMap:load(400, {1920,1080}, {30,30})
  xMap:set_map()
  
  xMap:spawn_island(30)
  
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