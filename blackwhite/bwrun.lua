-- 

--Object Functions
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

player = obj:new()

--Player Functions

function player:draw()
  --spr(player.sprite,player.x,player.y,1,2,player.flipped,false)
  sspr(player.sprite*8,0,4,16,player.x,player.y,4,16,player.flipped,false)
end

function draw_player_shadow()
 --spr(player.sprite+32,player.x,player.y,1,2,player.flipped,false)
 sspr(player.sprite*8,16,4,16,player.x,player.y,4,16,player.flipped,false)
end

function player_landed()
 local returnvalue = false
 if player.y >=48 then returnvalue = true end
 return returnvalue
end


function player:update()
  local original_x = player.x
  local original_y = player.y  
  local shadow_move = 0
  local bg_move =0
  player.sprite = 2
  
  if btnp(4) and player.jumping == false then   
   player.arc = player.jump_height        
   player.y -= 4
   player.jumping = true
  end
  if btn(0) then
    player.x -= player.speed
    player.flipped = true
    player_walksprite()
    bg_move += 1
    shadow_move += player.speed    
    check_player_collisions(original_x,original_y)
  end
  if btn(1) then
    player.x += player.speed
    player.flipped = false
    player_walksprite()
    bg_move -= 1
    shadow_move -= player.speed    
    check_player_collisions(original_x,original_y)
  end
  if player.jumping == true then
    player.y -= player.arc
    player.arc -= gamestate.gravity
    player_walksprite()
    check_player_collisions(original_x,original_y)
  end
  if player_landed() == true then
    player.y = 48
    player.jumping = false
  end
  if player.x ~= original_x then
    update_background(bg_move)
    shadow.x += shadow_move
  end
  player.frame += 1
end

function player_walksprite()
  if player.frame >= 10 then player.frame = 0 end
  if player.frame < 2 then player.sprite = 2 end
  if (player.frame >= 2 and player.frame < 5) then player.sprite = 3 end
  if (player.frame >= 5 and player.frame < 7) then player.sprite = 2 end
  if player.frame >=  7 then player.sprite = 4 end
  if (player.jumping == true and player.arc > 0) then player.sprite = 5 end
  if (player.jumping == true and player.arc < 0) then player.sprite = 6 end
end

function init_player()
 player.sprite = 2
 player.shadow = 17
 player.x = 8
 player.y = 48
 player.flipped = false
 player.jumping = false
 player.arc = 0
 player.jump_height = 2.75
 player.frame=0
 player.speed = 1
 player.hitbox_x = 0
 player.hitbox_y = 0
 player.hitbox_w = 4
 player.hitbox_h = 16
end

--Shadow Functions


shadow = obj:new()

function shadow:draw()
 local x = shadow.x + viewport.x
 clip(shadow.x,0,16,64)
 rectfill(x,0,x+16,64,0)
 draw_gameblocks_shadow()
 draw_player_shadow() 
 clip(0,0,64,64)
end

function shadow:update()
 if shadow.x <= shadow.end_x then shadow.x = shadow.start_x end
 shadow.x -= shadow.speed
end


function init_shadow()
 shadow.y = 0 
 shadow.start_x = 80
 shadow.end_x = -24
 shadow.x = shadow.start_x
 shadow.speed = 24/30
end


--background map functions
function init_background()
  bg = {
    x=0,
    w=9,
    h=8,
    speed = 16/30
  }
end

function update_background(amount)
  bg.x += (amount * bg.speed)
  if bg.x <= -15 then bg.x=0 end
  if bg.x > 0 then bg.x = (-15 + bg.speed) end
end

function draw_background()
  map(0,0,bg.x + viewport.x,0,10,8)
end


--gameblock functions
function create_gameblock(x,y)
  blockcount += 1
  blocks[blockcount] = obj:new()
  blocks[blockcount].x = x
  blocks[blockcount].y = y
  blocks[blockcount].sprite = 33
  blocks[blockcount].hitbox_x = 0
  blocks[blockcount].hitbox_y = 0
  blocks[blockcount].hitbox_w = 8
  blocks[blockcount].hitbox_h = 8
  blocks[blockcount].id = blockcount
end

function draw_gameblocks()
  clip(0,0,64,64)
  for this_block in all(blocks) do
    spr(this_block.sprite,this_block.x,this_block.y)
  end
  clip()
end

function draw_gameblocks_shadow()
  for this_block in all(blocks) do
    spr(this_block.sprite+16,this_block.x,this_block.y)
  end
end







--viewport functions
function init_viewport()
  viewport = {
    x = 0,
    y = 0
  }
end

function update_viewport()
  viewport.x = player.x - 16
  if viewport.x < 0 then viewport.x = 0 end
end



-- world initiation

function init_world()
 gamestate = {
   gravity = (1/6),
 }
 init_player()
 init_shadow()
 init_background()
 debugmsg=""
 
 blocks = {}
 blockcount = 0
 
 blocktop = {}
 blocktopcount = 0
end



--update functions









--collision!
function collide(obj, other)
  if
    other.x+other.hitbox_x+other.hitbox_w > obj.x+obj.hitbox_x and 
    other.y+other.hitbox_y+other.hitbox_h > obj.y+obj.hitbox_y and
    other.x+other.hitbox_x < obj.x+obj.hitbox_x+obj.hitbox_w and
    other.y+other.hitbox_y < obj.y+obj.hitbox_y+obj.hitbox_h 
  then
    return true
   else return false
  end
end

function check_player_collisions(original_x,original_y) 
 local standing_on = 0
 for this_block in all(blocks) do   
   if collide(player,this_block) == true then
     if flr(player.y + 16 ) >= this_block.y and flr(player.y + 16) <= this_block.y - (flr(player.arc)+1) and player.arc <= 0 then
      standing_on = this_block.id
     else
       player.x = original_x
     end
   else
     if player.y < 48 then player.jumping = true end
   end
 end
 if standing_on > 0 then
   player.jumping = false
   player.arc = 0
   player.y = blocks[standing_on].y - 16
   debugmsg = "by " .. blocks[standing_on].y .. " py " .. player.y
 else debugmsg = "py " .. player.y .. "pa " .. player.arc
 end
end











function _init()
 poke(0x5f2c,3)
 palt(4,true)
 palt(0,false)
 init_viewport()
 cls()
 init_world()
 create_gameblock(48,56)
 create_gameblock(64,56)
 create_gameblock(80,56)
 
 create_gameblock(112,41)
end

function _update()
 player:update()
 shadow:update()
 update_viewport()
end

function _draw()
 cls()
 camera(viewport.x,viewport.y)
 draw_background()
 draw_gameblocks()
 player:draw()
 shadow:draw()
 color(13)
 print(debugmsg,0+viewport.x,0)
end