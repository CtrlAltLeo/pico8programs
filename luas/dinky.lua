function _init()

  guy(63,63)

end

function _update()
  upd_guy()
end

function _draw()

  cls()

  for g in all(guys) do
    pset(g.x,g.y, 7)
    print(g.mood, g.x+7,g.y)
  end

end


guys = {}

function guy(x,y)
  add(guys, {x=x,y=y})
end

function upd_guy()

  for g in all(guys) do

    if g.mood == nil then
      g.mood = "move"
      g.mood_time = 0
      break
    end

    if g.mood == "move" then

    end

  end

end
