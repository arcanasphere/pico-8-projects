--midnight faerie
--#lowrezjam 2017 by arcanasphere

function init_world ()
 gamestate={
  mode=1, -- 0=into, 1=game, 2=menu, 3=info, 4=end
  timeleft=300,
  wisps_unlocked = false,
  frame=0,
  petals=0,
  wisps=0,
  moths=0
 }

 player = {
  x=62,
  y=8,
  sprite=1,
  hitbox_x=0,
  hitbox_y=0,
  hitbox_w=5,
  hitbox_h=5,
  speed=(16/30),
  frame=0,
  petals=0,
  matches=0
 }

 cloud={}

 viewport = {
  x=32,
  y=0
 }
 
 menu = {
  position = 1,
  items = 3
 }
 
 prices = {
  mushroom = 10,
  wisp = 5,  
  match = 25,
  moth = 40
 }
 
 menu_items = {}
 menu_items[1] = "mushroom " .. prices.mushroom
 menu_items[2] = "wisp      " .. prices.wisp
 menu_items[3] = "match    " .. prices.match

 
 daffs = {} -- table of daffodils
 daffcount = 0
 
 lilacs = {} -- table of lilacs
 lilaccount = 0

 rosebushes = {}
 rosebushcount = 0
 
 logs= {}
 logcount=0
 
 wisps = {}
 moths = {}
 
 fairycircle = {
  x=72,
  y=6,
  hitbox_x = 0,
  hitbox_y = 0,
  hitbox_w = 16,
  hitbox_h = 16
 }
 
 candle = {
  x=112,
  y=8,
  hitbox_x= 2,
  hitbox_y=0,
  hitbox_w=3,
  hitbox_h=8,
  frame=0,
  sprite=18,
  lit=false
 }
 
 mushroom = {
  x=63,
  y=96,
  hitbox_x=0,
  hitbox_y=0,
  hitbox_w=2,
  hitbox_h=2,
  hp=0,
  size=1
 }
  
 cyclops = {
  x=128,
  y=32,
  hitbox_x=0,
  hitbox_y=0,
  hitbox_w=64,
  hitbox_h=32,
  frame=0,
  hp=1000
 }

end

obj = {
 x=62,
 y=8,
 hitbox_x=0,
 hitbox_y=0,
 hitbox_w=8,
 hitbox_h=8,
}

function obj:new(o)
 o = o or {}
 setmetatable(o,self)
 self.__index = self
 return o
end -- end obj:new


function new_daff(x,y,flipme)  
  daffcount += 1
  daffs[daffcount] = obj:new()
  daffs[daffcount].x = x
  daffs[daffcount].y = y
  daffs[daffcount].hitbox_x=0
  daffs[daffcount].hitbox_y=0
  daffs[daffcount].hitbox_w=7
  daffs[daffcount].hitbox_h=16
  if flipme == true then
   daffs[daffcount].flipme=true
   daffs[daffcount].hitbox_x=1
  else
   daffs[daffcount].flipme=false
  end
end

function new_lilac(x,y,flipme)
 lilaccount += 1
 lilacs[lilaccount] = obj:new()
 lilacs[lilaccount].x = x
 lilacs[lilaccount].y = y
 lilacs[lilaccount].hitbox_x=1
 lilacs[lilaccount].hitbox_y=0
 lilacs[lilaccount].hitbox_w=6
 lilacs[lilaccount].hitbox_h=16
 if flipme==true then
  lilacs[lilaccount].flipme=true
 else
  lilacs[lilaccount].flipme=false
 end
end

function new_rosebush(x,y,flipme,petals)
 rosebushcount += 1
 rosebushes[rosebushcount] = obj:new()
 rosebushes[rosebushcount].x = x
 rosebushes[rosebushcount].y = y
 rosebushes[rosebushcount].hitbox_x = 0
 rosebushes[rosebushcount].hitbox_y = 0
 rosebushes[rosebushcount].hitbox_w = 8
 rosebushes[rosebushcount].hitbox_h = 16
 rosebushes[rosebushcount].petals = petals
 if flipme == true then
  rosebushes[rosebushcount].flipme = true
 else
  rosebushes[rosebushcount].flipme = false
 end
end

function new_log(x,y,flipme)  
  logcount += 1
  logs[logcount] = obj:new()
  logs[logcount].x = x
  logs[logcount].y = y
  logs[logcount].hitbox_x=0
  logs[logcount].hitbox_y=0
  logs[logcount].hitbox_w=7
  logs[logcount].hitbox_h=16
  if flipme == true then
   logss[logcount].flipme=true
  else
   logs[logcount].flipme=false
  end
end

function new_wisp()
  gamestate.wisps += 1
  wisps[gamestate.wisps] = obj:new()
  wisps[gamestate.wisps].frame = 0
  wisps[gamestate.wisps].maxframe = 30
  wisps[gamestate.wisps].addpetals = 1
end

function new_moth()
  gamestate.moths += 1
  moths[gamestate.moths] = obj:new()
  moths[gamestate.moths].frame = 0
  moths[gamestate.moths].maxframe = 30
  moths[gamestate.moths].addpetals = 5
end











function init_cloud()
 for i=0,15 do
   cloud[i] = 0
 end
 for i=16,255 do
  cloud[i] = 1
 end
 cloud[24]=0
 cloud[25]=0
 cloud[26]=0
 cloud[40]=0
 cloud[41]=0
 cloud[42]=0
end





--collision!!!
--modified from pico fanzine issue 3 page 16
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

function check_collision_flowers()
  didcollide = false
  for this_flower in all(daffs) do
    if collide(player, this_flower) == true then didcollide = true end
  end
  for this_flower in all(lilacs) do
    if collide(player,this_flower) == true then didcollide = true end
  end
  for this_bush in all(rosebushes) do
    if collide(player,this_bush) == true then 
      didcollide = true
     if player.petals == 0 and this_bush.petals > 0 then
       player.petals +=1
       this_bush.petals -= 1
     end
    end
  end
  if collide(player,fairycircle) then
    if player.petals > 0 then
      player.petals -= 1
      gamestate.petals += 1
    end
    didcollide = true
  end
  if collide(player,candle) then
   if(player.matches > 0 and candle.lit == false) then
     add(menu_items,"moth     " .. prices.moth)
     menu.items += 1
     player.matches -= 1
     candle.lit = true
   end
   didcollide = true
  end
 return didcollide
end





--update functions

function update_game()
 if gamestate.frame >= 30 then
  gamestate.frame = 0
  if gamestate.timeleft > 0 then gamestate.timeleft -= 1 end
 end
 gamestate.frame += 1
 update_candle()
 update_bugs()
 update_viewport()
 camera(viewport.x, viewport.y)
 update_petals()
end

function update_player ()
  local original_x = player.x
  local original_y = player.y
  if btn(0) then player.x -= player.speed end
  if btn(1) then player.x += player.speed end
  if btn(2) then player.y -= player.speed end
  if btn(3) then player.y += player.speed end
  if btn(4) then
   menu.position = 1
   gamestate.mode = 2
  end
  if player.x < 0 or player.x > 123 then player.x = original_x end
  if player.y < 6 or player.y > 123 then player.y = original_y end
  if check_collision_flowers() == true then
    player.x = original_x
    player.y = original_y
  end
  
  player.frame += 1
  if player.frame >=16 then player.frame = 0 end
  if player.frame > 8 then player.sprite=2 else player.sprite=1 end
end

function update_viewport()
 viewport.x=player.x-29
 viewport.y=player.y-29
 if viewport.x < 0 then viewport.x=0 end
 if viewport.x > 64 then viewport.x=64 end
 if viewport.y < 0 then viewport.y=0 end
 if viewport.y > 64 then viewport.y=64 end
end

function update_candle()
 if candle.lit == true then
  if candle.frame >=14 then candle.frame = 0 end
  if candle.frame <7 then candle.sprite=19 else candle.sprite=20 end
  candle.frame += 1
 end
end

function update_bugs()
  for this_moth in all(moths) do
    if this_moth.frame >= 30 then
      gamestate.petals += 5
      this_moth.frame = 0
    end
    this_moth.frame += 1
  end
  for this_wisp in all(wisps) do
    if this_wisp.frame >= 30 then
      gamestate.petals += 1
      this_wisp.frame = 0
    end
    this_wisp.frame += 1
  end
end



function update_cloud()
 --get player location
 local cloud_x = flr((player.x+2)/8)
 local cloud_y = flr((player.y+2)/8)
 local cloud_loc = (cloud_y*16) + cloud_x
 cloud[cloud_loc]=0
 if cloud_x -1 >= 0 then cloud[cloud_loc-1] = 0 end
 if cloud_x +1 <= 16 then cloud[cloud_loc+1] = 0 end
 if cloud_y -1 >= 0 then cloud[cloud_loc-16] = 0 end
 if cloud_y +1 <=16 then cloud[cloud_loc+16] = 0 end
end

function update_menu()
  if btnp(2) then
    if menu.position > 1 then menu.position -= 1 else menu.position = menu.items end
  end
  if btnp(3) then
    if menu.position < menu.items then menu.position += 1 else menu.position = 1 end
  end
  if btnp(4) then
    if menu.position == 1 then
      if gamestate.petals >= prices.mushroom then
        mushroom.hp += 1
        gamestate.petals -= prices.mushroom
      else 
        sfx(0)
      end
    end -- end position 1
  if menu.position == 2 then
    if gamestate.petals >= prices.wisp then
        new_wisp()
        gamestate.petals -= prices.wisp
        prices.wisp = 10
        menu_items[2] = "wisp     " .. prices.wisp
      else 
        sfx(0)
      end
    end -- end position 2
  if menu.position == 3 then
    if (gamestate.petals >= prices.match and player.matches < 1)then
        player.matches += 1
        gamestate.petals -= prices.match
      else 
        sfx(0)
      end
    end -- end position 3
  if menu.position == 4 then
    if gamestate.petals >= prices.moth then
        new_moth()
        gamestate.petals -= prices.moth
      else 
        sfx(0)
      end
    end -- end position 2
  end
  if btn(5) then gamestate.mode=1 end
end

function update_petals()
  if gamestate.petals > 9999 then gamestate.petals = 9999 end
end




-- draw functions
function draw_game()
 clip(0,6,128,122)
 map(0,0,0,0,16,16,0)
 map(16,0,0,0,16,16,1)
 draw_flowers()
 draw_cloud()
 clip()
 draw_header()
 spr(player.sprite,player.x,player.y)
end



function draw_menu()
 local linecolor = 6  
 local cornercolor = 5
 local menu_item_y = 15+viewport.y
 local menu_item_count = 1
 rectfill(4+viewport.x,10+viewport.y,60+viewport.x,54+viewport.y,0)
 rect(5+viewport.x,11+viewport.y,59+viewport.x,53+viewport.y,linecolor) 
 pset(5+viewport.x,11+viewport.y,0)
 pset(5+viewport.x,53+viewport.y,0)
 pset(59+viewport.x,11+viewport.y,0)
 pset(59+viewport.x,53+viewport.y,0)
 for this_menu in all(menu_items) do
   color(7)
   print(this_menu, 13+viewport.x, menu_item_y)
   if menu_item_count == menu.position then spr(15, 7+viewport.x, menu_item_y) end
   menu_item_y += 6
   menu_item_count += 1
 end
 color(4)
 spr(21,7+viewport.x,39+viewport.y)
 print(mushroom.hp, 13+viewport.x,39+viewport.y)
 color(12)
 spr(13,7+viewport.x,45+viewport.y)
 print(gamestate.wisps, 13+viewport.x, 45+viewport.y)
 if gamestate.moths > 0 then
   color(7)
   spr(14,38+viewport.x, 45+viewport.y)
   print(gamestate.moths, 45+viewport.x, 45+viewport.y)
 end
end


function draw_flowers()
  local doflipme = false
  for this_flower in all(daffs) do
    if this_flower.flipme == true then
      spr(222,this_flower.x,this_flower.y+8,1,1,true,false)
      spr(206,this_flower.x,this_flower.y,1,1,true,false)
    else 
      spr(222,this_flower.x,this_flower.y+8)
      spr(206,this_flower.x,this_flower.y)
    end
  end
  for this_flower in all(lilacs) do
    if this_flower.flipme == true then
      spr(223,this_flower.x,this_flower.y+8,1,1,true,false)
      spr(207,this_flower.x,this_flower.y,1,1,true,false)
    else 
      spr(223,this_flower.x,this_flower.y+8)
      spr(207,this_flower.x,this_flower.y)
    end
  end
  for this_bush in all(rosebushes) do
    if this_bush.flipme == true then
      spr(32,this_bush.x,this_bush.y+8,1,1,true,true)
      spr(48,this_bush.x,this_bush.y,1,1,true,true)
    else
      spr(48,this_bush.x,this_bush.y+8)
      spr(32,this_bush.x,this_bush.y)
    end      
  end
  sspr(8,16,16,16,fairycircle.x,fairycircle.y)
  spr(candle.sprite,candle.x,candle.y)
end

function draw_cloud()
  local cloud_x = 0
  local cloud_y = 0
  for i=0, 255 do
    if cloud_x >= 16 then
      cloud_x = 0
      cloud_y += 1
    end
    if cloud[i] == 1 then spr(194,cloud_x*8,cloud_y*8) end
    cloud_x += 1
  end
end


function draw_header()
 local time_m = flr(gamestate.timeleft/60)
 local time_s = gamestate.timeleft - (time_m * 60)
 if time_s < 10 then time_s = "0" .. time_s end
 spr(16,viewport.x,viewport.y+1)
 color(14)
 print(gamestate.petals,viewport.x+5,viewport.y)
 if player.petals >= 1 then spr(16,viewport.x+60,viewport.y+1) end
 if player.matches >= 1 then spr(17,viewport.x+56,viewport.y+1) end
 local timemsg = time_m .. ":" .. time_s
 print (timemsg,viewport.x+24,viewport.y)
end












-- crucial game functions


function _init()
  cls()
  poke(0x5f2c,3)
  init_world()
  init_cloud()
  new_daff(40,40,false)
  new_daff(50,40,true)
  new_lilac(60,40,true)
  new_lilac(70,40,false)
  new_rosebush(8,8,false,500)
end

function _update()
 if gamestate.mode==1 then
  update_player()
  update_cloud()
  update_game()
  else
   if gamestate.mode==2 then
    update_game()
    update_menu()
   end
 end
end


function _draw()
 cls()
 if gamestate.mode == 1 then
  draw_game()
 end
 if gamestate.mode == 2 then
  draw_game()
  draw_menu()
 end
end