pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
--midnight faerie
--#lowrezjam 2017 by arcanasphere

function init_world ()
 gamestate={
  mode=0, -- 0=into, 1=game, 2=menu, 3=end, 4=manual
  timeleft=240,
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
  fairy_flap=0,
  cloud_x = -18,
  cloud_y = 6,
  msg_frame=-64,
  msg_speed=2,
  bigmsg = "x=manual  z=start    x=manual  z=start        you are a faerie. every night at midnight, the cyclops stomps across your faerie circle. tonight you have a perfect plan. distract the cyclops with a giant strawberry. find the rose bush. use rose petals to grow your strawberry. hire wisps to gather petals. draw moths to the flame to hire stronger allies. sweet smelling incense will make the strawberry grow juicier. tonight, the fields will know peace. tonight the fields will know . . . . . . . . the midnight faerie",
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
  matches=0,
  alive=true,
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
  speed=64/(30*30), --56 pixels divided by (30 seconds times 30 frames per second)
 }

 manual = {
  page=1,
  pages=5,
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
     play_flame()
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
    play_flame()
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
 if title.fairy_flap >=24 then title.fairy_flap = 0 end
 title.fairy_flap += 1
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
   if title.state==0 then 
    title.state=1
    music(-1,250)
    play_select()
   end
 end
 if btnp(5) then
  gamestate.mode = 4
  music(-1,250)
  play_select()
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
    play_arrow()
  end
  if btnp(3) then
    if menu.position < menu.items then menu.position += 1 else menu.position = 1 end
    play_arrow()
  end
  if btnp(4) then
    if menu.position == 1 then
      if gamestate.petals >= prices.mushroom then
        mushroom.hp += 1 --default 1
        gamestate.petals -= prices.mushroom
        gamestate.shroom_price_hike *= gamestate.hike_rate
        update_prices()
        play_select()
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
        play_select()
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
        play_select()
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
        play_select()
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
  if collide(player,cyclops) then
    gamestate.victory = false
    player.alive = false
    music(-1,500)
    gamestate.mode=3
  end
end

function update_prices()
  prices.mushroom = flr(gamestate.shroom_price_hike * original_prices.mushroom)
  if (wisps==0 and moths==0) then prices.wisp = 5 else prices.wisp = flr(gamestate.bug_price_hike * original_prices.wisp) end
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

function update_game_over()
  if btnp(4) then
    reset_game()
    gamestate.mode=0
  end
end

function update_manual()
  player.frame += 1
  if player.frame >=16 then player.frame = 0 end
  if player.frame > 8 then player.sprite=2 else player.sprite=1 end
  if btnp(0) then
    if manual.page > 1 then manual.page -= 1 else manual.page = manual.pages end
  end
  if btnp(1) then
    if manual.page < manual.pages then manual.page += 1 else manual.page = 1 end
  end
  if btnp(4) then
    gamestate.mode = 0
    manual.page = 1
  end
  if btnp(5) then
    gamestate.mode = 4
    manual.page = 1
  end
end




-- draw functions

function draw_game()
 clip(0,6,64,58)
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
  for i=0,3 do
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
 clip(0,58,64,8)
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
   color(13)
   print("you win!",2,4)
   print("cyclops loves",2,10)
   print("its",2,16)
   color(14)
   print("strawberry",18,16)
   sspr(104,72,24,24,16,16,48,48)
 else
   if player.alive==true then
     draw_title_screen()
     sspr(32,64,16,8,24,56)
     color(8)
     print("you lose",16,6)
     print("your circle has",2,12)
     print("been crushed",8,18)
   else
    draw_title_screen()
    sspr(56,16,8,16,6,31,16,32)
    color(13)
    print("you have died",4,9)
    color(12)
    print("game over",4,15)
   end
 end
end

function draw_manual()
  if manual.page  == 1 then
    spr(player.sprite,0,0)
    color(13)
    print("you are a",6,0)
    print("fairy",6,6)
    color(6)
    print("at midnight a",0,12)
    print("cyclops crushes",0,18)
    print("your home.",0,24)
    color(13)
    print("but not tonight",2,36)
  end
  if manual.page  == 2 then
    spr(130,56,0)
    color(14)
    print("grow a",0,0)
    print("strawberry",0,6)
    color(6)
    print("feed the cyclops",0,16)
    print("save your home",0,22)
  end
  if manual.page == 3 then
    spr(32,0,0)
    spr(48,0,8)
    color(3)
    print("find the",10,0)
    print("rose bush",10,6)
    color(6)
    spr(192,48,16)
    spr(193,56,16)
    spr(208,48,24)
    spr(209,56,24)
    sspr(8,16,16,16,48,16)
    print("gather rose",0,18)
    print("petals and",0,24)
    print("return them",0,30)
    print("to your fairy",0,36)
    print("circle",0,42)
  end  
  if manual.page == 4 then
    color(12)
    print("hire helpers",8,0)
    spr(13,0,6)
    color(2)
    print("wisps carry 1",8,6)
    print("petal every",0,12)
    print("second.",0,18)
    spr(14,0,26)
    print("moths carry",8,26)
    print("even more petals",0,32)
  end
  if manual.page  == 5 then
    spr(17,0,0)
    color(9)
    print("buy matches",6,0)
    color(6)
    print("light candles",0,8)
    print("to attract moths",0,14)
    
    print("light incense",0,22)
    print("to boost growth",0,28)
    
    spr(18,24,40)
    spr(24,32,40)
   -- buy matches
  end
  line(0,57,64,57,13)
  color(1)
  spr(15,-3,59,8,8,true,false)
  spr(15,28,59)
  print("pages",6,59)
  print(manual.page .. "/" .. manual.pages,52,59)
end

--

-- sound effects
function play_arrow()
 sfx(11)
end

function play_select()
  sfx(12)
end

function play_flame()
 sfx(13)
end







------- new game

function reset_game()
  for this_wisp in all(wisps) do
    del(this_wisp)
  end
  wisps = {}
  for this_moth in all(moths) do
    del(this_moth)
  end
  moths = {}
  
  for this_stench in all(incense) do
    this_stench.lit=false
    this_stench.sprite = 24
  end
  
  gamestate.timeleft = 240
  gamestate.petals = 0
  player.petals = 0
  player.x = 62
  player.y = 25
  player.matches = 0
  gamestate.frame=0
  gamestate.petals=0
  gamestate.wisps=0
  gamestate.moths=0
  gamestate.matches_bought=0
  gamestate.incense_lit=0
  gamestate.victory = false
  
  gamestate.shroom_price_hike = 1
  gamestate.bug_price_hike = 1
  gamestate.match_price_hike = 1

  candle.sprite=18
  candle.lit=false

  prices.mushroom = original_prices.mushroom
  prices.wisp = original_prices.wisp/2
  prices.match = original_prices.match
  prices.moth = original_prices.moth
 
  mushroom.x=63
  mushroom.y=58
  mushroom.hitbox_x=0
  mushroom.hitbox_y=0
  mushroom.hitbox_w=2
  mushroom.hitbox_h=2
  mushroom.hp=0
  mushroom.size=1

  cyclops.x=32
  cyclops.y=128
  cyclops.frame=0
  
  for this_item in all(menu_items) do
    del(menu_items,this_item)
  end
  menu_items = {}
  menu_items[1] = "berry  " .. prices.mushroom
  menu_items[2] = "wisp    "  .. prices.wisp
  menu_items[3] = "match  " .. prices.match

  menu.items=3
  
  init_cloud()  
  
  music(8,125)
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
  music(8,125)
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
        update_game_over()
      end
   end
 end
 if gamestate.mode == 4 then update_manual() end
end


function _draw()
 cls()
 if gamestate.mode == 0 then
   draw_title_screen()
   if title.fairy_flap < 16 then draw_menu_fairy() else sspr(88,32,25,32,title.fairy_x+2,title.fairy_y) end
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
 if gamestate.mode == 4 then
   draw_manual()
 end
end
__gfx__
00000000c020c0000c2c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000d000007060700000d00000
00000000cc1cc000dc1cd0000000000000000000000000000000000000000000000000000000000000000000000000000000000001d100007767700000dd0000
00700700c010c0000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddcdd00077677000ccccd000
0007700000100000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000001d100007060700000dd0000
0007700000010000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d000000060000000d00000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
080000008000000000070000000a0000000700000f900000000990000009900070000000a0000000a00000000000000000000000000000000000000000000000
8880000004000000000700000098900000a89000fff90000009ff900009ff9005500000099000000aa0000000000000000000000000000000000000000000000
e880000000400000000f400000afa00000afa0009994000000f9990000f989005e5000009e400000ae4000000000000000000000000000000000000000000000
0e8800000004000000ff400000ff900000ffa000044000000999994009999940555e5000669e400066ae40000000000000000000000000000000000000000000
000000000000000000ff400000ff900000ffa000000000000999f9400989f9408ee555008ee944008eea44000000000000000000000000000000000000000000
000000000000000000ff400000ff900000ffa00000000000009994000099940055555e5066699e50666aae500000000000000000000000000000000000000000
000000000000000000f9400000f9900000faa0000000000000045000000450008eeee5e58eeee6e58eeee6e20000000000000000000000000000000000000000
000000000000000000f4400000f9900000f990000000000000044000000440008885555588866666888666220000000000000000000000000000000000000000
00bb5000000000bbbbb000000000099999990000000009999999000000666600000000000000000000000000005dc50000000000000000000000000000000000
5b33bb000000bb9000bb000000009ff99999400000009ff999994000066555600000000000000000000000000546745000000000000000000000000000000000
b3b35bb0000be000000be0000009f999999940000009f99999894000655555500000000000000000000000005446644500000000000000000000000000000000
5b3b3eb000bb00000000bb000009f999999940000009f98999994000556655560000000000000000000000005444444500000000000000000000000000000000
0bb3e8e500b000000000bbb00009f999999940000009f99999994000556565550000000000000000000000005444444500000000000000000000000000000000
0b3b3e3b0bc000b000b000bb009f999999999400009f999989999400556655550000000000000000000000005444444500000000000000000000000000000000
0bbeb3b50b000000b000009b009f999fff999400009f999fff999400556565550000000000000000000000055544445500000000000000000000000000000000
5be8e5b0bb0000000000000b09f999f99999994009f999f999989940555555550000000000000000000055555555555550000000000000000000000000000000
b3bebeb090000000b000000e09f99f999899999409f99f999999999455565555000000000000000000055445554554555555000000055445005dc50055550000
533be8e0b00000b00000000b9f999999999999999f99899999999999555655550000000000000000005545555544445554455000005545555546745554455000
0bb3beb5bb00000000b000bb09999999999994400999999989999440555555550000000000000000005555555544445555545500005555555446644555545500
0b3b353b0bb00000000000b000000999999000000000099999900000555566550000000000000000005555555544445555555500005555555444444555555500
5eb3b3b500b0000000000b9000000045550000000000004555000000555566550000000000000000005455555554455555554500005455555444444555554500
e8eb35b000bbe0000000bb0000000044450000000000004445000000555565500000000000000000000545555555555555545000000545555544445555545000
bebbb3b0000bbb00000bb00000000044450000000000004445000000555550000000000000000000000054445555555544450000000054445554455544450000
5b000b5000000bbcbbbe000000000044440000000000004444000000550000000000000000000000000005555000000555500000000005555005500555500000
00006666670000000077770000888800000000000000000000000000000011c000000222d2220000ccc000000002c000000222d2220000c11000000000000000
00d6666666700000076677700855888000000000000000000000000000011c1c0000222ccc220001111c000000011c0000222ccc220001111000000000000000
006666666667000077677677885885880000000000000000000000000011ccccc00022ccccc200011111c0000001ccc00022ccccc20001111000000000000000
0d666666666660007677766785888558000000000000000000000000001cc1ccc00022c2c2c20011ccc11c0000011cc00022c2c2c20011c11000000000000000
06d66666d76666007677777785888888000000000000000000000000001c1111c00022ccccc2001ccc111c00000111c00022ccccc2001c200000000000000000
666ddd666dd666667666767785558588000000000000000000000000001c11111c0022cddc02011cc111c0000000111c0022cddc02011c000000000000000000
d666666666666ddd0766777008558880000000000000000000000000001c11c11c02220cc002011c111100000000011c02220cc002011c000000000000000000
0dddddddddddd00000777700008888000000000000000000000000000011c11c1112220000c211c1111000000000011112220000c211c1000000000000000000
0000000000000000000000000000000000000000000000000000000000011111c1122dccccd0211111100000000001c1122dccccd02111000000000000000000
00000000000000000000000000000000000000000000000000000000000011111c11cddddddd1111c10000000000011c11cddddddd1111000000000000000000
00000000000000000000000000000000000000000000000000000000000011111111cddddddd11111c0000000000001111cddddddd1111000000000000000000
0000000000000000000000000000000000000000000000000000000000001c11111ccddddddd111111c00000000000111ccddddddd1111000000000000000000
000000000000000000000000000000000000000000000000000000000001c111111c02dddddc2111111c0000000001c11c02dddddc2111100000000000000000
0000000000000000000000000000000000000000000000000000000000021cc1110c002ddddc0221111c0000000011110c002ddddc0221110000000000000000
0000000000000000000000000000000000000000000000000000000000002111100cc02dcd0c0002111c0000000211100cc02dcd0c0002112000000000000000
00000000000000000000000000000000000000000000000000000000000002220001ccccdd0c0000222000000002220001ccccdd0c0000220000000000000000
00000000000000000000000000000000000000000000000000000000000000000000002ddd0c0000000000000000000000002ddd0c0000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000002ddd0c0000000000000000000000002ddd0c0000000000000000000000
00000011111111111100000000111111111110000000000000000000000000000000002ddd0c0000000000000000000000002ddd0c0000000000000000000000
1111111111111111111111111111111111111111111111110000000001111111000002dddd01c00000000000000000000002dddd01c000000000000000000000
111111153535353535111111111111111111111111111111111111111111111100002dddddd000000000000000000000002dddddd00000000000000000000000
53535353535353535353535353535353535353535353535311111111535353530000ddddddd00000000000000000000000ddddddd00000000000000000000000
353533333333333333333333333335353535353535353535353535353535353500000ddddddd00000000000000000000000ddddddd0000000000000000000000
533333333333333333333333333333335353333333333333535353535333535300000ddddddd00000000000000000000000ddddddd0000000000000000000000
333333333333333333333333333333333333333333333333353533333333353500000cc000cc00000000000000000000000cc000cc0000000000000000000000
333333333333333333333333333333333333333333333333333333333333335300000cc000ccc0000000000000000000000cc000ccc000000000000000000000
333333333333333333333333333333333333333333333333333333333333333500000cc0000cc0000000000000000000000cc0000cc000000000000000000000
333333333333333333333333333333333333333333333333333333333333333300000cc0000cc0000000000000000000000cc0000cc000000000000000000000
3333333333333333333333333333333333333333333333333333333333333333000000c0000cc00000000000000000000000c0000cc000000000000000000000
3333333333333333333333333333333333333333333333333333333333333333000000c00000c00000000000000000000000c00000c000000000000000000000
3333333333333333333333333333333333333333333333333333333333333333000000c00000c00000000000000000000000c00000c000000000000000000000
33333333333333333333333333333333333333333333333333333333333333330000002d00002d00000000000000000000002d00002d00000000000000000000
b0000000b0000000bb000000000000000090000d0055000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08e00000388e0000b881000000000000099500dd5555002000000000000000000000000000000000000000000000000000000000000000000000000000000000
028000003888ee003888ee0000000000000555000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000088888ee088988ee000000000000005500000005500000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888e0888888e000000000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000
000000002888888e2888988e00000000000055500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000228888e0228888e00000000885550000005550000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000002222880022228800000000080000000155000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbb000000000000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3b0000000000000b3b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb88eeeee0000000bb88eeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b88888888ee00000b88888888ee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888e000088888888888e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005555000
888888888888e000888898889888e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055555500
898888ee88888000898888ee888880000000000000000000000000000000000000000000000000000000000000000000000000000000b0000000000577445500
88888888e8888e0088888888e8888e0000000000000000000000000000000000000000000000000000000000000000000000000000000b088000000587444550
888888888e888800888888888e888800000000000000000000000000000000000000000000000000000000000000000000000000000000888880000544444450
8888888888e888e08888889888e888e000000000000000000000000000000000000000000000000000000000000000000000000000000888a888000544544450
888888888888888e888888888888888e000000000000000000000000000000000000000000000000000000000000000000000000000008888888800555544450
28888888888888882898288888888888000000000000000000000000000000000000000000000000000000000000000000000000000000888555500555444450
28888888888988882888828898898888000000000000000000000000000000000000000000000000000000000000000000000000000000005545000055555500
22888888888888882288882222288888000000000000000000000000000000000000000000000000000000000000000000000000000000055445000000544500
02288888888888880228888888888888000000000000000000000000000000000000000000000000000000000000000000000000000000055445500005444550
00222222222222200022222222222220000000000000000000000000000000000000000000000000000000000000000000000000000000055444555554444455
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005544444455544445
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000554444444554445
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055444444454445
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005444444554445
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005544444544445
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555455544445
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005554444445
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000054444445
3333335335333353515151513131313131000000000000310000000000000000000000000000000000000000000000000a0990a0aa09a09099000000002222c0
353335333333353315151515131313131300000000000013000000000000000000000000000000000000000000000000099949000999490009a009a00ddccdc0
5333333353333333515151513131313131000000000000310000000000000000000000000000000000000000000000000099900000999a00099a99000dd22dc0
333333353333533515151515131313131300000000000013000000000000000000000000000000000000000000000000d00d0a0dd00d00d09a9390000dd2dc00
333353333335333351515151313131313100000000000031000000000000000000000000000000000000000000000000d0ddd00dd0dd100d00999a0000dddc00
33333333333333331515151513131313130000000000001300000000000000000000000000000000000000000000000010dd0001101d0001000d0900000dc000
335333333353333351515151313131313100000000000031313131310000000000000000000000000000000000000000100d10d0100d10d0000d0000000dd000
35333353353333531515151513131313130000000000001313131313000000000000000000000000000000000000000001ddd11001ddd11000dd0000000dd000
353333533333335311111111313131313131313100000031310000000000000000000000000000000000000000000000000880000d02880000d00000001dd000
333335333533353311111111131313131313131300000013130000000000000000000000000000000000000000000000d0022800d00228d000d00000011d1000
533333335333333311111111310000000000003100000031310000000000000000000000000000000000000000000000d000d00dd00010d0001d0000001d1000
3333533533333335111111111300000000000013000000131300000000000000000000000000000000000000000000001d00d00d1d00d00d0010000000111000
3335333333335333111111113100000000000031000000313100000000000000000000000000000000000000000000001d00d00d1d00d00d0110000001111000
3333333333333333111111111300000000000013000000131300000000000000000000000000000000000000000000001dd0101d1dd0101d0010000000111000
33533333335333331111111131000000000000313131313131313131000000000000000000000000000000000000000001d01d1d01d01d1d0011000000110000
353333533533335311111111130000000000001313131313131313130000000000000000000000000000000000000000001dd1d0001dd1d00001000000010000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06077777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005444444
00600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000054445445
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055544445
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000054444455
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000045555550
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
c0c1c0c1c0c1c0c1c0c1c0c1c0c1c0c1c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d1d0d1d0d1d0d1d0d1d0d1d0d1d0d1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c0c1c0c1c0c1c0c1c0c1c0c1c0c1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d1d0d1d0d1d0d1d0d1d0d1d0d1d0d1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c0c1c0c1c0c1c0c1c0c1c0c1c0c1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d1d0d1d0d1d0d1d0d1d0d1d0d1d0d1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c0c1c0c1c0c1c0c1c0c1c0c1c0c1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d1d0d1d0d1d0d1d0d1d0d1d0d1d0d1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c0c1c0c1c0c1c0c1c0c1c0c1c0c1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d1d0d1d0d1d0d1d0d1d0d1d0d1d0d1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c0c1c0c1c0c1c0c1c0c1c0c1c0c1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d1d0d1d0d1d0d1d0d1d0d1d0d1d0d1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c0c1c0c1c0c1c0c1c0c1c0c1c0c1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d1d0d1d0d1d0d1d0d1d0d1d0d1d0d1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0c1c0c1c0c1c0c1c0c1c0c1c0c1c0c1c40000000000000000000000000000c5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d1d0d1d0d1d0d1d0d1d0d1d0d1d0d1d6c6c6c6c6c6c6c6c6c6c6c6c6c6c6d5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010800000f350163000f3500f35000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
013000001c2141c2121c2121c211152111521221211212111c2111c2111c2111c2111c2111c2111c2111c2151c2141c2111c2121c212152111521223211232122821128212282122821228211282112821128215
0130000028414284122841228412214112141223411234121c4111c4121c4121c4121c4121c4121c4121c41528414284122841228412214112141223411234122d4112d4122d4122d4122d4122d4122d4122d415
01300000107201572017720000000000000000000000000010720157201c725000000000000000000000000010720177201c720157150000000000000000000015720177201c7200000000000000000000000000
01300000217201c720177200000000000000000000000000217201c720237201c72000000000000000000000217201c7201572000000000000000000000000001c72017700177200000015720000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
013000002821428212282122821123211232122121121211232112321223212232122321223212232122321528214282112821228212152111521223211232122821128212282122821228211282112821128215
01300000282142821228212282111c2111c21221211212112321123212232122321223212232122321223215282142821128212282122f2112f2122d2112d2122821128212282122821228212282122821228215
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010400002102023030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010600002f12434155341050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01100000096240b621106210962500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
018000000261402611046110661106621056210462102611026110161101611026120161101611016110161101611016110361104611056110662106621076110862107621066110461103611016110161102614
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 03424344
00 04424344
00 03014344
00 04024344
00 03074344
00 04084344
00 41074344
02 41024344
03 10424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344

