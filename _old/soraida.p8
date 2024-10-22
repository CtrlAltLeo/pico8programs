pico-8 cartridge // http://www.pico-8.com
version 39
__lua__



function _init()
	cls()
	popup("hi soraida!",3)
	popup("i hope you can read this font",4)
	popup("i'm not the most artsy guy,",3)
	popup("but i wanted to make you an art!",3)
	popup("i love you so much!!!",5)
	popup("you are so kind to me,",2)
	popup("you are always there for me,",4)
	popup("you are patient,",3)
	popup("and you are loving!",3)
	popup("you're so funny too!!",3)
	popup("meow meow meow meow 🐱",4)
	popup("i used some trig to make this!",5)
	popup("these letters are controlled by a sine wave!",5)
	popup("i can't wait to teach you about programming!",5)
	popup("darling, you are wonderful",4)
	popup("my heart burns with love for you!",4)
	popup("i want to serve you and take care of you every day of my life!",6)
	popup("i'm so thankful that god gave us to each other!",5)
	popup("i smile every day when i wake up, knowing i'm yours!",5)
	popup("thank you for loving me!",3)
	popup("thank you for supporting me!",3)
	popup("thank you for helping me grow in faith!",4)
	popup("i hope this little computer card made you smile!",4)
	popup("have a great day my love!",5)
	popup("-your boofy ♥",3)
	popup("(you can press [enter] to use the menu, and reset the cart to see this card again!",3)
end

function _update()
	upd_msg()
	
	if btnp(🅾️) then
		next_msg()
	end
	
--	code_rain()
--	fire_floor()
--	heart_rain()
--	cat_spawn()
end

function _draw()
	cls()
	rectfill(0,0,128,128,14)
	
	upd_part()
	do_effects()
	draw_msg()
	


end

function do_effects()
	
	if active_ms == 5 then
		heart_rain()
	end
	
	if active_ms == 9 then
		heart_rain()
	end

	if active_ms == 11 then
		cat_spawn()
	end
	
	if active_ms == 14 then
		code_rain()
	end
	
	if active_ms == 16 then
		fire_floor()
	end
	
	if active_ms == 23 then
		heart_rain()
		cat_spawn()
		fire_floor()
	end
	
	if active_ms == 25 then
		heart_rain()
	end
	
end

-->8

ms = {}
ms_time = {}
ms_sum = 0

active_ms = 1

newline = 26

ms_arr = {}

function popup(msg, t)
	
	t += 2
	
	add(ms, msg)
	add(ms_time, t + ms_sum)
	ms_sum += t

	if #ms == 1 then
		load_msg()
	end

end


function draw_msg()
	
	for i = 1, #ms_arr do
		
		str = ms_arr[i]
		
		x = (128 - (#str * 4))/2
		

		
		for j = 1, #str do

			frac = 1/#str

			y = 2*cos(time()+frac*j) + (i * 12) + 40
						
			print(sub(str,j,j),x+j*4,y,7)
			
		end
		
		
		
	end
	
	
end

function load_msg()

	if #ms == 0 then
		return
	end

	str = ms[1]
	
	if #str > 25 then
		
		spl = split(str, " ")
		
		for w in all(spl) do
			print(w)
		end
		
		new = ""
		
		for s in all(spl) do
			if #new + #s <= 25 then
				new ..= " " .. s
			else	
				add(ms_arr, new)
				new = s
			end
		end
		
		add(ms_arr, new)
		
		ms_arr[1] = sub(ms_arr[1],2,#ms_arr[1])
		
		print(#ms_arr)
	
	else 
		
		add(ms_arr, str)

	end
	
end

--[[
function draw_msg()
	if #ms > 0 then
		x = (128 - (#ms[1] * 4 )) / 2
		
		if x < 0 then
			x = 15
		end
		
		sp = 1
		
		if #ms > newline then
			for i = newline, #ms do
				if sub(ms[1],i,i) == " "
					then
						newline = i
						break
					end
			end
		end
		
		for l = 1,#ms[1] do
			
			frac = 1 / #ms[1]
		
			y = 2*cos(time()+(frac * l))
							+ flr(l/newline)*12
			
			if l % newline == 0 then
				sp = 0
			end
						
			print(sub(ms[1],l,l),x+sp*4,64+y,8)	
			print(sub(ms[1],l,l),x+1+sp*4,65+y,7)	
			sp += 1
		end
		
		newline = 26
		
	 --print(ms[1],x,64+y,8)	
	end
end
--]]

function upd_msg()
	
	if #ms_time > 0 then
		if ms_time[1] < time() then
			msg_reset()
		end
	end
	
end

function next_msg()
 msg_reset()
end


function msg_reset()
			del(ms, ms[1])
			del(ms_time, ms_time[1])

			for t in all(ms_arr) do
				del(ms_arr, t)
			end

			active_ms += 1
			load_msg()
end
-->8
--effects

part = {}

function add_p(x,y,vx,vy,maxlife,t)
	p = {x=x, y=y,
						vx = vx,
						vy = vy,
						life = 0,
						maxlife = maxlife,
						t = t}
	add(part, p)
	return #part
end

function upd_part()
	
	for p in all(part) do
		
		p.x += p.vx
		p.y += p.vy
		
		p.life += 0.03
		
		if p.life > p.maxlife then
			del(part, p)
		end
		
		if p.t == "heart" then
			print("♥",p.x,p.y,
									8)
			p.vx = sin(time())
		end
		
		if p.t == "code" then
			print(flr(rnd(2)),p.x,p.y,
									11)

		end
		
		if p.t == "flame" then
			pset(p.x,p.y,p.color)
			
			if p.life < 0.3 then
				p.color = 8
			elseif p.life < 0.7 then
				p.color = 9
			else
				p.color = 7
			end
		end
		
		if p.t == "cat" then
			print("🐱",p.x,p.y,p.color)
		end
		
		
	end

	
end


function heart_rain()
	for i = 0,1 do
		add_p(rnd(128)+10,0,0,rnd(1),rnd(2),"heart")
	end
end

function fire_floor()
	
	for i = 0,25 do
		
		newp = add_p(rnd(128),128,.5,-1*rnd(1),rnd(2),"flame")
		
		part[newp]["color"] = 8
		
	end
	
end

function cat_spawn()

	newp = add_p(rnd(128),rnd(128),0,0,1,"cat")
	part[newp]["color"] = flr(rnd(8))+6

end

function code_rain()
	for i = 0,1 do
		add_p(flr(rnd(128)/8)*8,-8,0,2,3,"code")
	end
end
-->8
--lib


function norm(x,y)
	
	return sqrt(x*x + y*y)
	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000009900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000009800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000088800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000291502c1502e1502f1502f1502d1502c1502b1502a1502915028150271502815029150261002510024100241000010000100001000010000100001000010000100001000010000100001000010000100
050c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c00000c300000001830000000183000000000000000000c30000000000000000018300000000000000000183000000000000000000c3000000018300000001830000000000000000018300000001c3001c300
010c00000c4000c4000c4000c400134001340013400134000e4000e4000e4000e4000e4000e4000e4000e40015400154001340013400184001840018400184000000018400184001340013400154001540000000
010c000010400104001040010400000000000000000000000000000000000000000011400114001140011400000000000000000000001f4001f4001f4001f4000000000000000000000000000000000000000000
010c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 01424344
01 01424344
01 01024344
00 03020444
01 04024344
04 05024344

