do_once_with_reset = do_once_with_reset or {}
do_once_with_reset.status = do_once_with_reset.status or {}


function do_once_with_reset.do_once(t, id)
	if not do_once_with_reset.status[id] then
		do_once_with_reset.status[id] = true
		t.controlled_out = true
		return t
	end

	t.controlled_out = false
end

function do_once_with_reset.reset_me(t, id)
	do_once_with_reset.status[id] = nil
end
