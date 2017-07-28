gamestate = {
  map_x = 0,
  map_y = 0,
  blue_block_count = 0,
  heart_count = 0,
  camera_x=0,
  camera_y=0,
  camera_offset_x = (8/30),
}

player {
  x=8,
  y=8
}

allblueblocks = {}

blueblock = {
  x=0,
  y=0,
  boundx1 = 0,
  boundx2 = 8,
  boundy1 = 0,
  boundy2 = 8,
  sprite = 4
}

function blueblock:new(o)
  o = o or {}
  setmetatable(o,self)
  self.__index = self
  return o
end

function blueblock:draw() 
  spr(self.sprite, self.x, self.y)
  color(8)
end

heart = {
  x=0,
  y=0,
  boundx1 = 1,
  boundx2 = 4,
  boundy1 = 2,
  boundy2 = 5,
  sprite = 6,
  offset_y = 0.01,
  offset_speed = 0.25
}

allhearts = {}

function heart:new(o)
  o = o or {}
  setmetatable(o,self)
  self.__index = self
  return o
end

function heart:bounce()
  if self.offset_y < -2 then
    self.offset_speed = 0.25
  end
  if self.offset_y > 2 then
    self.offset_speed = -.25
  end
  self.offset_y += self.offset_speed
end

function heart:draw()
  spr(self.sprite, self.x, self.y + self.offset_y)
end


level1map = {
 0,1,0,0,0,0,0,0,
 0,1,1,1,1,1,1,0,
 0,1,0,0,0,0,0,0,
 0,1,0,1,1,0,1,0,
 0,1,0,1,1,0,1,0,
 0,1,0,1,0,0,1,0,
 0,1,0,1,0,1,1,1,
 0,0,0,1,0,0,0,0
}

level2map = {
 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
 1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,1,
 1,0,1,3,0,0,1,1,1,1,1,1,1,1,0,1,
 1,0,1,3,1,0,0,0,0,0,0,1,0,0,0,1,
 1,3,1,3,1,0,1,1,1,1,0,1,0,1,1,1,
 1,0,1,0,1,0,0,0,0,1,0,1,0,0,0,1,
 1,0,0,0,1,1,1,1,1,1,0,1,1,1,0,1,
 1,0,1,0,1,0,0,0,0,0,0,1,0,0,0,1,
 1,0,1,1,1,1,1,1,1,1,1,1,1,1,0,1,
 1,0,1,0,0,0,0,0,0,0,0,0,0,1,0,1,
 1,0,1,1,1,1,0,0,1,0,1,0,0,1,0,1,
 1,0,1,0,0,1,0,0,1,0,1,1,0,1,0,1,
 1,0,0,0,0,1,0,0,1,0,1,0,0,1,0,1,
 1,0,1,1,1,1,1,1,1,0,1,0,1,1,0,1,
 1,0,0,0,0,0,0,0,0,0,1,0,0,1,0,1,
 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
}

function hero_down()
  local okay_to_move = true
  for bb in all(allblueblocks) do
    if (bb.y == player.y +1 ) then
      if (bb.x-7 >= player.x and bb.x+8 <= player.x) then
        okay_to_move = false
      end
    end
  end
  if okay_to_move == true then player.y += 1 end
end

function hero_up()
  local okay_to_move = true
  for bb in all(allblueblocks) do
    if (bb.y+8 <= player.y and bb.y-(player.y-8) >= 0) then
      if (bb.x >= player.x and bb.x < player.x+8) then
        okay_to_move = false
      end
    end
  end
  if okay_to_move == true then player.y -= 1 end
end

function hero_right()
  local okay_to_move = true
  for bb in all(allblueblocks) do
    if (bb.x >= player.x + 8 and bb.x-(player.x+8) <= 0) then
      if (bb.y >= player.y and bb.y < player.y+8) then
        okay_to_move = false
      end
    end
  end
  if okay_to_move == true then player.x += 1 end
end

function hero_left()
  local okay_to_move = true
  for bb in all(allblueblocks) do
    if (bb.x+8 <= player.x and bb.x-(player.x-8) >= 0) then
      if (bb.y >= player.y and bb.y < player.y+8) then
        okay_to_move = false
      end
    end
  end
  if okay_to_move == true then player.x -= 1 end
end


function update_character()
  if btn(0) then hero_left() end
  if btn(1) then hero_right() end
  if btn(2) then hero_up() end
  if btn(3) then hero_down() end
end


function _init()
  poke(0x5f2c,3)
  cls()
  local block_x = 0
  local block_y = 0
  for i in all (level2map) do
    if block_x >= 16 then
      block_x = 0
      block_y += 1
    end
    if i==1 then
      gamestate.blue_block_count +=1
      allblueblocks[gamestate.blue_block_count] = blueblock:new()     
      allblueblocks[gamestate.blue_block_count].x = block_x * 8
      allblueblocks[gamestate.blue_block_count].y = block_y * 8
    end
    if i==3 then
      gamestate.heart_count += 1
      allhearts[gamestate.heart_count] = heart:new()
      allhearts[gamestate.heart_count].x = block_x * 8
      allhearts[gamestate.heart_count].y = block_y * 8
    end
    block_x += 1
  end
end

function _update() 
  update_character()
  for this_heart in all(allhearts) do
    this_heart:bounce()
  end
  if gamestate.camera_x <= 0 then gamestate.camera_offset = (8/30) end
  if gamestate.camera_x >= 64 then gamestate.camera_offset = (-8/30) end
  gamestate.camera_x += gamestate.camera_offset
end

function debug_blocks()
  local counter = 0
  for this_block in all(allblueblocks) do
    counter += 1
  end
  color(8)
  print("blocks: " .. counter,0,32)
end

function _draw()
  cls()
--  camera(gamestate.camera_x, gamestate.camera_y)
  local counter = 0
  map(0,0,gamestate.map_x,0,16,16)
  map(0,0,gamestate.map_x,0,16,16)
  for this_block in all(allblueblocks) do
    this_block:draw()
  end
  for this_heart in all(allhearts) do
    this_heart:draw()
  end
  spr(48,player.x,player.y)
end