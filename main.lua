require("map")

function love.load()

  xMap = map()
  xMap:load(400, {1920,1080}, {10,10})
  xMap:resetMap("water", "img/water.png")
  
  -- Inits
  love.window.setTitle("Map Generator")
  love.window.setMode(1920,1080)
  --graphics
end

function love.draw()  
  xMap.draw()
  --DEBUG TEXT
  love.graphics.print(xMap.map[0][0]["x"], 0, 0)
end