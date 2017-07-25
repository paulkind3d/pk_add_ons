pk_debug = pk_debug or {}
-- super debugger 

function pk_debug.super_debugger(t)
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
         local world_wrapper = Appkit.get_managed_world_wrapper(pk_world.get_world())
        
        local my_color = stingray.Color(255, 255, 255)
        world_wrapper:debug_display_text(t.debug_message_prefix .. my_string .. t.debug_message_suffix, my_color)
    else
        print(t.debug_message_prefix .. my_string .. t.debug_message_suffix)
    end
    
end
