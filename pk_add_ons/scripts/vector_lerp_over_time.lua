vector_lerp_over_time = vector_lerp_over_time or {}
vector_lerp_over_time.vlot_stored_delta = {}
vector_lerp_over_time.start_position = {}

function vector_lerp_over_time.lerp_vector(t, id)
    local ratio = 0
    
    if not t.transition_time then
        Print("The Transition Time was not given for the node Vector Lerp over Time")
    end 
    
    if not vector_lerp_over_time.start_position[id] then
        vector_lerp_over_time.start_position[id] = stingray.Vector3Box(t.from_vector) 
    end
    
    if not vector_lerp_over_time.vlot_stored_delta[id] then
        vector_lerp_over_time.vlot_stored_delta[id] = 0
    end 
    
    local delta = pk_world.get_delta_time()
    vector_lerp_over_time.vlot_stored_delta[id] = delta + vector_lerp_over_time.vlot_stored_delta[id]
    
    if vector_lerp_over_time.vlot_stored_delta[id] >= t.transition_time then
        vector_lerp_over_time.vlot_stored_delta[id] = t.transition_time
    end
    
    if t.transition_type == "linear" then
        ratio = vector_lerp_over_time.vlot_stored_delta[id] / t.transition_time
    end
    
    if t.transition_type == "quadratic_in-out" then
        ratio = pk_math.quadratic_ease_in_out(vector_lerp_over_time.vlot_stored_delta[id], 0, 1, t.transition_time)
    end
    
    if t.transition_type == "quadratic_in" then
        ratio = pk_math.quadratic_ease_in(vector_lerp_over_time.vlot_stored_delta[id], 0, 1, t.transition_time)
    end
        
    if ratio >= 1 then
        ratio = 1
        t.complete = true
        t.complete_out = true
    else
        t.complete = false
        t.complete_out = false
    end
    
    t.ratio = ratio
    t.vector_out = stingray.Vector3.lerp(stingray.Vector3Box.unbox(vector_lerp_over_time.start_position[id]), t.to_vector, ratio)
    t.common_out = true
    return t
end

function vector_lerp_over_time.reset_lerp_vector(t, id)
    vector_lerp_over_time.vlot_stored_delta[id] = 0

end
