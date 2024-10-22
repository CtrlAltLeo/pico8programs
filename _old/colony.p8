pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
--main loops 

--[[
			
			knight upd
			knight ai
			knight hover
			
			add text when buildings are
			fully upgraded
				
			stronger walls 
			
			repair buildings
			
			
					
					--]]

test = {x = 1}

function _init()
cls()
tut = true -- false

set_event("start_game")
--[[
add_building(63,63,"tower")
add_building(63,55,"log_hut")
add_r("iron",100)
add_r("wood",100)
--]]
--goblin_raid()



end


function _update()
	
	ui_upd()
	resource_tick()
	monster_upd()
	do_plant_grow()
	knight_upd()
	
end

function _draw()

	
	cls()
	map()
	_buildings_draw()

	monster_draw()
	knight_draw()
	ui_draw()

	resource_draw()
	house_draw()
	
	draw_popup()
	draw_parts()
	

end



-->8
--cursor and place

_ui_mode = 0
--[[ cursor = 0
					build menu = 1
					place mode = 2
					remove_mode = 3
					dio_mode = 4
]]--


_cursor = {63,63}
_cursor_spd = 2
_cursor_icon = 1

buy_items = {
	{name = "log_hut",
		cost = {wood = 10,stone = 0,iron = 0},
		s = 64},

}

all_items = {
	quarry=	{name = "quarry",
		cost = {wood = 15,stone = 0,iron = 0},
		s = 65},
	mine=	{name = "mine",
		cost = {wood = 5,stone = 15,iron = 0},
		s = 66},
	wall=	{name = "wall",
		cost = {wood = 0,stone = 10,iron = 0},
		s = 67},
house=		{name = "house",
		cost = {wood = 10,stone = 20,iron = 0},
		s = 80},
remove=		{name = "remove",
		cost = {wood = 0,stone = 0,iron = 0},
		s = 5},
		tower=	{name = "tower",
	cost = {wood = 30,stone = 50,iron = 0},
	s = 81},
		library=	{name = "library",
	cost = {wood = 20,stone = 60,iron = 0},
	s = 82}

}

selected_item = 0 --adds one for tbl val
select_name = ""
sel_spr = 1

remove_tool = 5


function ui_mode(mode)
	
	
	_ui_mode = mode
	
	--other ui stuffs
	
	
end

function ui_upd()

 get_inputs()
	
	if _ui_mode == 0 then
		
		do_cursor(false)
		sword_upd()
		
	elseif _ui_mode == 1 then
		 -- do buy menu
	
	--build mode
	elseif _ui_mode == 2 then	 
		do_cursor(true)
	
	elseif _ui_mode == 4 then
	
		
			dio_upd()
		
		
	end
	
end

function get_inputs()

 --cursor mode
	if _ui_mode == 0 then
	
		--select building
		if btnp(🅾️) then
			
			_cursor_icon = 1
			
			if get_monster() == nil then
			
					b = get_building()
					if not b == false then 
						
					 if b.upg == "lvl" then
							upgrade_building(b)
						elseif 
							b.upg == "knt" then
								buy_knight(b)
						end
						
					end
				
				if get_map(_cursor[1]+7,_cursor[2]) > 112 then
					destroy_grass(_cursor[1]+7,_cursor[2])
					sword_fx()
				end
			else
				swing_sword()
			end
		end
		
		--swap to build menu
		if btnp(❎) then
			ui_mode(1)
		end
	
	--buy menu mode
	elseif _ui_mode == 1 then
		
		if btnp(❎) then
			ui_mode(0)
		end
		
		if btnp(➡️) then
			selected_item += 1
			if selected_item > #buy_items - 1 then
				selected_item -= 1
			end
		end
		
		if btnp(⬅️) then
			selected_item -= 1
			if selected_item < 0 then
				selected_item += 1
			end
		end
		
		if btn(🅾️) then
			
			if buy_items[selected_item + 1].name == "remove" 
			 then
				ui_mode(3)
				return
			end
			
			sel_spr = buy_items[selected_item+1].s
			select_name = buy_items[selected_item + 1].name
			ui_mode(2)
			
		end
	
	--build mode
	elseif _ui_mode == 2 then
		
		if btnp(🅾️) then

		
			if can_make_building() then
				
				add_building(_cursor[1],_cursor[2],select_name)
			 pay_costs()

				--log _ event
				if selected_item == 0 then
					set_event("build_log")
				end
				--quarry event
				if selected_item == 1 then
					set_event("build_quarry")
				end
				
				--three walls
				if get_building_count("wall") == 3 then
					set_event("three_walls")
				end
			
			end
			
			
		end
		
		if btnp(❎) then
			ui_mode(0)
		end
	
	--delete mode
	elseif _ui_mode == 3 then
		
		if btnp(🅾️) then
			
			b = get_building()
			if not b == false then
				
				remove_building(b)
				
			end
		end
		
		if btnp(❎) then
			ui_mode(0)
		end
	
	--text mode
	elseif _ui_mode == 4 then
		
		if btnp(🅾️) then
			
			if text_over then
				
				if not check_msg_queue() then
					ui_mode(0)
				end
				
			else
				can_see = #msg
				text_over = true
			end
			
		end
		

		end
	end

function ui_draw()
	
	draw_mode_indi()

	--cursor mode
	if _ui_mode == 0 then
		spr(_cursor_icon,_cursor[1],_cursor[2])
		hover_building()
		
	
		spr(sword_sprite.s,sword_sprite.x+5,sword_sprite.y-2)
	
		
	--buy menu
	elseif _ui_mode == 1 then
		 draw_buy_menu()
		 
		 
	--place mode
	elseif _ui_mode == 2 then
			
			
		if can_make_building() == false then
			for col = 1,15 do
				pal(col,8)
			end
		end
		
		spr(sel_spr,_cursor[1],_cursor[2])
		pal()
		
	--remove mode
	elseif _ui_mode == 3 then
		do_cursor(false)
	--	hover_building()
		spr(5,_cursor[1],_cursor[2])
		
		b = get_building()
		if  b != false then
			
			for i = 0,15 do
				pal(i,8)
			end
			spr(b.s,b.x,b.y)
			pal()
		end
		

	
	--dio mode
	elseif _ui_mode == 4 then
		
		dio_draw()
	
	end
end

dummy = {_cursor[1],_cursor[2]}
	
function do_cursor(pre)
	

	
	if btn(⬆️) then
				dummy[2] -= _cursor_spd		
	elseif btn(⬇️) then
		dummy[2] += _cursor_spd
	end
	
	if btn(⬅️) then
				dummy[1] -= _cursor_spd		
	elseif btn(➡️) then
		dummy[1] += _cursor_spd
	end
	
	if pre then
	
		_cursor[1] = flr(dummy[1] / 8) *8
		_cursor[2] = flr(dummy[2] / 8) *8
	
	else
		
		_cursor[1] = dummy[1]
		_cursor[2] = dummy[2]
		
	end
	
	
	for c = 1,2 do
		
		if _cursor[c] < 0 then
			_cursor[c] = 0
		end
		
		if _cursor[c] > 120 then
			_cursor[c] = 120
		end
	end
	
	
end

function draw_buy_menu()
	
	-- draw box
	rectfill(4,96,123,120,9)
	rectfill(6,98,121,118,13)
	
	--draw buyables
	c = 0
	for b in all(buy_items) do
		
		spr(b.s, 10 + 10 * c,110)
	--	print(b.cost)
		
		c += 1
	end
	
	
	--draw selection rect
	x = 8 + selected_item * 10
	y = 109
	rect(x,y,x+10,y+10,7)
	
	--draw prices 
	buy = buy_items[selected_item+1]
	
	types = {"wood","stone","iron"}
	c1 = 1
	for t in all(types) do
		
		spr(c1+15, 10 + 25 * (c1-1), 100)
		print(buy.cost[t], 20 + 25 * (c1-1), 102) 
		c1 += 1
	end
	
	print(buy.name,82,102)
	
	
	
end


function do_cost_check()
	
	tbl = buy_items[selected_item + 1]
	costs = tbl.cost
	
	it = {"wood","stone","iron"}
	
	for i in all(it) do
		
		if costs[i] > resources[i]
			then
			
				return false
		
			end
	end

	return true
	
end

function pay_costs()
	tbl = buy_items[selected_item + 1]
	costs = tbl.cost
	it = {"wood","stone","iron"}
	
	for i in all(it) do
		
		resources[i] -= costs[i]
		
	end
end

--draws the mode indicator in 
--corner
function draw_mode_indi()
	
	x = _cursor[1]
	y = _cursor[2]
	
	--cursor mdoe
	if _ui_mode == 0 then
		rectfill(118,2,125,10,1)
		spr(3,118,2)
		print("x",120,12)
		
	end
	
	if _ui_mode == 1 then
		
		
		
		spr(21, 12,85)
		spr(5, 35,85)
		
		print("z",24, 87,7)
		
		print("x",45, 87,8)
		
	end
	
	if _ui_mode == 2 then
		
		
		
		spr(21, x-10,y+10)
		spr(5, x+10,y+10)
		
		print("z",x-7,y + 20,7)
		
		print("x",x+13,y + 20,8)
	end
	
end

function get_building()
	
	for b in all(_buildings) do
		
		x = _cursor[1]
		y = _cursor[2]
		
		if get_overlap(x,y,7,7,
																	b.x,b.y,b.w,b.h)
		then
			
			return b
						
		end
		
	end
	
	return false
	
	
end


function hover_building()
	
	b = get_building()
	
	if not b == false 
		and b.lvl != 0
	then
		
		
		for i = 1,15 do
			pal(i,7)
		end
		--highlight building
		spr(b.s,b.x,b.y)
		
		pal()
	
		if b.upg == "lvl" then
			hover_upgrade_building()	
		
		elseif b.upg == "knt" then
			hover_tower()
		end
		
		
		
		
		

	end

end

function hover_upgrade_building()
		rectfill(4,96,123,120,9)
		rectfill(6,98,121,118,13)
		
		--lvl
		print(b.lvl,40,100,7)
		
		--lvl spr
		spr(32, 45,98)
		--name
		print(b["name"]..",", 8,100,7)
		
		--upgrade prompt
		print("z: upgrade to lvl "..tostr(b.lvl+1)
			.." for "..tostr(b.lvl*5),
			8,110,7)
			spr(18,110,109)
end

function hover_tower()

rectfill(4,96,123,120,9)
		rectfill(6,98,121,118,13)
		
		--lvl
		print(b.lvl,40,100,7)
		
		--knight spr
		spr(1, 45,98)
		--name
		print(b["name"]..",", 8,100,7)
		
		--upgrade prompt
		print("z: hire knight "..tostr(b.lvl+1)
			.." for "..tostr(b.lvl*5),
			8,110,7)
			spr(18,110,109)
	
end

swung = false
sword_sprite = {x=-5,y=-5,s=6}
sword_ani = false
function swing_sword()
	
	if swung == false then
		swung = true
		
		sword_fx()
	
		mon = get_monster()
		if mon != nil then
			kill_monster(mon)
		end

	end
	
end

function sword_fx()
		sword_ani = true
		sfx(1)
		sword_sprite.x = _cursor[1]
		sword_sprite.y = _cursor[2]
		sword_sprite.s = 6
end

function sword_upd()
	
	if sword_ani then
		sword_sprite.s += .5
	end

	if sword_sprite.s > 9 and sword_ani then
			swung = false
			sword_ani = false
			sword_sprite.x = -10
			sword_sprite.y = -10
			
	end

	
end





-->8
--buildings

lifetime_buildings = 0

_buildings = {}
--[[ building = 
	coords
	width
	height
	upgrade level
	hp
-]]

building_count = 0
max_buildings = 7

b_types = {
log_hut = {w=7,h=7,lvl=1,hp=20,s=64,pro = "wood",name="log hut",upg = "lvl",id=nil},
quarry = {w=7,h=7,lvl=1,hp=20,s=65,pro = "stone",name="quarry",upg = "lvl",id=nil},
mine = {w=7,h=7,lvl=1,hp=20,s=66,pro = "iron",name="mine",upg = "lvl",id=nil},
wall = {w=7,h=7,lvl=0,hp=30,s=67,pro = nil,name="wall",upg = "nil",id=nil},
house = {w=7,h=7,lvl=0,hp=20,s=80,pro = nil,name="house",upg = "nil",id=nil},
tower = {w=7,h=7,lvl=1,hp=40,s=81,pro = nil,name="tower",upg = "knt",id=nil},
library = {w=7,h=7,lvl=0,hp=10,s=82,pro = nil,name="library",upg = "kno",id=nil}

}


function add_building(x,y,t)
	
	b = {x=x,y=y,
						w=nil, h=nil,
						lvl=nil,hp=nil,s=nil,
						pro=nil,name=nil,upg = nil,
						id = nil}
	
	
	tab = b_types[t]
	
	calls = {"w","h","lvl","hp","s","pro","name","upg"}
	
	for i = 1,#calls do
		b[calls[i]] = tab[calls[i]]
	end	
	
	b.id = lifetime_buildings
	lifetime_buildings += 1
	
	if b.name == "house" then
		add_house_lvl()
	end
	
	if b.name != "wall" then
		
		building_count += 1
		
	end
	
		
	add(_buildings, b) 
	
	
end

function remove_building(b)
	
	if b.name != "wall" then
		building_count -= 1
		if b.name == "house" then
			max_buildings -= 3
		end
	end
	
	for buil in all(_buildings) do
		
		if buil == b then
			del(_buildings, buil)
		end

	end

end


function _buildings_draw()

 for b in all(_buildings) do
 	
 	spr(b.s,b.x,b.y)
 	
 end
	
end

function is_building_overlap()
	
	b = b_types[select_name]
	x = _cursor[1]
	y = _cursor[2]
	
	
	for bul in all(_buildings) do
		
		if get_overlap(x,y,b.w,b.h,
			bul.x,bul.y,bul.w,bul.h)
		then
			return true
		end
		
	end
	
	return false
	
end


function get_nearest_building(x,y)
	
	near = nil
	d = 256
	
	for b in all(_buildings) do
		
		distx = (b.x - x) ^ 2
		disty = (b.y - y) ^ 2
		dist = sqrt(distx + disty)
		
		if dist < d then
			d = dist
			near = b
		end
		
		
	end
	
	return near
	
end


function damage_building(b, d)

	for buil in all(_buildings) do
		
		if buil == b then
			buil.hp -= d
			
			add_p(10,buil.x-2 + rnd(4),buil.y,1.7)
			
			if buil.hp <= 0 then
				remove_building(buil)
			end
		end
		
		
	end

end


function add_house_lvl()
	
	max_buildings += 3
	
end


function house_draw()
	
	spr(20,80, 3)
	print(building_count,90,6,1)
	print("/ "..max_buildings,98,6,1)
end

function get_building_count(t)
	
	c = 0
	
	for b in all(_buildings) do
		
		if b.name == t then
			c += 1
		end
		
	end
	
	return c
end

function can_make_building()
	
		--do cost check
			if do_cost_check() and 
				not is_building_overlap() 
					then
				
					if building_count + 1 <= 
						max_buildings then
							return true
					
					else		
						pop_up("not enough workers!",3)
					end	
				end
		
	
	
	
	return false
end


function upgrade_building(b)

	lvl = b.lvl
	
	cost = lvl * 5
	
	if lvl == 9 then
		return
	end
	
	if get_r("iron") >= cost then
		
		take_r("iron", cost)
		
		for i in all(_buildings) do
			
			if i == b then
				i.lvl += 1
				set_event("upgrade_building")
			end
		end
	end
end

-->8
--util


function get_overlap(x1,y1
																				,w1,h1
																				,x2,y2
																				,w2,h2)
	
	for xx = x1, x1 + w1 do
		for yy = y1, y1 + h1 do
			
			if xx > x2 and xx < x2 + w2
			 and yy > y2 and yy < y2 + h2 then
			 	return true
    end
			
		end
	end
	
	return false
	
end


function get_map(x,y)
	
	nx = flr(x / 8)
	ny = flr(y / 8)
	
	return mget(nx,ny)
	
end

function dist_to(x1,y1,x2,y2)
	
	d1 = (x2-x1) ^ 2
	d2 = (y2-y1) ^ 2
	d = sqrt(d1 + d2)
	return d
	
end
-->8
--resources

resources = {
wood = 0,
stone = 0,
iron = 0,
}

function resource_draw()
	
	r_image = {16,17,18}
	t = {resources["wood"]
					,resources["stone"]
					,resources["iron"]}
	
	for i = 1,3 do
		
		x = (i-1) * 28 + 2
		y = 4
		
		
		
		spr(r_image[i],x,y)
		print(t[i], x + 10, y+ 2,1)
	
	end
end

function add_r(r, x)
	
	resources[r] += x
	
end

function take_r(r, x)
	resources[r] -= x
end

function get_r(r)
	return resources[r]
end


function resource_tick()
	
	if time() % 4 == 0 then
		
		for b in all(_buildings) do
			
			if b.pro != nil then
			
				add_r(b.pro, (1 * b.lvl))
			
			end
			
		end
		
	end
	
	
end
-->8
--text box


text_active = false
msg = ""
can_see = 0
text_over = false

msg_q = {}

popup_text = ""
popup_time = 0

function new_message(t)
	
	reset_box()
	
	ui_mode(4)
	
	hold = split(t, " ")
	
	msg = hold[1]
	del(hold,hold[1])
	c = #msg
	for w in all(hold) do
		
		c += #tostr(w) + 1
		
		if c > 27 then
			msg = msg.."\n"..w
			c = #w
		else
			msg = msg.." "..w
		end
		
		

	end	
	
	
	
end

function queue_message(t)
	
	add(msg_q, t)
	
end

function reset_box()
	can_see = 0
	text_over = false
	msg = ""
end

function dio_upd()
	
	can_see += 1
	
	if can_see >= #msg then
	text_over = true
	end

	
end

function dio_draw()

	
	rectfill(4,80,124,124,1)
	rectfill(8,84,120,120,0)
	
	print(sub(msg,1,can_see),12,88,7)
	
	if text_over then
		print("z",117,115,8)
	end
	
	pal(14, 0)
	if flr(time()) % 2 == 0 then
		spr(25, 105, 65, 2,2)
	else
		spr(23, 105, 65, 2,2)
	end
	
	
	pal()
end

function check_msg_queue()
	
	if #msg_q > 0 then
		new_message(msg_q[1])
		del(msg_q,msg_q[1])
		return true
	end
	
	return false
	
end


function _old_new_message()
	
	
	if #msg > 27 then
		
		for i = 1,flr(#msg / 27) do
			 
				if sub(msg,i*27,i*27) != " " then
					
					for j = i*27,1,-1 do
						
						if sub(msg,j,j) == " " then
							
							msg = sub(msg,1,j).."\n"..sub(msg,j)
							break
						end
						
					end
			
		else
					
			msg = 
					sub(msg,1,i * 27).."\n"..sub(msg,i*27 + 1)
				
				end
		
					
		end

	end
	
end


function pop_up(t,duration)
	
	popup_text = t
	popup_time = time() + duration
	
end

function draw_popup()
	
	if time() < popup_time then
		print(popup_text,((32 - #popup_text) / 2)*4,63,1)      
		print(popup_text,((32 - #popup_text) / 2)*4,64,7)      
	
	end
	
end
-->8
--game rules and logics

events = {
	start_game = false,
	build_log = false,
	build_quarry = false,
	upgrade_building = false,
	kill_monster = false,
	three_walls = false,
	
	goblin_raid_1 = false,
	first_raid_w = false
	
	
}




function set_event(e)

	if tut == false then
		return
	end
	
	if events[e] == false then
		
	events[e] = true
	call_event(e)
		
	end
	
end

function call_event(e)
	

	
	if e == "start_game" then
		add_r("wood",10)
		
		
		new_message("welcome to tiny city, a lovely place to build a little empire!")
		queue_message("well, it would be. but we're running low on resources! we only have 10 wood left!")
		queue_message("to get this party started, you need to press the x key to open the build menu!")
		queue_message("then, use the left and right arrows to select the building, and press z to select it!")
		queue_message("finally, press z again to place your building, and x to exit build mode!")
		queue_message("got it?")
		queue_message("kind of..?")
		queue_message("it's a lot to remember. if you don't know what key to press, check the top right corner for a hint!")
	end
	
	if e == "build_log" then
		new_message("nice job! you made your first building! this is just the start of what you can build here!")
		queue_message("i've added a few new buildings to your building menu. different buildings produce different resource types!")
		queue_message("log huts make wood, quarrys produce stone, and mines produce iron!")
		queue_message("you can see each building's cost on the top of the build menu! next up, try building a quarry to produce more stone.")
		queue_message("you might have to wait for your log hut to produce enough wood..")
		queue_message("but! you can press z to swing your sword at trees to get extra resources!")
		add(buy_items,all_items["quarry"])
		add(buy_items,all_items["mine"])
	
	end
	
	if e == "kill_monster" then
		new_message("good job! you got him!")
		queue_message("that one was pretty weak, but now we've got their attention.")
		queue_message("you need to build walls to defend against them, and gather resources to repair broken buildings!")
		queue_message("as you keep building, you'll get different buildings which unlock new upgrades")
		queue_message("build 3 walls, and keep our kingdom safe!")
		do_monster_spawn = true
		add(buy_items, all_items["wall"])
	end
	
	if e == "upgrade_building" then
		new_message("nice work! this building will produce a lot more resources!")
		queue_message("now comes the bad news..")
		queue_message("unfortunately, we're building our empire next to a den of bloodthirsty goblins!")
		queue_message("these buggers will invade our kingdom and wreak buildings, and we can't let that happen.")
		queue_message("i'm giving you a wall to build using stone to protect our city.")
		queue_message("hey, is that a sword you're holding??")
		queue_message("if you press z you can swing your sword at a monster!")
		queue_message("defend our kingdom, brave ruler!")
		add_monster("bad_goblin",63,128)
	end
	
	if e == "build_quarry" then
		new_message("sweet! ♥ that quarry will make stone so you can make more buildings!")
		queue_message("while these buildings are making us good resources, it certainly could be a bit faster..")
		queue_message("we can use iron to sharpen our axes and picks!")
		queue_message("you should build a mine to get iron. each upgrade costs 5 iron, and makes the building produce more resources.")
		queue_message("while you're waiting for the mine to produce resources, try moving the sword onto a building.")
		queue_message("it will turn white, and you'll see it's production level above it!")
	end
	
	if e == "three_walls" then
		
		new_message("stellar! we'll need more walls than this, but this is a great start!")
		queue_message("did you notice that little house icon in the top?")
		queue_message("there's a limit to how many buildings you can make.")
		queue_message("however, you can do two things to make more:")
		queue_message("you can use the 'remove' tool to delete a building,")
		queue_message("or build a house! houses allow more people to live in the city,")
		queue_message("and lets you have more workers for your buildings.")
		queue_message("walls don't count toward your building count, but everything else does.")
		add(buy_items,all_items["house"])
		add(buy_items,all_items["remove"])
		queue_message("i have to take a message to the queen of kra'mazon, so you're on your own for a little bit.") 	
		queue_message("continue upgrading the empire!")			
	end
	
	if e == "goblin_raid_1" then
		pop_up("a gobin raid begins!",7)
		goblin_raid()
	end
	
	if e == "first_raid_w" then
		new_message("that was crazy!")
		queue_message("it seems like we survived, though!")
		queue_message("these goblins are getting very annoying. you need to focus on building, not fighting off goblins!")
		queue_message("i think we can build a tower and hire some knights to defend the kingdom!")
		queue_message("it's going to cost a fair bit of resources.")
		queue_message("i've just given you the plans.")
		queue_message("also, our people seem to be lacking in culture and intelligence, unfortunately.")
		queue_message("you can build a library to teach them, and invent new buildings!")
		add(buy_items,all_items["tower"])
		add(buy_items,all_items["library"])
	end
	
end


-->8
--monsters

do_monster_spawn = false

_monsters = {}

monster_types = {
goblin = {x=nil,y=nil,
												s=128,vx=nil,vy=nil,
												target = nil, dmg = 5,ttk = 1},
												
												bad_goblin = {x=nil,y=nil,
												s=128,vx=nil,vy=nil,
												target = nil, dmg = 0, ttk = 2}
}

total_monsters = 0

raid_monsters = 0
raid = false

function add_monster(t,x,y)
	
	total_monsters += 1
	
	new = 
	{x=nil,y=nil,
	s=nil,
	vx=nil,vy=nil,
	target = nil, dmg = nil
	,ttk = nil}
	
	stack = {"s","dmg","ttk"}
	for s in all(stack) do
		new[s] = monster_types[t][s]
	end
	
	new.x = x
	new.y = y
	
	b = get_nearest_building(x,y)
	if b != nil then
		
		new.vx = b.x - x
		new.vy = b.y - y

		new.target = b

	else
	
		new.vx = 0
		new.vy = 0
		
		new.target = nil
		
	end
	
	add(_monsters, new)
	
	
end


function monster_upd()
	
	if _ui_mode != 4 then
		spawn_monsters()
	end
	
	if _ui_mode == 4 then
		return
	end
	
	for i = 1,#_monsters  do
		
		m = _monsters[i]
		
		m.x += m.vx / 50
		m.y += m.vy / 50
		
		if m.target == nil then
			break
		end
		
		if get_overlap(m.x,m.y,7,7,

		m.target.x,m.target.y,7,7)
		 then
		 
		 m.vx = 0
		 m.vy = 0
		 
		 if time() % m.ttk == 0 then
		 	damage_building(m.target,m.dmg)
				
				b = get_nearest_building(m.x,m.y)
					if b != nil then
						
						m.vx = b.x - m.x
						m.vy = b.y - m.y
				
						m.target = b
				
					end	
			
		 end
		
		
		 								
 	end
		
	end
	
end


function monster_draw()
	
	for i = 1,#_monsters  do
		
		m = _monsters[i]
		
		spr(m.s,m.x,m.y)
		
	end
	
end


function kill_monster(m)
	
	del(_monsters, m)
	
	set_event("kill_monster")
	
	if raid then
		raid_monsters -= 1
		
		if raid_monsters == 0 then
			set_event("first_raid_w")
		end
		
	end
	
end

function get_monster()
	
	x = _cursor[1]
	y = _cursor[2]
	
	for m in all(_monsters) do
		
	if	get_overlap(x,y,7,7,m.x,m.y,7,7) then
		return m
	end
		
	end

	return nil	
end


function spawn_monsters()
	if do_monster_spawn then
		
		if time() % 12 == 0 then
			add_monster("goblin",rnd(127),128)
		end
		
		if total_monsters == 30 then
			set_event("goblin_raid_1")
		end
		
	end
	
	
end

function goblin_raid()
	
	for i = 1,10 do
		add_monster("goblin",rnd(127),128+rnd(20))
	end
	
	raid = true
	raid_monsters = 10
	do_monster_spawn = false
	
end

-->8
--plants i guess

min_plant = 113
maxplant = 118

function do_plant_grow()
	
 if time() % 15 == 0 then
	
			x = rnd(15)
			y = rnd(15)

			mset(x,y,ceil(rnd(6)) +112 )	
			sp = false											
			

	end
	
	
end

function destroy_grass(x,y)

	nx = flr(x / 8)
	ny = flr(y / 8)
	
	if get_map(x,y) == 117 then
		add_r("wood",3)
	end

	if get_map(x,y) == 118 then
		add_r("stone",3)
	end

	
	mset(nx,ny,112)
	sfx(2)
	
end
-->8
--visual effects

_parts = {}


function add_p(s,x,y,d)
	
	new = {s=s,x=x,y=y,d=time() + d}
	
	add(_parts,new)
end

function draw_parts()
	for p in all(_parts) do
		
		spr(p.s,p.x,p.y)
		p.y -= .05
		if p.d < time() then
			del(_parts,p)
		end
		
	end
end
-->8
--knights


_knights = {}
knight_keys = {"x","y","base","hp"}

function knight_draw()
	for k in all(_knights) do
		
		spr(104,k.x,k.y)
		
	end
end

function knight_upd()
	
end

function add_knight(x,y,base)
	
	k = {x=x,y=x,
						base = base,hp = 15
						}
	
	add(_knights, k)
end

function damage_knight()
	
end

function remove_knight()
	
end

function get_nearest_knight(x,y)
	
	kn = {x=nil,y=nil,base=nil,hp=nil}
	d = 128
	

	for k in all(_knights) do
		
		dist = dist_to(x,y,k.x,k.y)
		
		if flr(dist) < d then
			d = dist
		--	print("success")
			for lol in all(knight_keys)
				do
					kn[lol] = k[lol]
				end
		end

	end
	
	return kn
	
end

function knight_hover(k)
	--hover pal thing
	--show knight hp bar
end

function get_cursor_knight()
	for k in all(_knights) do
		
		if get_overlap(_cursor[1],_cursor[2],
																	7,7,
																	k.x,k.y,7,7)
		then
			return k
		end
		
	end
	
	return false
end


function buy_knight(b)
	
	if b.lvl <= 4 then
		
		if pay_for_knight() then
			add_knight(b.x,b.y+10,b.id)
		end
		
	end
	
end

function pay_for_knight()
	
	if resources["iron"] - 5 >= 0 then
		resources["iron"] -= 5
		return true
	end
	
	return false
	
end
__gfx__
00000000000000760000000000000000007000000288888007770000000700000000000000000000000000000000000000000000000000000000000000000000
00000000000007660005640006049000000070002811128800007000000070000000000000000000000000000000b0b000000000000000000000000000000000
00700700000076600056449006566600007000702810282800000000000077000000000000000000000000000000000000000000000000000000000000000000
00077000040766000054966006566660007070002812812800000000000007000000007000000000028887700b00000b00000000000000000000000000000000
00077000004660000449666706049560700000702812812800000000000000000000077000000000028888e00000000000000000000000000000000000000000
00700700054400004490077000049000707777002828012800000000000000000000077000007000000000000b00000b00000000000000000000000000000000
0000000045509000490000000004900007000000288111280000000000000000000070000707700000000000000b0b0000000000000000000000000000000000
00000000490000000000000000049000000777000288888000000000000000000000000007700000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000001100000000000000000000000000000000000000000000000000000000000000000000000000000000
000044400005555000044a0000067000000000000000001b0000ff000000000ffffff00000000000000000000000000000000000000000000000000000000000
00049994005766d0004979a0006777000009a0000000017b0807777000000077777777000000000ffffff0000000000000000000000000000000000000000000
00499994057666d1004799a000677700009aaa001100017b0000f0f0000000777777770000000077777777000000000000000000000000000000000000000000
04499940056666d1004999a000677700009aaa001b1017b1090ffff000000ffffffffff008800077777777000000000000000000000000000000000000000000
4ff4940005666dd10499aaa000077000098444a01bb17bb10907777008800ffffffffff008800ffffffffff00000000000000000000000000000000000000000
47f4400005dddd1104aa0000006777000081140017bbbb1009fcccc008800feefffeeff000000ffffffffff00000000000000000000000000000000000000000
0444000000111100000000000677777000811400017bb1000907777700000feefffeeff000000feefffeeff00000000000000000000000000000000000000000
0009a0000000000000000000000ddd0000000000000000000000000004400ffffffffff004400feefffeeff00000000000000000000000000000000000000000
00967a00500000000000000000dddd00000000000000000000000000044007777777777004400ffffffffff00000000000000000000000000000000000000000
09a77aa0577777770000000000dddd00000000000000000000000000044007777777777004400777777777700000000000000000000000000000000000000000
9677777a51666dd70000000000ddddd0000000000000000000000000044ff77777777770044ff777777777700000000000000000000000000000000000000000
9677777a51666d700000000000ddddd0000000000000000000000000044ffcccccccccc0044ffcccccccccc00000000000000000000000000000000000000000
09a77aa050066000000000000d0000dd00000000000000000000000004400cccccccccc004400cccccccccc00000000000000000000000000000000000000000
00967a0000566d0000000000dd00000d000000000000000000000000044007777777777704400777777777770000000000000000000000000000000000000000
0009a0000516dd700000000000000000000000000000000000000000044007777777777704400777777777770000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000d60000d6a6a700007000000000000000000000000000000000000000000000000000000000000
000000000000000001555000560000561d00001d1cc001c7000026000d6aa6700000a70000000000000000000000000000000000000000000000000000000000
000000000044444015555560566005661dd001dd1cc001c7000294600d66a670000cc00700000000000000000000000000000000000000000000000000000000
004994000690909015444460566656661ddddddd1cccccc7002940700d6a6670007cc07000000000000000000000000000000000000000000000000000000000
04f499406d60909015999956566666661d66d66d1cccccc70294000000d66700000c0c0000000000000000000000000000000000000000000000000000000000
4fff499455d6909015900956566666661ddddddd1cccccc705444490024d74900244449002444490024444900000000000000000000000000000000000000000
4f1f4994555d609015900956566666661d6d666d1cccccc705411490024114900241149002411490024114900000000000000000000000000000000000000000
4f1f4994555d609015900956566666661ddddddd1cccccc705411490024114900241149002411490024114900000000000000000000000000000000000000000
000000000008808000000000000000000007600000100c7000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aa99000008888000577600000000000d07606001ccccc700000000000000000000000000000000000000000000000000000000000000000000000000000000
0a99a9900506687005777760d6066067007777001c0cc0cc00000000000000000000000000000000000000000000000000000000000000000000000000000000
0a99a9900506607000744700d6066067000770001c57760c00000000000000000000000000000000000000000000000000000000000000000000000000000000
a9999a990566667000794700d6666667000770001c07700c00000000000000000000000000000000000000000000000000000000000000000000000000000000
095594400566667000744700d6644667000706001c07700700000000000000000000000000000000000000000000000000000000000000000000000000000000
091594400560067005777760d624496700d776005777777600000000000000000000000000000000000000000000000000000000000000000000000000000000
095594400560067057777776d624496700d776000577776000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000880800000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000056670000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000007011170000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000006011670000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000005056670000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000004056670000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000050670000000000000000000000000000000000000000000000000000000000
33333333333333333333333333333333333333333333333333333333000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333333333333333333333338833333333333333335733000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333b33333a333333566333380833333999933333566d3000000000000000000000000000000000000000000000000000000000000000000000000
3333333333333b33333a7a333356666333b8833339f77f93335666d3000000000000000000000000000000000000000000000000000000000000000000000000
3333333333b33b33333ba333335611633b33333335999943315666d3000000000000000000000000000000000000000000000000000000000000000000000000
333333333b333333333b33331156666333b3333335444444115666d3000000000000000000000000000000000000000000000000000000000000000000000000
333333333b33333333333333115666633333333353444433331ddd33000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333333333333333333333333333333334333333333333000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000b0a0ab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0000b00baaaab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0bbbbbb000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002b2b00002b2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bbbb0000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009990b0b0aaab00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b040400000a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000011100067700000bb8e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001d11008787000002bb8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001d11d006777000002b2b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001111d000670000000bbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002120010007770000b94b9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010010010700700000b04b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000101000607000001040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333331111111133
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333331614911133
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333331656661133
333333444333333333333333333333333555533333333333333333333333344a33333333333333333339a3333333333333333333333333333333331656666133
333334999433111333333333333333335766d333111333333333333333334979a333111333333333339aaa333311333333331333331113333333331614956133
333349999433131333333333333333357666d133131333333333333333334799a333131333333333339aaa333331333333313333333313333333331114911133
333449994333131333333333333333356666d133131333333333333333334999a333131333333333398444a33331333333313333333313333333331114911133
334ff494333313133333333333333335666dd1331313333333333333333499aaa333131333333333338114333331333333313333333313333333331114911133
3347f443333311133333333333333335dddd113311133333333333333334aa333333111333333333338114333311133333133333333313333333331111111133
33344433333333333333333333333333111133333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333313133333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333313133333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333331333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333313133333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333313133333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333b3333333b33333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333b3333333b333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333b33b3333b33b333333333333333333
3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333b3333333b3333333333333333333333
3333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333b3333333b3333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
3333333333333333333333333333333333999933333333333333333333333333333333333399993333333333333333b3333333b3333333333333333333333333
3333333333333333333333333333333339f77f933333333333333333333333333333333339f77f933333333333333b3333333b33333333333333333333333333
333333333333333333333333333333333599994333333333333333333333333333333333359999433333333333b33b3333b33b33333333333333333333333333
33333333333333333333333333333333354444443333333333333333333333333333333335444444333333333b3333333b333333333333333333333333333333
33333333333333333333333333333333534444333333333333333333333333333333333353444433333333333b3333333b333333333333333333333333333333
33333333333333333333333333333333333433333333333333333333333333333333333333343333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
333333333399993333333333333333333399993333333333333333b3333333b3333333b3333333b3333333b3333333b333333333333333333333333333333333
3333333339f77f93333333333333333339f77f933333333333333b3333333b3333333b3333333b3333333b3333333b3333333333333333333333333333333333
33333333359999433333333333333333359999433333333333b33b3333b33b3333b33b3333b33b3333b33b3333b33b3333333333333333333333333333333333
3333333335444444333333333333333335444444333333333b3333333b3333333b3333333b3333333b3333333b33333333333333333333333333333333333333
3333333353444433333333333333333353444433333333333b3333333b3333333b3333333b3333333b3333333b33333333333333333333333333333333333333
33333333333433333333333333333333333433333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333a3333333333333333333333333b3333333b33399993333333333333333333333333333333333333333b3333333b3333333b333333333
3333333333333333333a7a33333333333333333333333b3333333b3339f77f933333333333333333333333333333333333333b3333333b3333333b3333333333
3333333333333333333ba333333333333333333333b33b3333b33b33359999433333333333333333333333333333333333b33b3333b33b3333b33b3333333333
3333333333333333333b333333333333333333333b3333333b33333335444444333333333333333333333333333333333b3333333b3333333b33333333333333
33333333333333333333333333333333333333333b3333333b33333353444433333333333333333333333333333333333b3333333b3333333b33333333333333
33333333333333333333333333333333333333333333333333333333333433333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
3333333333333333333333b3333333b3333333b3333333b33333333333333333333333333333333333333333333333b3333333b3333333333333333333333333
333333333333333333333b3333333b3333333b3333333b33333333333333333333333333333333333333333333333b3333333b33333333333333333333333333
333333333333333333b33b3333b33b3333b33b3333b33b33333333333333333333333333333333333333333333b33b3333b33b33333333333333333333333333
33333333333333333b3333333b3333333b3333333b33333333333333333333333333333333333333333333333b3333333b333333333333333333333333333333
33333333333333333b3333333b3333333b3333333b33333333333333333333333333333333333333333333333b3333333b333333333333333333333333333333
33333333333333333333333333333333333333133311131113111313331113333311171113111311131113111333333333333333333333333333333333333333
33333333333333333333333333333333333333733377737773777373337773333377767773777377737773777333333333333333333333333333333333333333
33333333333333333333333333333333333333733337333733373373337133333371667773717337337173713333333333333333333333333333333333333333
33333333333333b333333333333333333333337333373337333733733377333343776373737773b733771377333333b333333333333333b33333333333333333
3333333333333b333333333333333333333333711317133733373371137113333471137373733b1713737b7113333b333333333333333b333333333333333333
3333333333b33b333333333333333333333333777377733733373377737773335477737373733b7773737b7773b33b333333333333b33b333333333333333333
333333333b333333333333333333333333333333333333333333333333333334553933333b3333333b3333333b333333333333333b3333333333333333333333
333333333b333333333333333333333333333333333333333333333333333334933333333b3333333b3333333b333333333333333b3333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333338833333333333333333333333333333333333333333333
3333333333333333333333333333333333333333333333b3333333b3333333b3333333b3333333b333808333333333b3333333b3333333333333333333333333
333333333333333333333333333333333333333333333b3333333b3333333b3333333b3333333b3333b8833333333b3333333b33333333333333333333333333
333333333333333333333333333333333333333333b33b3333b33b3333b33b3333b33b3333b33b333b33333333b33b3333b33b33333333333333333333333333
33333333333333333333333333333333333333333b3333333b3333333b3333333b3333333b33333333b333333b3333333b333333333333333333333333333333
33333333333333333333333333333333333333333b3333333b3333333b3333333b3333333b333333333333333b3333333b333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333b3333333b333333333333333b3344444b3333333b3333333b3333333b333333333333333333333333333333333
3333333333333333333333333333333333333b3333333b333333333333333b336939393333333b3333333b3333333b3333333333333333333333333333333333
3333333333333333333333333333333333b33b3333b33b333333333333b33b36d6b9393333b33b3333b33b3333b33b3333333333333333333333333333333333
333333333333333333333333333333333b3333333b333333333333333b3333355d6939333b3333333b3333333b33333333333333333333333333333333333333
333333333333333333333333333333333b3333333b333333333333333b33333555d639333b3333333b3333333b33333333333333333333333333333333333333
333333333333333333333333333333333333333333333333333333333333333555d6393333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
333333333333333333333333333333b333333333333333b3333333b3333333b333333333333333333333333333333333333333333333333333333333333333b3
33333333333333333333333333333b333333333333333b3333333b3333333b333333333333333333333333333333333333333333333333333333333333333b33
33333333333333333333333333b33b333333333333b33b3333b33b3333b33b333333333333333333333333333333333333333333333333333333333333b33b33
3333333333333333333333333b333333333333333b3333333b3333333b333333333333333333333333333333333333333333333333333333333333333b333333
3333333333333333333333333b333333333333333b3333333b3333333b333333333333333333333333333333333333333333333333333333333333333b333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
333333333333333333333333333333b3333333b3333333b333333333333333333333333333333333333333333333333333333333333333b3333333b3333333b3
33333333333333333333333333333b3333333b3333333b333333333333333333333333333333333333333333333333333333333333333b3333333b3333333b33
33333333333333333333333333b33b3333b33b3333b33b333333333333333333333333333333333333333333333333333333333333b33b3333b33b3333b33b33
3333333333333333333333333b3333333b3333333b333333333333333333333333333333333333333333333333333333333333333b3333333b3333333b333333
3333333333333333333333333b3333333b3333333b333333333333333333333333333333333333333333333333333333333333333b3333333b3333333b333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333
333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333b3333333b33333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333b3333333b333333333333333333
333333333333333333333333333333333333333333b3333b33333333333333b3333b333333333333333333333333333333b33b3333b33b333333333333333333
333333333333333333333333333333333333333333bbbbbb33333333333333bbbbbb33333333333333333333333333333b3333333b3333333333333333333333
333333333333333333333333333333b3333b33333332b2b33333333333333332b2b333333333333333333b3333bb3333bb3333333b3333333333333333333333
333333333333333333333333333333bbbbbb3333333bbbb3333333333333333bbbb333333333333333333bbbbbbbbbbbb3333333333333333333333333333333
33333333333333333333333333333332b2b3333333339993b3333333333333339993b3333333333b3333b32b2b332b2b33333333333333333333333333333333
3333333333333333333333333333333bbbb3333333b3434333333333333333b3434333333333333bbbbbbbbbbbb3bbbb3b883333333333333333573333333333
333333333333333333333333333333339993b33b33333333333333333333333333333333333333332b2b6bbbbbbbb999bb80833333333333333566d333333333
333333333333333333333333333333b3434bbbbb33333333333333333333333333b3333b33333333bbbb6b2b2b3b34b4b3b8833333333333335666d333333333
333333333333333333333333333333333332b2b333333333333333333333333333bbbbbb3333333339996bbbbbb33bbbbb33333333333333315666d333333333
33333333333333333333333333333333333bbbb33333333333333333333333333332b2b33333333b145466d9993b339993b3333333333333115666d333333333
3333333333333333333333333333333333339993b33333333333333333333333333bbbb3333b3333b31ddb343433b3434333333333333333331ddd3333333333
3333333333333333333333333333333333b3434333333333333333333333333333339993b33bbbbbb33333333333333333333333333333333333333333333333
333333333333333333333333333333333333333333333333333333333333333333b3434333332b2b333333333333333333333333333333333333333333333333
3333333333333333333333333333333333333333333333333333333333333333333333333333bbbb333333333333333333333333333333333333333333333333
333333333333333333333333333333333333333333333333333333333333a33333333333333339993b3333b3333333b333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333a7a3333333333333b343433333b3333333b3333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333ba333333333333333333333b33b3333b33b3333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333b333333333333333333333b3333333b33333333333333333333333333333333333333
333333333333333333333333333333333333333333333333333333333333333333333333333333333b3333333b33333333333333333333333333333333333333
33333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333333

__map__
7070707070707070707070707070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707070707070707070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707070707070707070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707070707070707171707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707075707070707570717170707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7075707075707171717171717070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070727070717175707070707171717000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070717171717070707070717170707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7071707070707070707171717071707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070717171717174717170707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707071717071717171717070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707170717171707070707070767100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707171717070707070707071717100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707070707070707171707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707070707076717470767000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707072707071717070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707071717171707670707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7070707070707070707070707070707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000000000000000000200502405000000280502a050000002a050000002a0502905000000270502505023050220502205000000000000000000000000000000000000000000000000000000000000000000
0801000000400004003b4003a4503a4503945039450384503745037450354503545032450314502f4502d4502a4502745024450214501d45019450164501345012450104500f4500d4500d4500b4000040000400
0001000000000000000000022650256502665029650306503f6503f6503e6503a65037650326502b6502565000000000000000000000000000000000000000000000000000000000000000000000000000000000
0109000012500115002a55030550355503655037550375503655034550315502e5502c550275502555024550245502555028550285502755027550265502655025550255502655006500275502a5502c5502e550
