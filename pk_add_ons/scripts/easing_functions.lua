pk_math = pk_math or {}

-----  EASING FUNCTIONS  -------
-- Quadratic In
function pk_math.quadratic_ease_in(current_time, start_position, change, duration)
	current_time = current_time / duration;
	 qei = change * current_time * current_time + start_position
     return qei
end


-- Quadratic Out


-- Quadratic In / Out
function pk_math.quadratic_ease_in_out (current_time, start_position, change, duration)
    current_time = current_time / (duration / 2)
    if current_time < 1 then 
        qeio = change / 2 * current_time * current_time + start_position
        return qeio
    else
        current_time = current_time - 1
        qeio = -change / 2 * (current_time * (current_time - 2) - 1) + start_position
        return qeio
    end
end