function map()
  local obj = {} -- Creating the object to return
  local tileSize, screenSize, mapSize -- Local varaibles
  
  local waterAnim -- Animations
  
  obj.map = {}
  
  function obj:load(tS, sS, mS) -- int tileSize, int screenSize(x,y), int mapSize(x,y)
    tileSize = tS -- This is the size of the image files (should be around 100)
    screenSize = {sS[1], sS[2]} -- This is the size of the screen
    mapSize = {mS[1], mS[2]} -- This is the size of time map x and y, 1 = tile
    
    waterAnim = new_animation(love.graphics.newImage("img/watersheet.png"), 400, 400)
    grassAnim = new_animation(love.graphics.newImage("img/grass.png"), 400, 400)
    sandAnim = new_animation(love.graphics.newImage("img/sand.png"), 400, 400)
    
    for i=0,mapSize[2]-1 do
      obj.map[i] = {}
      for n=0,mapSize[1]-1 do
        obj.map[i][n] = {}
        obj.map[i][n]["type"] = ""
        obj.map[i][n]["x"] = n*(screenSize[1]/mapSize[1])
        obj.map[i][n]["y"] = i*(screenSize[2]/mapSize[2])
        obj.map[i][n]["xNum"] = n
        obj.map[i][n]["yNum"] = i
        obj.map[i][n]["xRatio"] = screenSize[1]/((mapSize[1])*tileSize)
        obj.map[i][n]["yRatio"] = screenSize[2]/((mapSize[2])*tileSize)
        obj.map[i][n]["animation"] = {}
        end
    end
  end
  
  function obj:set_map() -- test function to set all to one type
    for i=0, mapSize[2]-1 do
      for n=0, mapSize[1]-1 do
        obj:tile_water(obj.map[i][n])
      end
    end
  end
  
  function obj:spawn_island(sz, x, y, vari, sand) -- int Size, int X location, int Y location
  
    local islandmap = {}
    local size = sz
    local variation = vari
    local sandPerc = sand * sz
    
    islandmap[1] = obj.map[x][y]
    
    while size > 0 do
      
      if math.random() < variation then
        table.insert(islandmap, islandmap[1])
        table.remove(islandmap, 1)
        
      elseif islandmap[1]["type"] == "water" then
        
        if size > sandPerc then
          obj:tile_grass(islandmap[1])
        else
          obj:tile_sand(islandmap[1])
        end
        
        table.insert(islandmap, obj:up(islandmap[1]))
        table.insert(islandmap, obj:down(islandmap[1]))
        table.insert(islandmap, obj:left(islandmap[1]))
        table.insert(islandmap, obj:right(islandmap[1]))
        table.remove(islandmap, 1)
        size = size -1
      else
        table.remove(islandmap, 1)
      end
    end
  end
  
  function obj:up(mp) -- send a map[y][x] and it returns the map[y-1][x]
    local y
    if mp["yNum"]-1 < 0 then
      y = mp["yNum"]
    else 
      y = mp["yNum"]-1 
    end
    return obj.map[y][mp["xNum"]]
  end
  
  function obj:down(mp) -- send a map[y][x] and it returns the map[y+1][x]
    local y
    if mp["yNum"]+1 >= mapSize[2] then
      y = mp["yNum"]
    else 
      y = mp["yNum"]+1 
    end
    return obj.map[y][mp["xNum"]]
  end
  
  function obj:left(mp) -- send a map[y][x] and it returns the map[y][x-1]
    local x
    if mp["xNum"]-1 < 0 then
      x = mp["xNum"]
    else 
      x = mp["xNum"]-1 
    end
    return obj.map[mp["yNum"]][x]
  end
  
  function obj:right(mp) -- send a map[y][x] and it returns the map[y][x+1]
    local x
    if mp["xNum"]+1 >= mapSize[1] then
      x = mp["xNum"]
    else 
      x = mp["xNum"]+1 
    end
    return obj.map[mp["yNum"]][x]
  end
  
  function obj:draw() -- draws either images or animations
    for i=0, mapSize[2]-1 do
      for n=0, mapSize[1]-1 do
          local spriteNum = math.floor(obj.map[i][n]["animation"]["curTime"] / obj.map[i][n]["animation"]["dur"] * #obj.map[i][n]["animation"]["anim"].quads) + 1
          
          love.graphics.draw(obj.map[i][n]["animation"]["anim"].spriteSheet, obj.map[i][n]["animation"]["anim"].quads[spriteNum], obj.map[i][n]["x"], obj.map[i][n]["y"], 0, obj.map[i][n]["xRatio"], obj.map[i][n]["yRatio"])
      end
    end
  end
  
  function obj:map_update(dt) -- updates the animations
    for i=0, mapSize[2]-1 do
      for n=0, mapSize[1]-1 do
        obj.map[i][n]["animation"]["curTime"] = obj.map[i][n]["animation"]["curTime"] + dt
        if obj.map[i][n]["animation"]["curTime"] >= obj.map[i][n]["animation"]["dur"] then
          obj.map[i][n]["animation"]["curTime"] = obj.map[i][n]["animation"]["curTime"] - obj.map[i][n]["animation"]["dur"]
        end
      end
    end
  end
  
  function obj:tile_grass(map_tile) -- sets the tile to a grass tile
    map_tile["type"] = "grass"
    map_tile["animation"]["anim"] = grassAnim
    map_tile["animation"]["dur"] = 10
    map_tile["animation"]["curTime"] = math.random(10)
  end
  
  function obj:tile_water(map_tile) -- sets the tile to a water tile
    map_tile["type"] = "water"
    map_tile["animation"]["anim"] = waterAnim
    map_tile["animation"]["dur"] = 3
    map_tile["animation"]["curTime"] = math.random(3)
  end
  
  function obj:tile_sand(map_tile)  -- sets the tile to a sand tile
    map_tile["type"] = "sand"
    map_tile["animation"]["anim"] = sandAnim
    map_tile["animation"]["dur"] = 10
    map_tile["animation"]["curTime"] = math.random(10)
  end
  
  function new_animation(image, width, height, duration) -- SpriteSheet, width and height of spritesheet and duration of the whole animation(ie: two frams with a duration of 10 is every 5 seconds)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {}
    for x = 0, image:getHeight() - height, height do
      for n = 0, image:getWidth() - width, width do
        table.insert(animation.quads, love.graphics.newQuad(n,x,width,height, image:getDimensions()))
      end
    end
    
    return animation
  end
  
  return obj
end

return map