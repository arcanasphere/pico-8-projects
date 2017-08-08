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
  spr(player.sprite,player.x,player.y,1,2)
end

function draw_player_shadow()
 spr(player.sprite+32,player.x,player.y,1,2)
end

function player_landed()
 local returnvalue = false
 if player.y >=48 then returnvalue = true end
 return returnvalue
end

function player:update()
  if btnp(4) and player.jumping == false then   
   player.jumping = true
   player.arc = player.jump_height  -- this sets the jump height
  end
  if player.jumping == true then
    debugmsg = "jump y:" .. player.y
    player.y -= player.arc
    player.arc -= gamestate.gravity
  end
  if player_landed() == true then
    player.y = 48
    player.jumping = false
    debugmsg = "jump y:" .. player.y
  end
  if player.frame >= 10 then player.frame = 0 end
  if player.frame < 2 then player.sprite = 2 end
  if (player.frame >= 2 and player.frame < 5) then player.sprite = 3 end
  if (player.frame >= 5 and player.frame < 7) then player.sprite = 2 end
  if player.frame >=  7 then player.sprite = 4 end
  if (player.jumping == true and player.arc > 0) then player.sprite = 5 end
  if (player.jumping == true and player.arc < 0) then player.sprite = 6 end
  player.frame += 1
end

function init_player()
 player.sprite = 2
 player.shadow = 17
 player.x = 8
 player.y = 48
 player.jumping = false
 player.arc = 0
 player.jump_height = 2.75
 player.frame=0
end

--Shadow Functions


shadow = obj:new()

function shadow:draw()
 clip(shadow.x,0,16,64)
 rectfill(shadow.x,0,shadow.x+16,64,0)
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
  }
end

function update_background()
  if bg.x <= -15 then bg.x=0 else bg.x -= (16/30) end
end

function draw_background()
  map(0,0,bg.x,0,10,8)
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
end



-- update functions















function _init()
 poke(0x5f2c,3)
 palt(4,true)
 palt(0,false)
 camera(0,0)
 cls()
 init_world()
end

function _update()
 update_background()
 player:update()
 shadow:update()
end

function _draw()
 --rectfill(0,0,64,64,7)
 draw_background()
 player:draw()
 shadow:draw()
 color(13)
 print(debugmsg,0,0)
end