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
    
    for i=0,mapSize[2]-1 do
      obj.map[i] = {}
      for n=0,mapSize[1]-1 do
        obj.map[i][n] = {}
        obj.map[i][n]["type"] = ""
        obj.map[i][n]["x"] = n*(screenSize[1]/mapSize[1])
        obj.map[i][n]["y"] = i*(screenSize[2]/mapSize[2])
        obj.map[i][n]["xRatio"] = screenSize[1]/((mapSize[1])*tileSize)
        obj.map[i][n]["yRatio"] = screenSize[2]/((mapSize[2])*tileSize)
        obj.map[i][n]["animation"] = {}
        end
    end
  end
  
  function obj:set_map() -- test function to set all to one type
    for i=0, mapSize[2]-1 do
      for n=0, mapSize[1]-1 do
        obj.map[i][n]["type"] = "water"
        obj.map[i][n]["animation"]["anim"] = waterAnim
        obj.map[i][n]["animation"]["dur"] = 10
        obj.map[i][n]["animation"]["curTime"] = math.random(10)
        --end
      end
    end
  end
  
  function obj:spawn_island(sz)
    local centerx, centery, islandmap, size
    
    islandmap = {}
    size = sz - 1
    
    centerx = mapSize[1]/2
    centery = mapSize[2]/2
    
    islandmap[1] = {centerx, centery}
    
    obj.map[islandmap[1][1]][islandmap[1][2]]["type"] = "grass"
    obj.map[islandmap[1][1]][islandmap[1][2]]["animation"]["anim"] = grassAnim
    obj.map[islandmap[1][1]][islandmap[1][2]]["animation"]["dur"] = 10
    obj.map[islandmap[1][1]][islandmap[1][2]]["animation"]["curTime"] = math.random(10)
    
    table.insert(islandmap, {islandmap[1][1]-1, islandmap[1][2]})
    table.insert(islandmap, {islandmap[1][1], islandmap[1][2]+1})
    table.insert(islandmap, {islandmap[1][1]+1, islandmap[1][2]})
    table.insert(islandmap, {islandmap[1][1], islandmap[1][2]-1})
    
    while size > 0 do
      
      if obj.map[islandmap[1][1]][islandmap[1][2]]["type"] ~= "grass" and math.random() > 0.90 then
        
        obj.map[islandmap[1][1]][islandmap[1][2]]["type"] = "grass"
        obj.map[islandmap[1][1]][islandmap[1][2]]["animation"]["anim"] = grassAnim
        obj.map[islandmap[1][1]][islandmap[1][2]]["animation"]["dur"] = 10
        obj.map[islandmap[1][1]][islandmap[1][2]]["animation"]["curTime"] = math.random(10)
        
        table.insert(islandmap, {islandmap[1][1]-1, islandmap[1][2]})
        table.insert(islandmap, {islandmap[1][1], islandmap[1][2]+1})
        table.insert(islandmap, {islandmap[1][1]+1, islandmap[1][2]})
        table.insert(islandmap, {islandmap[1][1], islandmap[1][2]-1})
        
        table.remove(islandmap, 1)
        
        size = size - 1
        
      elseif obj.map[islandmap[1][1]][islandmap[1][2]]["type"] == "grass" then
        
        table.remove(islandmap, 1)
        
      else
        table.insert(islandmap, {islandmap[1][1], islandmap[1][2]})
        table.remove(islandmap, 1)
      end
    end
    
  end
  
  function obj:draw() -- draws either images or animations
    for i=0, mapSize[2]-1 do
      for n=0, mapSize[1]-1 do
        if obj.map[i][n]["animation"] == nil then
          love.graphics.draw(obj.map[i][n]["image"], obj.map[i][n]["x"], obj.map[i][n]["y"], 0, obj.map[i][n]["xRatio"], obj.map[i][n]["yRatio"])
        else
          local spriteNum = math.floor(obj.map[i][n]["animation"]["curTime"] / obj.map[i][n]["animation"]["dur"] * #obj.map[i][n]["animation"]["anim"].quads) + 1
          love.graphics.draw(obj.map[i][n]["animation"]["anim"].spriteSheet, obj.map[i][n]["animation"]["anim"].quads[spriteNum], obj.map[i][n]["x"], obj.map[i][n]["y"], 0, obj.map[i][n]["xRatio"], obj.map[i][n]["yRatio"])
        end
      end
    end
  end
  
  function obj:map_update(dt) -- updates the animations
    for i=0, mapSize[2]-1 do
      for n=0, mapSize[1]-1 do
        if obj.map[i][n]["image"] == nil then
          obj.map[i][n]["animation"]["curTime"] = obj.map[i][n]["animation"]["curTime"] + dt
          if obj.map[i][n]["animation"]["curTime"] >= obj.map[i][n]["animation"]["dur"] then
            obj.map[i][n]["animation"]["curTime"] = obj.map[i][n]["animation"]["curTime"] - obj.map[i][n]["animation"]["dur"]
          end
        end
      end
    end
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