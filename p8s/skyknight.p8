pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- sky knight demo --
-- main callbacks

state = "play"

function _init()
end

function _draw()
	cls()
	
	draw_stars()
	
	spr(p.s, p.x, p.y)
	
	draw_enemies()
	draw_bullets()
	draw_explosions()

	print("score:"..score,0,0,7)
	
	if state == "game over" then
		
		rectfill(16,16,112,112,1)
		print("you died!", 18,18,7)
		print("press ctrl + r",18,26,7) 
		print("to play again",18,34,7)
		
	end
	
end

function _update()
	
	if state == "play" then
		
		move_player()
	
			if btnp(❎) then
				shoot()
			end
	end
	
	if time() % 0.5 == 0 then
		add_star()
	end
	
	if time() % 1 == 0 then
		if rnd(10) > 3 then
			add_enemy()
		end
	end
	
	bullet_collide()
	player_collide()
	
end

-->8
-- player

score = 0

p = {x=8, y = 63, s=1,
					spd = 1}
					
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

explosions = {}

function add_explosion(x,y)
	add(explosions, {x=x,y=y, s=5})
end

function draw_explosions()
	for e in all(explosions) do
		spr(e.s, e.x, e.y)
		e.x -= 0.7
		e.y += 0.5
		if time() % 0.5 == 0 then
			if e.s > 7 then
				del(explosions, e)
			end
			e.s += 1
		end
		
	end
end

-->8
-- enemy

enemies = {}

function add_enemy()
	add(enemies, 
		{x=128, y=p.y + 15 - rnd(30)}
		)
end

function draw_enemies()
	for e in all(enemies) do
		spr(2, e.x, e.y)
		e.x -= 1
		
		if e.x < 0 then
			del(enemies, e)
		end
	end
end
-->8
-- util

function bullet_collide()
	for b in all(bullets) do
		for e in all(enemies) do
			
			if e.x > b.x and e.x < b.x + 7
				and e.y > b.y and e.y < b.y + 7 then
					
					del(enemies, e)
					del(bullets, b)
					add_explosion(e.x, e.y)
					score += 1
				end		
		end
	end
end

function player_collide()
	for e in all(enemies) do
		if p.x+5 >= e.x and p.x+5 <= e.x +7
			and p.y+5 >= e.y and p.y+5 <= e.y +7 
		then
			add_explosion(p.x, p.y)
			state = "game over"
			p.x = -100
			p.y = -100
		end
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000
00000000d600000000015557000000000000000000000000070000000088808a0000000000000000000000000000000000000000000000000000000000000000
007007000660000000000b00000000000000000000000000000888a0088880000000000000000000000000000000000000000000000000000000000000000000
000770000067cc000133bb0000998700000070000007800000878000080000000000000000000000000000000000000000000000000000000000000000000000
00077000086676600cc37b0000998700000777000008880007888880700008880000000000000000000000000000000000000000000000000000000000000000
007007000d55556601337000000000000000700000089000008a9880088000880000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000089880088898800000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000008900000889800000000000000000000000000000000000000000000000000000000000000000
