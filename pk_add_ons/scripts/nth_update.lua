nth_update = nth_update or {}

nth_update.count = 0

function nth_update.update(t)
	nth_update.count = nth_update.count + 1
	if nth_update.count >= t.nth_update then
		nth_update.count = 0
		t.common_out = true
		t.nth_out = true
		return (t)
	end

	t.common_out = true
	t.nth_out = false

end


