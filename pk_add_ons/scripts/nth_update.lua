-- Written by Paul Kind 2017

nth_update = nth_update or {}
nth_update.count = nth_update.count or {}

function nth_update.update(t, id)
	if not nth_update.count[id] then
		nth_update.count[id] = 0
	end
	
	nth_update.count[id] = nth_update.count[id] + 1
	if nth_update.count[id] >= t.nth_update then
		nth_update.count[id] = 0
		t.common_out = true
		t.nth_out = true
		return t
	end

	t.common_out = true
	t.nth_out = false

end
