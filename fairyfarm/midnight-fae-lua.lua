--midnight faerie
--#lowrezjam 2017 by arcanasphere

function init_world ()
 gamestate={
  mode=0, -- 0=into, 1=game, 2=menu, 3=info, 4=end
  timeleft=300,
  shroom_price_hike = 1,
  bug_price_hike = 1,
  match_price_hike = 1,
  hike_rate = 1.0125,
  frame=0,
  petals=0,
  wisps=0,
  moths=0,
  matches_bought=0,
  incense_lit=0,
  victory = false,
 }
 
 title = {
  frame=0,
  frame_out=0,
  state=0,
  transition_frame = 0,
  fairy_x=16,
  fairy_y=16,
  fairy_frame=0,
  cloud_x = -18,
  cloud_y = 6,
  msg_frame=-64,
  msg_speed=2,
  bigmsg = "you are a faerie. every night at midnight, the cyclops stomps across your faerie circle. tonight you have a perfect plan. distract the cyclops with a giant strawberry. find the rose bush. use rose petals to grow your strawberry. hire wisps to gather petals.  draw moths to the flame to hire stronger allies.  sweet smelling incense will make the strawberry smell juicier.  tonight, the forest will know peace.  tonight the forest will know . . . . . . . . the midnight faerie",
}

 player = {
  x=62,
  y=25,
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
 
 original_prices = {
  mushroom = 10,
  wisp = 10,  
  match = 25,
  moth = 40
 }
 
 prices = {
  mushroom = original_prices.mushroom,
  wisp = original_prices.wisp/2,
  match = original_prices.match,
  moth = original_prices.moth
 }
 
 menu_items = {}
 menu_items[1] = "berry  " .. prices.mushroom
 menu_items[2] = "wisp    " .. prices.wisp
 menu_items[3] = "match  " .. prices.match

 
 daffs = {} -- table of daffodils
 daffcount = 0
 
 lilacs = {} -- table of lilacs
 lilaccount = 0

 rosebushes = {}
 rosebushcount = 0
 
 venus = {}
 venuscount = 0
 
 incense  = {}
 incensecount = 0
 
 venus_map = {
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
		2,1,2,1,2,1,0,0,0,0,0,2,0,1,0,2,
		0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,1,
		0,1,1,1,1,1,0,0,0,0,0,1,0,1,0,1,
		0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,1,
		0,1,0,1,1,1,0,0,0,0,0,1,0,1,0,1,
		0,1,0,0,0,1,0,0,0,0,0,1,0,1,1,1,
		1,1,1,1,0,1,0,0,0,0,0,1,0,0,0,0,
		0,0,0,1,0,1,0,0,0,0,0,1,0,1,0,0,
		1,1,1,1,0,1,0,0,0,0,0,1,0,1,0,0,
		0,0,0,0,0,1,0,0,0,0,0,1,0,1,0,1,
		0,1,1,2,2,2,0,0,0,0,0,2,0,2,0,0,
		0,1,0,0,0,2,0,0,0,0,0,2,0,2,2,2,
		0,0,0,1,0,2,0,0,0,0,0,2,0,0,0,0
 }
 
 logs= {}
 logcount=0
 
 wisps = {}
 moths = {}
 
 fairycircle = {
  x=56,
  y=0,
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
  y=58,
  hitbox_x=0,
  hitbox_y=0,
  hitbox_w=2,
  hitbox_h=2,
  hp=0,
  size=1,
 }
  
 cyclops = {
  x=32,
  y=128,
  hitbox_x=0,
  hitbox_y=0,
  hitbox_w=64,
  hitbox_h=32,
  frame=0,
  hp=1000,
  speed=56/(30*30), --56 pixels divided by (30 seconds times 30 frames per second)
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

function new_venus(x,y,venus_color)
 venuscount +=1
 venus[venuscount] = obj:new()
 venus[venuscount].x = x
 venus[venuscount].y = y
 venus[venuscount].hitbox_x = 0
 venus[venuscount].hitbox_y = 0
 venus[venuscount].hitbox_w = 8
 venus[venuscount].hitbox_h = 8
 venus[venuscount].frame = flr(rnd(22))
 venus[venuscount].sprite = 204
 venus[venuscount].sprite_offset = 0
 if venus_color=="red" then venus[venuscount].sprite_offset = 16 end
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
  wisps[gamestate.wisps].y=flr(rnd(15))
end

function new_moth()
  gamestate.moths += 1
  moths[gamestate.moths] = obj:new()
  moths[gamestate.moths].frame = 0
  moths[gamestate.moths].maxframe = 30
  moths[gamestate.moths].addpetals = 5  --default 5
  moths[gamestate.moths].y = flr(rnd(15))
end


function new_incense(x,y)
  incensecount += 1
  incense[incensecount] = obj:new()
  incense[incensecount].sprite = 24
  incense[incensecount].x = x
  incense[incensecount].y = y
  incense[incensecount].lit = false
  incense[incensecount].frame = 0
  incense[incensecount].hitbox_x = 1
  incense[incensecount].hitbox_y = 1
  incense[incensecount].hitbox_w = 6
  incense[incensecount].hitbox_h = 6
end






-- other initialization functions

function init_flowers() 
 local count_x = 0
 local count_y = 0
 for i=0,255 do
   if count_x >= 16 then
     count_x = 0
     count_y += 1
   end
   if venus_map[i] == 1 then new_venus(count_x*8,count_y*8,"yellow") end
   if venus_map[i] == 2 then new_venus(count_x*8,count_y*8,"red") end
   count_x += 1
 end
end

function init_incense()
  new_incense(40,120)
  new_incense(120,120)
end

function init_cloud()
 for i=0,15 do
   cloud[i] = 0
 end
 for i=16,255 do
  cloud[i] = 1
 end
 cloud[23]=0
 cloud[24]=0
 cloud[39]=0
 cloud[40]=0
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
  for this_flower in all(venus) do
    if collide(player,this_flower) == true then didcollide = true end
  end
  for this_bush in all(rosebushes) do
    if collide(player,this_bush) == true then 
      didcollide = true
      cloud[0]=0
      cloud[1]=0
      cloud[16]=0
      cloud[17]=0
      cloud[32]=0
      cloud[33]=0
     if player.petals == 0 and this_bush.petals > 0 then
       player.petals +=1
       this_bush.petals -= 1
     end
    end
  end
  for this_incense in all(incense) do
    if collide(player, this_incense) == true then 
     check_incense(this_incense)
     didcollide = true
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
     menu_items[4] = "moth   " .. prices.moth
     menu.items += 1
     player.matches -= 1
     candle.lit = true
   end
   didcollide = true
  end
 return didcollide
end

function check_incense(this_i)
  if this_i.lit == false and player.matches > 0 then
    player.matches -= 1
    if gamestate.incense_lit < 1 then mushroom.hp += 250 else mushroom.hp += 500 end
    gamestate.incense_lit += 1
    this_i.lit = true
  end
end





--update functions

function update_game()
 if gamestate.frame >= 30 then
  gamestate.frame = 0
  if gamestate.timeleft > 0 then gamestate.timeleft -= 1 end
 end
 gamestate.frame += 1
 update_mushroom()
 update_flowers()
 update_candle()
 update_bugs()
 update_incense()
 update_cyclops()
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

function update_title_screen() 
 if ( title.state == 1 and title.transition_frame == 8 ) then
  gamestate.mode=1
  title.state=0
  title.transition_frame=0
  music(0,200)
 end
 if title.state == 1 then
   title.transition_frame += 1
 end
 if btnp(4) then
   if title.state==0 then title.state=1 end
 end
 if btnp(5) then
   if title.state==0 then title.state=1 end
 end
 if title.fairy_frame >= 150 then title.fairy_frame = 0 end
 if title.fairy_frame < 75 then title.fairy_y += 0.2 else title.fairy_y -= 0.2 end
 title.fairy_frame += 1 
 title.cloud_x += 0.5
 if title.cloud_x >= 80 then title.cloud_x = -18 end
end


function update_viewport()
 viewport.x=player.x-29
 viewport.y=player.y-29
 if viewport.x < 0 then viewport.x=0 end
 if viewport.x > 64 then viewport.x=64 end
 if viewport.y < 0 then viewport.y=0 end
 if viewport.y > 64 then viewport.y=64 end
end

function update_flowers()
  for this_venus in all(venus) do
    if this_venus.frame >= 24 then this_venus.frame = 0 end
    if this_venus.frame < 12 then this_venus.sprite = 204 else this_venus.sprite = 205 end
    this_venus.frame += 1    
  end  
end

function update_candle()
 if candle.lit == true then
  if candle.frame >=14 then candle.frame = 0 end
  if candle.frame <7 then candle.sprite=19 else candle.sprite=20 end
  candle.frame += 1
 end
end

function update_mushroom()
 -- 0 small mushroom
 -- 250 med. mushroom plain
 -- 500 med. mushroom dots
 -- 750 lg mushroom plain
 -- 1000 lg mushroom dots
 if mushroom.hp > 999 then
    mushroom.size = 5
    mushroom.hitbox_x = 0
    mushroom.hitbox_y = 0
    mushroom.hitbox_w = 16
    mushroom.hitbox_h = 16
    mushroom.x = 56
    mushroom.y = 48
  else
    if mushroom.hp > 749 then
      mushroom.size = 4
      mushroom.hitbox_x = 0
      mushroom.hitbox_y = 0
      mushroom.hitbox_w = 16
      mushroom.hitbox_h = 16
      mushroom.x = 56
      mushroom.y = 48
    else
      if mushroom.hp > 499 then
        mushroom.size = 3
        mushroom.hitbox_x = 0
        mushroom.hitbox_y = 0
        mushroom.hitbox_w = 8
        mushroom.hitbox_h = 8
        mushroom.x = 60
        mushroom.y = 56
      else
        if mushroom.hp > 249 then
          mushroom.size = 2
          mushroom.hitbox_x = 0
          mushroom.hitbox_y = 0
          mushroom.hitbox_w = 8
          mushroom.hitbox_h = 8
          mushroom.x = 60
          mushroom.y = 56
        end
      end
    end
  end
end

function update_bugs()
  for this_moth in all(moths) do
    if this_moth.frame >= 30 then
      gamestate.petals += this_moth.addpetals
      this_moth.frame = 0
    end
    if this_moth.frame < 15 then
     this_moth.x = 64 - (52*(this_moth.frame/15))
    else
     this_moth.x = 12 + (52*((this_moth.frame-15)/15))
    end
    this_moth.frame += 1
  end
  for this_wisp in all(wisps) do
    if this_wisp.frame >= 30 then
      gamestate.petals += this_wisp.addpetals
      this_wisp.frame = 0
    end
    if this_wisp.frame < 15 then
     this_wisp.x = 64 - (52*(this_wisp.frame/15))
    else
     this_wisp.x = 12 + (52*((this_wisp.frame-15)/15))
    end
    this_wisp.frame += 1
    -- print ("x " .. this_wisp.x .. " y " .. this_wisp.y .. " f " .. this_wisp.frame)
  end
end

function update_incense()
  for this_stench in all(incense) do
    if this_stench.lit == true then
      if this_stench.frame >= 18 then this_stench.frame = 0 end
      if this_stench.frame < 9 then this_stench.sprite = 25 else this_stench.sprite = 26 end
      this_stench.frame += 1
    end
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
 if cloud_loc-17 >= 0 then cloud[cloud_loc-17] = 0 end
 if cloud_loc-15 >= 0 then cloud[cloud_loc-15] = 0 end
 if cloud_loc+15 <= 255 then cloud[cloud_loc+15] = 0 end
 if cloud_loc+17 <= 255 then cloud[cloud_loc+17] = 0 end
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
        mushroom.hp += 1 --default 1
        gamestate.petals -= prices.mushroom
        gamestate.shroom_price_hike *= gamestate.hike_rate
        update_prices()
      else 
        sfx(0)
      end
    end -- end position 1
  if menu.position == 2 then
    if gamestate.petals >= prices.wisp then
        new_wisp()
        gamestate.petals -= prices.wisp
        gamestate.bug_price_hike *= gamestate.hike_rate
        update_prices()
      else 
        sfx(0)
      end
    end -- end position 2
  if menu.position == 3 then
    if (gamestate.petals >= prices.match and player.matches < 1)then
        player.matches += 1
        gamestate.matches_bought += 1
        gamestate.petals -= prices.match
        update_prices()
      else 
        sfx(0)
      end
    end -- end position 3
  if menu.position == 4 then
    if gamestate.petals >= prices.moth then
        new_moth()
        gamestate.petals -= prices.moth
        gamestate.bug_price_hike *= gamestate.hike_rate
        update_prices()
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

function update_cyclops() 
  if gamestate.timeleft <= 30 then
   if cyclops.frame >= 56 then cyclops.frame = 0 end
   cyclops.y -= cyclops.speed
   cyclops.frame += 1
  end
  if collide(cyclops,mushroom) then
    if mushroom.hp >= 1000 then
     gamestate.victory = true
     music(-1,500)
     gamestate.mode=3
    end
  end
  if collide(cyclops,fairycircle) then
    gamestate.victory = false
    music(-1,500)
    gamestate.mode=3
  end
end

function update_prices()
  prices.mushroom = flr(gamestate.shroom_price_hike * original_prices.mushroom)
  prices.wisp = flr(gamestate.bug_price_hike * original_prices.wisp)
  if gamestate.matches_bought == 0 then prices.match = 25 end
  if gamestate.matches_bought == 1 then prices.match = 2500 end
  if gamestate.matches_bought >= 2 then prices.match = 5000 end
  menu_items[1] = "berry  " .. prices.mushroom
  menu_items[2] = "wisp   " .. prices.wisp
  menu_items[3] = "match  " .. prices.match
  if candle.lit == true then
   prices.moth = flr(gamestate.bug_price_hike * original_prices.moth)
   menu_items[4] = "moth   " .. prices.moth
  end
end




-- draw functions

function draw_game()
 clip(0,6,128,122)
 map(0,0,0,0,16,16,0)
 map(16,0,0,0,16,16,0)
 draw_flowers()
 draw_mushroom()
 draw_cloud()
 if gamestate.timeleft < 31 then draw_cyclops() end
 draw_bugs()
 clip()
 draw_header()
 spr(player.sprite,player.x,player.y)
end


function draw_title_screen()
 camera(0,0)
 spr(66,54,2)
 for i=0, 8 do   
   spr(96+i,i*8,48)
   spr(112+i,i*8,56)
 end
 spr(64,title.cloud_x,title.cloud_y)
 spr(65,title.cloud_x+8,title.cloud_y)
end

function draw_bugs()
  for this_moth in all(moths) do
    if this_moth.frame < 15 then pset(this_moth.x + (rnd(3)-2),this_moth.y + (this_moth.frame/2),6) else pset(this_moth.x + (rnd(3)-2),this_moth.y + (7.5 - ((this_moth.frame)-15)/2),6) end
  end
  for this_wisp in all(wisps) do
    if this_wisp.frame < 15 then pset(this_wisp.x + (rnd(3)-2),this_wisp.y + (this_wisp.frame/2),12) else pset(this_wisp.x + (rnd(3)-2),this_wisp.y + (7.5 - ((this_wisp.frame)-15)/2),12) end
  end
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
 spr(128,7+viewport.x,39+viewport.y)
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
  for this_flower in all(venus) do
    spr(this_flower.sprite + this_flower.sprite_offset, this_flower.x, this_flower.y)
  end
  for this_stench in all(incense) do
    spr(this_stench.sprite,this_stench.x,this_stench.y)
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

function draw_cyclops()
  if cyclops.frame < 28 then
    sspr(104,24,24,8,32,cyclops.y,64,16)
  else
    sspr(104,24,24,8,32,cyclops.y,64,16,true,false)
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

function draw_mushroom()
  if mushroom.size <=3 then
    spr(127+mushroom.size,mushroom.x,mushroom.y)
  end
  if mushroom.size == 4 then
    sspr(0,72,16,16,mushroom.x,mushroom.y)
  end
  if mushroom.size == 5 then
    sspr(16,72,16,16,mushroom.x,mushroom.y)
  end
end



function draw_menu_fairy()
  local x = title.fairy_x
  local y = title.fairy_y
  for i=0,4 do
    spr(71+i,x+(i*8),y)
    spr(87+i,x+(i*8),y+8)
    spr(104,x+8,y+16)
    spr(105,x+16,y+16)
    spr(120,x+8,y+24)
    spr(121,x+16,y+24)
  end
end

function draw_title_msg()
 local msglen = #title.bigmsg
 if title.msg_frame > (msglen * 4) + 64 then title.msg_frame = -64 end
 color(13)
 print(title.bigmsg,1 -title.msg_frame, 59)
 clip(0,58,64,3)
 color(1)
 print(title.bigmsg,0 -title.msg_frame, 58)
 clip(0,61,64,3)
 color(2)
 print(title.bigmsg,0 -title.msg_frame, 58)
 clip()
 title.msg_frame += (1/title.msg_speed)
end



function draw_game_over()
 camera(0,0)
 if gamestate.victory == true then
   color(12)
   print("you win!",16,29)
 else
   color(8)
   print("you lose",16,29)
 end
end




-- crucial game functions


function _init()
  cls()
  poke(0x5f2c,3)
  init_world()
  init_cloud()
  init_flowers()
  init_incense()
  new_rosebush(8,8,false,500)
  gamestate.timeleft = 31
end

function _update()
 if gamestate.mode == 0 then
  update_title_screen()
 end
 if gamestate.mode==1 then
  update_player()
  update_cloud()
  update_game()  
 else
   if gamestate.mode==2 then
    update_game()
    update_menu()
      else if gamestate.mode== 3 then
        draw_game_over()
      end
   end
 end
end


function _draw()
 cls()
 if gamestate.mode == 0 then
   draw_title_screen()
   draw_menu_fairy()
   color(0)
   print("midnight",3,5)
   print("faerie",3,11)
   color(2)
   print("midnight",2,4)
   color(12)
   print("faerie",2,10)
   draw_title_msg()
 end
 if gamestate.mode == 1 then
  draw_game()
 end
 if gamestate.mode == 2 then
  draw_game()
  draw_menu()  
 end
 if gamestate.mode == 3 then
   draw_game_over()
 end
end