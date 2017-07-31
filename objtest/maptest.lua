gamestate = {
  map_x = 0,
  map_y = 0,
  blue_block_count = 0,
  heart_count = 0,
  winpanel_count = 0,
  camera_x=0,
  camera_y=0,
  victory=false,
  winframe=0
}

player = {
	x=8,
	y=8,
	sprite=48,
	direction=3,
	anim_frame=0,
	sprite_flip=false,
	cm=true,
	cw=true,
	speed=1,
	hitbox_x =2,
	hitbox_y =0,
	hitbox_w =4,
	hitbox_h =7
}

function update_player()
  if player.anim_frame >= 14 then player.anim_frame = 0 end
  if player.anim_frame >= 7 then player.sprite_flip = false else player.sprite_flip = true end
  player.anim_frame += 1
end

function draw_player()
  spr(player.sprite,player.x, player.y, 1, 1, player.sprite_flip, false)
end

allblueblocks = {}

blueblock = {
  sprite = 4,
  x=0,
  y=0,
  hitbox_x=0,
  hitbox_y=0,
  hitbox_w=8,
  hitbox_h=8
}

function blueblock:new(o)
  o = o or {}
  setmetatable(o,self)
  self.__index = self
  return o
end

function blueblock:draw() 
  spr(self.sprite, self.x, self.y)
end

heart = {
  x=0,
  y=0,
  sprite = 6,
 	hitbox_x =2,
 	hitbox_y =3,
 	hitbox_w =4,
 	hitbox_h =5,
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


winpanel = {
  sprite = 7,
  x=0,
  y=0,
  hitbox_x=0,
  hitbox_y=0,
  hitbox_w=8,
  hitbox_h=8
}

allwinpanels = {}

function winpanel:new(o)
  o = o or {}
  setmetatable(o,self)
  self.__index = self
  return o
end

function winpanel:draw() 
  spr(self.sprite, self.x, self.y)
end


function position_camera()
  local cx = player.x - 28
  local cy = player.y - 28
  if cx < 0 then cx = 0 end
  if cx > 64 then cx = 64 end
  if cy < 0 then cy = 0 end
  if cy > 64 then cy = 64 end
  gamestate.camera_x = cx
  gamestate.camera_y = cy
end


function add_item (add_i,add_x,add_y)
    if add_i==1 then
      gamestate.blue_block_count +=1
      allblueblocks[gamestate.blue_block_count] = blueblock:new()     
      allblueblocks[gamestate.blue_block_count].x = add_x
      allblueblocks[gamestate.blue_block_count].y = add_y
    end
    if add_i==3 then
      gamestate.heart_count += 1
      allhearts[gamestate.heart_count] = heart:new()
      allhearts[gamestate.heart_count].x = add_x
      allhearts[gamestate.heart_count].y = add_y
    end
    if add_i==7 then
      gamestate.winpanel_count += 1
      allwinpanels[gamestate.winpanel_count] = winpanel:new()
      allwinpanels[gamestate.winpanel_count].x = add_x
      allwinpanels[gamestate.winpanel_count].y = add_y
    end
end


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
 1,0,0,0,0,0,0,0,0,0,1,0,0,1,7,1,
 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
}



function collide(obj, other)
  if
    other.x+other.hitbox_x+other.hitbox_w > obj.x+obj.hitbox_x and 
    other.y+other.hitbox_y+other.hitbox_h > obj.y+obj.hitbox_y and
    other.x+other.hitbox_x < obj.x+obj.hitbox_x+obj.hitbox_w and
    other.y+other.hitbox_y < obj.y+obj.hitbox_y+obj.hitbox_h 
  then
    return true
  end
end

function player_move()
  local original_x = player.x
  local original_y = player.y
  if btn(0) then player.x -= player.speed end
  if btn(1) then player.x += player.speed end
  if btn(2) then player.y -= player.speed end
  if btn(3) then player.y += player.speed end
  for this_blue_block in all(allblueblocks) do
    if collide(player,this_blue_block)==true then
      player.x = original_x
      player.y = original_y
    end
  end
  for this_heart in all(allhearts) do 
    if collide(player,this_heart)==true then
      del(allhearts,this_heart)
    end
  end
  for this_winner in all(allwinpanels) do
    if collide(player,this_winner) == true then
      gamestate.victory=true
      del(allwinpanels,this_winner)
    end -- end if
  end -- end for
end

function draw_win_msg()
  if gamestate.winframe >= 32 then gamestate.winframe = 0 else gamestate.winframe += 1 end
  local drawcolor = flr(gamestate.winframe/2)
  local shadowcolor = 0
  local draw_x = 16 + gamestate.camera_x
  local draw_y = 29 + gamestate.camera_y
  local draw_msg = "you win!"
  if drawcolor >= 7 then shadowcolor = drawcolor - 8 else shadowcolor = drawcolor + 8 end
  color(shadowcolor)
  print(draw_msg,draw_x+1,draw_y+1)
  color(drawcolor)
  print(draw_msg,draw_x,draw_y)
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
    if i > 0 then add_item(i, block_x * 8, block_y * 8) end
    block_x += 1
  end
end

function _update() 
  for this_heart in all(allhearts) do
    this_heart:bounce()
  end
  position_camera()
  camera(gamestate.camera_x,gamestate.camera_y)
  update_player()
  player_move()
end


function _draw()
  cls()
--  camera(gamestate.camera_x, gamestate.camera_y)
  local counter = 0
  map(0,0,gamestate.map_x,0,16,16)
  for this_block in all(allblueblocks) do
    this_block:draw()
  end
  for this_heart in all(allhearts) do
    this_heart:draw()
  end  
  for this_winpanel in all(allwinpanels) do
    this_winpanel:draw()
  end
  draw_player()
  if gamestate.victory==true then draw_win_msg() end
end