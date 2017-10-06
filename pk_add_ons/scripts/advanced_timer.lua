advanced_timer = advanced_timer or {}
advanced_timer.goal = advanced_timer.goal or {}
advanced_timer.start_time = advanced_timer.start_time or {}
advanced_timer.complete = advanced_timer.complete or {}

function advanced_timer.set_timer(t, id)
	advanced_timer.start_time[id] = stingray.Application.time_since_launch()
 	advanced_timer.goal[id] = t.seconds + stingray.Application.time_since_launch()
 	advanced_timer.complete[id] = false
end

function advanced_timer.check_timer(t, id)
	if stingray.Application.time_since_launch() >= advanced_timer.goal[id] then
		if advanced_timer.complete[id] == false then
			advanced_timer.complete[id] = true
			t.complete = true
			t.complete_repeat = true
			t.time_remaining = 0
			t.current_time = t.seconds

			t.percentage_complete = 1
			t.percentage_remaining = 0

			t.common_out = true 
			return t
		end
		t.time_remaining = 0
		t.current_time = t.seconds
		t.complete = false
		t.complete_repeat = true
		t.common_out = true
		return t
	else
		t.complete = false
		t.complete_repeat = false
		t.time_remaining = advanced_timer.goal[id] - stingray.Application.time_since_launch()
		t.current_time = (advanced_timer.goal[id] - stingray.Application.time_since_launch() - t.seconds) * -1
		t.percentage_complete = (t.seconds - t.time_remaining) / t.seconds
		t.percentage_remaining = (t.seconds - t.current_time) / t.seconds
		t.common_out = true
		return t
	end


end
