
pk_math.start_rotation = pk_math.start_rotation or {}
pk_math.stored_delta = pk_math.stored_delta or {}

function pk_math.smooth_rotation(rotation_a, rotation_b, transition_time, node_id)
    if not pk_math.start_rotation[node_id] then
        pk_math.start_rotation[node_id] = stingray.QuaternionBox(rotation_a) 
    end
    
    if not pk_math.stored_delta[node_id] then
        pk_math.stored_delta[node_id] = 0
    end 
    
    delta = pk_world.get_delta_time()
    pk_math.stored_delta[node_id] = delta + pk_math.stored_delta[node_id]

    if pk_math.stored_delta[node_id] >= transition_time then
        pk_math.stored_delta[node_id] = transition_time
    end
    
    -- ratio = pk_math.stored_delta[node_id] / transition_time
    ratio = pk_math.quadratic_ease_in_out(pk_math.stored_delta[node_id], 0, 1, transition_time)
    
    if ratio >= 1 then
        ratio = 1
    end
    
    lerp_result = stingray.Quaternion.lerp(stingray.QuaternionBox.unbox(pk_math.start_rotation[node_id]), rotation_b, ratio)
    
    return lerp_result
end