simple_timer = simple_timer or {}
simple_timer.goal = simple_timer.goal or {}
simple_timer.start_time = simple_timer.start_time or {}
simple_timer.complete = simple_timer.complete or {}

function simple_timer.set_timer(t, id)
	simple_timer.start_time[id] = stingray.Application.time_since_launch()
 	simple_timer.goal[id] = t.seconds + stingray.Application.time_since_launch()
 	simple_timer.complete[id] = false
end

function simple_timer.check_timer(t, id)
	if stingray.Application.time_since_launch() >= simple_timer.goal[id] then
		if simple_timer.complete[id] == false then
			simple_timer.complete[id] = true
			t.complete = true
			t.complete_repeat = true
			return t
		end

		t.complete = false
		t.complete_repeat = true
		return t
	end

end