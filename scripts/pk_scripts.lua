pk_scripts = pk_scripts or {}
require 'script/lua/flow_callbacks'

-- declare the world from simple_project
function pk_scripts.get_world()
    --return Appkit.SimpleProject.world
    return stingray.Application.flow_callback_context_world()
end


-- says hello!
function pk_scripts.hello_world(t)
    print("hello world")
end

-- Get the Delta Time

function pk_scripts.get_delta_time()
    delta = stingray.World.delta_time(pk_scripts.get_world())
    return delta
end

-- super debugger 

function pk_scripts.super_debugger(t)
    t.debug_message_prefix = t.debug_message_prefix or "Debug Message"
    t.debug_message_suffix = t.debug_message_suffix or ""
    t.data_string = t.data_string or ""
    t.data_numeric = t.data_numeric or ""
    t.data_vector3 = t.data_vector3 or ""
    t.data_rotation = t.data_rotation or ""
    
    if t.data_boolean == nil then
        t.data_boolean = ""
    end
    
    local my_string = tostring(t.data_boolean) .. tostring(t.data_string) .. tostring(t.data_numeric) .. tostring(t.data_vector3) .. tostring(t.data_rotation) 
        
    if t.debug_type == "Print to Screen" then
         local world_wrapper = Appkit.get_managed_world_wrapper(pk_scripts.get_world())
        
        local my_color = stingray.Color(255, 255, 255)
        world_wrapper:debug_display_text(t.debug_message_prefix .. my_string .. t.debug_message_suffix, my_color)
    else
        print(t.debug_message_prefix .. my_string .. t.debug_message_suffix)
    end
    
end

-- Supe Sum

function pk_scripts.super_sum(t)
    local num1 = 0
    local num2 = 0
    local num3 = 0
    local num4 = 0
    local num5 = 0
    local num6 = 0
    
    if t.num1 then
        num1 = t.num1
    end
    if t.num2 then
        num2 = t.num2
    end
    if t.num3 then
        num3 = t.num3
    end
    if t.num4 then
        num4 = t.num4
    end
    if t.num5 then
        num5 = t.num5
    end
    if t.num6 then
        num6 = t.num6
    end
    
    t.sum = num1 + num2 + num3 + num4 + num5 + num6
    return t
end

-- get system time

function pk_scripts.get_system_time(t)
    local pk_time = os.time()
    local nice_date = (os.date("*t", pk_time))
    
    --print("the day is : " .. tostring(nice_date.day))
    
    t.current_day = nice_date.day
    t.current_hour = nice_date.hour
    t.current_month = nice_date.month
    t.current_minute = nice_date.min
    t.current_second = nice_date.sec
    return t
end

-- super concatenator

function pk_scripts.super_contatenator(t)
   
    local concatenator = ""
    if t.concatenator then
        concatenator = t.concatenator
    end
   
    local message1 = ""
    if t.message1 then
        message1 = t.message1
    end
    
    local message2 = ""
    if t.message2 then
        message2 = concatenator .. t.message2
    end
    
    local message3 = ""
    if t.message3 then
        message3 = concatenator .. t.message3
    end
    
    local message4 = ""
    if t.message4 then
        message4 = concatenator .. t.message4
    end
    
    local message5 = ""
    if t.message5 then
        message5 = concatenator .. t.message5
    end
    
    local message6 = ""
    if t.message6 then
        message6 = concatenator .. t.message6
    end
    
    local message7 = ""
    if t.message7 then
        message7 = concatenator .. t.message7
    end
    
    local message8 = ""
    if t.message8 then
        message8 = concatenator .. t.message8
    end
    t.concatenated_string = message1 .. message2 .. message3 .. message4 .. message5 .. message6 .. message7 .. message8
    return t
end

-- seen before start

pk_scripts.seen_before = pk_scripts.seen_before or {}

function pk_scripts.have_i_seen_it_before(t)
    
    if t.num1 == nil then
        return t
    end

    if pk_scripts.seen_before[t.num1] == nil  then
        t.already_exists = false
        pk_scripts.seen_before[t.num1] = true
    else
        t.already_exists = true
    end
    
    t.input_value = t.num1
    
    return t
end

function pk_scripts.rotate_vector(t)
    t.vector_out = stingray.Quaternion.rotate(t.rotation, t.vector_in)
    return t
end

-- seen before end

-- improved sequence start

pk_scripts.pk_counters = {}
pk_scripts.counter_stop = {}

function pk_scripts.single_sequence(t, id)
    
        pk_scripts.pk_counters[id] = pk_scripts.pk_counters[id] or 1
        pk_scripts.counter_stop[id] = pk_scripts.counter_stop[id] or 1
        
        if t.sequence_used > 10 then
            t.sequence_used = 10
        end
        
        t.sequence_number = pk_scripts.pk_counters[id]
        
        if pk_scripts.pk_counters[id] < t.sequence_used then
            pk_scripts.pk_counters[id] = pk_scripts.pk_counters[id] + 1
            t["out"..t.sequence_number] = true
            t.common_out = true
        else
            if t.loop_and_repeat == true then
                pk_scripts.pk_counters[id] = 1
                t["out"..t.sequence_number] = true
                t.common_out = true
            else
                if pk_scripts.counter_stop[id] == true then
                    t.sequence_complete = true
                    t.common_out = true
                    pk_scripts.pk_counters[id] = pk_scripts.pk_counters[id] + 1
                else
                    pk_scripts.pk_counters[id] = pk_scripts.pk_counters[id] + 1
                    t["out"..t.sequence_number] = true
                    t.common_out = true
                    pk_scripts.counter_stop[id] = true
                end
                
            end
        end
        
        return t
end

-- improved sequence end


-- Look at function

pk_scripts.looker = {}
pk_scripts.observed = {}
pk_scripts.node_num = {}
pk_scripts.rotation = {}
pk_scripts.looker_unit_rotation = {}
pk_scripts.inverse_looker_unit_rotation = {}
pk_scripts.ulau_stored_delta = {}
pk_scripts.start_rotation = {}

function pk_scripts.unit_look_at_unit(t, id)
    --    1. find the vector from the looker to the observer (subtracting vectors = stingray.Vector3.subtract(vector_a, vector_b)  )
    --    2. turn vector into a rotation (look at function = stingray.Quaternion.look(dir, up)  )
    --    3. apply the roatation to the looker units mesh/unit (set the rotation)
    -- test to see if the needed looker unit is supplied.
        node_id = id
        
        if t.stop_looking == true then
            pk_scripts.start_rotation[node_id] = nil
            pk_scripts.ulau_stored_delta[node_id] = nil
            return
        end
        
        --print (tostring(node_id).."my node id")
        
        if not t.looker_unit then
            -- nope, print an error to the log and leave the function.
            print ("The Looker unit was not supplied in Unit Look at Unit")
           return
        end
        -- test to see if the needed observed unit is supplied.
        if not t.observed_unit then
            -- nope, print an error to the log and leave the function.
            print ("The Observed unit was not supplied in Unit Look at Unit")
            return
        end
        
        -- ok, good to go.  set the looker position vector.
        pk_scripts.looker[id] = stingray.Unit.world_position(t.looker_unit, 1)
        -- is a mesh supplied?
        if t.looker_unit_mesh then
            -- ok, get the mesh node # from the supplied mesh name.
            pk_scripts.node_num[id] = stingray.Unit.node(t.looker_unit, t.looker_unit_mesh)
            -- use that node number to discard the previously set looker position vector and replace it with the mesh position vector.
            pk_scripts.looker[id] = stingray.Unit.world_position(t.looker_unit, pk_scripts.node_num[id])
        end
        -- set the observed units position.
        pk_scripts.observed[id] = stingray.Unit.world_position(t.observed_unit, 1)
       
        -- subtract the vectors to get the vector between them
        local direction_vector = stingray.Vector3.subtract(pk_scripts.observed[id], pk_scripts.looker[id])
        
        -- test to see if this is going to be a horizontal rotation.
        if t.flat_rotation then
            -- it is, nullify the z value.
            direction_vector.z = 0
        end
        
        if t.invert_z then
            direction_vector.z = direction_vector.z * (-1)
        end
        
        -- look using the look at function with the direction vector.
        pk_scripts.rotation[id] = stingray.Quaternion.look(direction_vector)
        
        -- are we using a mesh?
        if t.looker_unit_mesh then
            -- yep, we are.  
            -- get the current rotation of the unit.
            pk_scripts.looker_unit_rotation[id] = stingray.Unit.world_rotation(t.looker_unit, 1)
            -- apply its inverse to nullify the rotation.
            pk_scripts.inverse_looker_unit_rotation[id] = stingray.Quaternion.inverse(pk_scripts.looker_unit_rotation[id])
            -- multiply the nullified rotation with the look at rotation of the supplied mesh to get the new correct rotation.
            pk_scripts.rotation[id] = stingray.Quaternion.multiply(pk_scripts.inverse_looker_unit_rotation[id], pk_scripts.rotation[id])
            
            -- Use smoothing?
             if t.smooth_results == true then
                if t.transition_time then
                    pk_scripts.rotation[id] = pk_scripts.smooth(stingray.Unit.local_rotation(t.looker_unit, pk_scripts.node_num[id]), pk_scripts.rotation[id], t.transition_time, node_id)
                else
                    print ("The transition time was not set in the Unit Look at Unit node")
                    return
                end
            end
        
            -- apply the rotation.
            stingray.Unit.set_local_rotation(t.looker_unit, pk_scripts.node_num[id], pk_scripts.rotation[id])
            
        
        else
            -- 
            -- lerp the results
            if t.smooth_results == true then
                if t.transition_time then
                    pk_scripts.rotation[id] = pk_scripts.smooth(stingray.Unit.world_rotation(t.looker_unit, 1), pk_scripts.rotation[id], t.transition_time, node_id)
                else
                    print ("The transition time was not set in the Unit Look at Unit node")
                    return
                end
            end
        
            stingray.Unit.set_local_rotation(t.looker_unit, 1, pk_scripts.rotation[id])
        end
        
        
        
        t.rotation_out = pk_scripts.rotation[id]
        return (t)
end

function pk_scripts.smooth(rotation_a, rotation_b, transition_time, node_id)
    if not pk_scripts.start_rotation[node_id] then
        pk_scripts.start_rotation[node_id] = stingray.QuaternionBox(rotation_a) 
    end
    
    if not pk_scripts.ulau_stored_delta[node_id] then
        pk_scripts.ulau_stored_delta[node_id] = 0
    end 
    
    delta = pk_scripts.get_delta_time()
    pk_scripts.ulau_stored_delta[node_id] = delta + pk_scripts.ulau_stored_delta[node_id]

    if pk_scripts.ulau_stored_delta[node_id] >= transition_time then
        pk_scripts.ulau_stored_delta[node_id] = transition_time
    end
    
    -- ratio = pk_scripts.ulau_stored_delta[node_id] / transition_time
    ratio = pk_scripts.quadratic_ease_in_out(pk_scripts.ulau_stored_delta[node_id], 0, 1, transition_time)
    
    if ratio >= 1 then
        ratio = 1
    end
    
    lerp_result = stingray.Quaternion.lerp(stingray.QuaternionBox.unbox(pk_scripts.start_rotation[node_id]), rotation_b, ratio)
    
    return lerp_result
end

pk_scripts.vlot_stored_delta = {}
pk_scripts.start_position = {}
function pk_scripts.vector_lerp_over_time(t, id)
    if not t.transition_time then
        Print("The Transition Time was not given for the node Vector Lerp over Time")
    end 
    
    if not pk_scripts.start_position[id] then
        pk_scripts.start_position[id] = stingray.Vector3Box(t.from_vector) 
    end
    
    if not pk_scripts.vlot_stored_delta[id] then
        pk_scripts.vlot_stored_delta[id] = 0
    end 
    
    local delta = pk_scripts.get_delta_time()
    pk_scripts.vlot_stored_delta[id] = delta + pk_scripts.vlot_stored_delta[id]
    
    if pk_scripts.vlot_stored_delta[id] >= t.transition_time then
        pk_scripts.vlot_stored_delta[id] = t.transition_time
    end
    
    if t.transition_type == "linear" then
        local ratio = pk_scripts.vlot_stored_delta[id] / t.transition_time
    end
    
    if t.transition_type == "quadratic_in-out" then
        ratio = pk_scripts.quadratic_ease_in_out(pk_scripts.vlot_stored_delta[id], 0, 1, t.transition_time)
    end
    
    if t.transition_type == "quadratic_in" then
        ratio = pk_scripts.quadratic_ease_in(pk_scripts.vlot_stored_delta[id], 0, 1, t.transition_time)
    end
        
    if ratio >= 1 then
        ratio = 1
        t.complete = true
        t.complete_out = true
    end
    
    t.ratio = ratio
    t.vector_out = stingray.Vector3.lerp(stingray.Vector3Box.unbox(pk_scripts.start_position[id]), t.to_vector, ratio)
    t.common_out = true
    return t
end

-- Swap Materials
function pk_scripts.swap_materials(t)
    if t.unit and t.slot and t.material then
        stingray.Unit.set_material(t.unit, t.slot, t.material)
    end
    return t
end

pk_scripts.lf_stored_delta = {}
pk_scripts.random_intensity = {}
pk_scripts.lf_switch = {}
pk_scripts.flicker_rate = {}
function pk_scripts.light_flicker(t, id)
    if not t.light_unit then
        print ("no light unit supplied to light flicker node")
        return
    end
    
    if not t.light_intensity_min then
        print ("no minimum light intensity supplied in light flicker node ")
        return
    end
    
    if not t.light_intensity_max then
        print ("no maximum light intensity supplied in light flicker node ")
        return
    end
    
    if not t.flicker_time_min then
        print ("no minumum flicker time supplied in light flicker node ")
        return
    end
    
    if not t.light_intensity_max then
        print ("no maximum flicker time supplied in light flicker node ")
        return
    end
    
    if t.pause_flicker == true then
        return
    end
    
    
    if not pk_scripts.lf_stored_delta[id] then
        pk_scripts.lf_stored_delta[id] = 0
        pk_scripts.random_intensity[id] = math.random(t.light_intensity_min, t.light_intensity_max)
        pk_scripts.flicker_rate[id] = math.random(t.flicker_time_min, t.flicker_time_max)
        pk_scripts.lf_switch[id] = true
    end
    
    light = stingray.Unit.light( t.light_unit, t.light_index )
    
    delta = pk_scripts.get_delta_time()
    pk_scripts.lf_stored_delta[id] = delta + pk_scripts.lf_stored_delta[id]

    
    if pk_scripts.lf_stored_delta[id] >= pk_scripts.flicker_rate[id] then
        
        median_value = ((t.light_intensity_min + t.light_intensity_max) * .5)
        pk_scripts.flicker_rate[id] = math.random(t.flicker_time_min, t.flicker_time_max)
        
        -- low flicker
        if pk_scripts.lf_switch[id] then
        pk_scripts.random_intensity[id] = math.random(t.light_intensity_min, median_value)
        pk_scripts.lf_switch[id] = false
        pk_scripts.lf_stored_delta[id] = 0
        else
        -- high flicker
        pk_scripts.random_intensity[id] = math.random(median_value, t.light_intensity_max)
        pk_scripts.lf_switch[id] = false
        pk_scripts.lf_stored_delta[id] = 0
        end
    end
    
    stingray.Light.set_intensity(light, pk_scripts.random_intensity[id])
    t.current_value = pk_scripts.random_intensity[id]
    return t
end

function pk_scripts.enable_cursor(t)
    stingray.Window.set_show_cursor(true)
end

function pk_scripts.disable_cursor(t)
    stingray.Window.set_show_cursor(false)
end

function pk_scripts.toggle_cursor(t)
    if stingray.Window.show_cursor() == true then
        stingray.Window.set_show_cursor(false)
    else
        stingray.Window.set_show_cursor(true)
    end
end




-----  EASING FUNCTIONS  -------
-- Quadratic In
function pk_scripts.quadratic_ease_in(current_time, start_position, change, duration)
	current_time = current_time / duration;
	return change * current_time * current_time + start_position
end


-- Quadratic Out


-- Quadratic In / Out
function pk_scripts.quadratic_ease_in_out (current_time, start_position, change, duration)
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


-- color to percent
function pk_scripts.color_to_percent(t)
    
    t.color[1] = t.color[1]/255
    t.color[2] = t.color[2]/255
    t.color[3] = t.color[3]/255
    

    return t
end


pk_scripts.relay_name = pk_scripts.relay_name or {}
-- pulse

function pk_scripts.create_relay(t)
    t.relay_out = false

    if pk_scripts.relay_name[t.relay_name] == nil then
        pk_scripts.relay_name[t.relay_name] = false
    end

    if pk_scripts.relay_name[t.relay_name] == false then
        pk_script.relay_name[t.relay_name] = true
    end
    
    return t
end

-- in constantly firing

function pk_scripts.test_relay_for_output(t)
    t.relay_out = true 

    if pk_scripts.relay_name[t.relay_name] then
        pk_scripts.relay_name[t.relay_name] = false
        t.relay_out = true 
    else
        print "no relay name was given to the test relay output node"
    end

    return t
end




