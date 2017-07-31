generic_object = {
 x=0,
 y=0,
 sprite=0,
 hitbox_x=0,
 hitbox_y=0,
 hitbox_w=8,
 hitbox_h=8
}

function generic_object:new(o)
 o = o or {}
 setmetatable(o,self)
 self.__index = self
 return o
end

function generic_object:draw()
  spr(self.sprite, self.x, self.y)
end

cats=0
dogs=0

catlist={}
doglist={}

function newdog()
 dogs+=1
 doglist[dogs] = generic_object:new()
 doglist[dogs].lives = 1
 doglist[dogs].x = (dogs-1)*16
 doglist[dogs].y = 8
 doglist[dogs].sprite=2
 doglist[dogs].sound = "woof"
end

function newcat()
 cats+=1
 catlist[cats] = generic_object:new()
 catlist[cats].lives = 9
 catlist[cats].x = (cats-1) * 11
 catlist[cats].y = 24
 catlist[cats].sound="mew"
 catlist[cats].sprite=1
end


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




function _init()
  for i=1,3 do
   newdog()
  end
  for i=1,9 do
   newcat()
  end
  doglist[2].sound = "grrr"
end

function _update()
end

function _draw()
 cls()
 local petnumber=0
 for this_cat in all(catlist) do
  petnumber+=1
  this_cat:draw()  
  print("cat " .. petnumber .. " has " .. this_cat.lives .. " lives & says " .. this_cat.sound, 0, (petnumber*7)+33)
 end
 petnumber=0
 for this_dog in all(doglist) do
  petnumber+=1
   this_dog:draw()
   print("dog " .. petnumber .. " has " .. this_dog.lives .. " lives & says " .. this_dog.sound, 0, (petnumber*7)+96)
 end 
end