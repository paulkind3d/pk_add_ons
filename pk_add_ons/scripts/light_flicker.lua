flicker = flicker or {}

flicker.lf_stored_delta = {}
flicker.random_intensity = {}
flicker.lf_switch = {}
flicker.flicker_rate = {}
function flicker.flicker_light(t, id)
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
    
    
    if not flicker.lf_stored_delta[id] then
        flicker.lf_stored_delta[id] = 0
        flicker.random_intensity[id] = math.random(t.light_intensity_min, t.light_intensity_max)
        flicker.flicker_rate[id] = math.random(t.flicker_time_min, t.flicker_time_max)
        flicker.lf_switch[id] = true
    end
    
    light = stingray.Unit.light( t.light_unit, t.light_index )
    
    delta = pk_world.get_delta_time()
    flicker.lf_stored_delta[id] = delta + flicker.lf_stored_delta[id]

    
    if flicker.lf_stored_delta[id] >= flicker.flicker_rate[id] then
        
        median_value = ((t.light_intensity_min + t.light_intensity_max) * .5)
        flicker.flicker_rate[id] = math.random(t.flicker_time_min, t.flicker_time_max)
        
        -- low flicker
        if flicker.lf_switch[id] then
        flicker.random_intensity[id] = math.random(t.light_intensity_min, median_value)
        flicker.lf_switch[id] = false
        flicker.lf_stored_delta[id] = 0
        else
        -- high flicker
        flicker.random_intensity[id] = math.random(median_value, t.light_intensity_max)
        flicker.lf_switch[id] = false
        flicker.lf_stored_delta[id] = 0
        end
    end
    
    stingray.Light.set_intensity(light, flicker.random_intensity[id])
    t.current_value = flicker.random_intensity[id]
    return t
end
