pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- sky knight demo --
-- main callbacks

function _init()

end

function _draw()
	cls()
	
	draw_stars()
	
	spr(p.s, p.x, p.y)
	
	draw_bullets()
	
	
end

function _update()
	move_player()
	
	if btnp(❎) then
		shoot()
	end
	
	if time() % 0.5 == 0 then
		add_star()
	end
end

-->8
-- player

p = {x=8, y = 63, s=1,
					spd = 3}
					
bullets = {}
cooldown = 0

function move_player()
	
	if cooldown > 0 then
		cooldown -= 0.03
	end
	
	if btn(⬆️) then
		p.y -= p.spd
	elseif btn(⬇️) then
		p.y += p.spd
	elseif btn(⬆️) and btn(⬇️) then
	
	end
	
	if p.y < 0 then p.y = 0 end
	if p.y > 120 then p.y = 120 end
	
end

function shoot()
	if cooldown > 0 then
		return
	end
	
	add(bullets,{x=p.x, y=p.y})
	cooldown = 0.2
	
end

function draw_bullets()
	
	for b in all(bullets) do
		spr(3, b.x, b.y)
		b.x += 3
		
		if b.x > 128 then
			del(bullets, b)
		end
	end
	
end


-->8
-- world

stars = {}

function add_star()
	add(stars, {x=128, y=rnd(128)})
end

function draw_stars()
	
	for s in all(stars) do
		spr(4, s.x, s.y)
		s.x -= p.spd
		if s.x < 0 then del(stars, s) end
	end
	
end

-->8
-- enemy
-->8
-- util
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d60000000001555700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000660000000000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000067cc000133bb0000998700000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000086676600cc37b0000998700000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000d5555660133700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
