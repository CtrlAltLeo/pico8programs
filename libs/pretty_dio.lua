-- testing functions
function _init()
cls()
add_msg("I'm red dabadeebabada dabadeebabada red red red red red red red red red red red", 8, 0)
add_msg("Green bean greenie beanie hahahah heeee gree greee gree", 11, 0)
end

function _draw()
cls()
rectfill(0,0,128,128,2)
draw_printer()
end

function _update()
update_printer()
end
-- end testing

box = {x=1, y=102, w=125, h=21, border = 5, fill = 7}

msg_queue = {}
visible = 0

delta_t = 0.1
new_t = delta_t

--[[ msg animations: 
0: normal
1: wavey
2: on fire
--]]

function add_msg(txt, color, animation)
add(msg_queue,
    {txt = format_text(txt),
    color = color,
    animation = animation})
end

function format_text(text)
  line_width = box.w - box.x - 4  

  words = split(text, " ")

  line = ""
  result = ""

  for w in all(words) do
    l = #line + #w

    if l*4 < line_width then
      if l == #w then
        line = line..w 
      else 
        line = line.." "..w 
      end
    else 
      result = result..line.."\n"
      line = w
    end
  end

  result = result..line

  return result
end

--draws everything
function draw_printer()
rectfill(box.x, box.y, box.x+box.w, box.y+box.h, box.fill)
rect(box.x, box.y, box.x+box.w, box.y+box.h, box.border)

active_msg = msg_queue[1]

if active_msg != nil then
  animate_text(active_msg)
end
end

function animate_text(active_msg)
  if active_msg.animation == 0 then
   print(sub(active_msg.txt, 1, visible), box.x + 2, box.y+2, active_msg.color)
  end
end

--handles all updates
function update_printer()
if time() > new_t then
  new_t = time() + delta_t
  visible += 1
end

if btnp(4) then
  if #msg_queue  == 0 then
    return
  end

  if visible < #msg_queue[1].txt then
    visible = #msg_queue[1].txt
  else 
   del(msg_queue, msg_queue[1]) 
   visible = 0
  end
end

end
