function map()
  local obj = {} -- Creating the object to return
  local tileSize, screenSize, mapSize -- Local varaibles
  
  obj.map = {}
  
  function obj:load(tS, sS, mS)
    tileSize = tS -- This is the size of the image files (should be around 100)
    screenSize = {sS[1], sS[2]} -- This is the size of the screen
    mapSize = {mS[1], mS[2]} -- This is the size of time map x and y, 1 = tile
    
    for i=0,mapSize[2]-1 do
      obj.map[i] = {}
      for n=0,mapSize[1]-1 do
        obj.map[i][n] = {}
        obj.map[i][n]["type"] = ""
        obj.map[i][n]["x"] = n*(screenSize[1]/mapSize[1])
        obj.map[i][n]["y"] = i*(screenSize[2]/mapSize[2])
        obj.map[i][n]["xRatio"] = screenSize[1]/((mapSize[1])*tileSize)
        obj.map[i][n]["yRatio"] = screenSize[2]/((mapSize[2])*tileSize)
        obj.map[i][n]["image"] = nil
        end
    end
  end
  
  function obj:resetMap(typ, img)
    for i=0, mapSize[2]-1 do
      for n=0, mapSize[1]-1 do
        obj.map[i][n]["type"] = typ
        obj.map[i][n]["image"] = love.graphics.newImage(img)
      end
    end
  end
  
  function obj:draw()
    for i=0, mapSize[2]-1 do
      for n=0, mapSize[1]-1 do
        love.graphics.draw(obj.map[i][n]["image"], obj.map[i][n]["x"],obj.map[i][n]["y"],0,obj.map[i][n]["xRatio"],obj.map[i][n]["yRatio"])
      end
    end
  end

  function obj:up(mp)
    
  end
  
  function obj:down(mp)
    
  end
  
  function obj:left(mp)
    
  end
  
  function obj:right(mp)
    
  end
  
  return obj
end

return map