-- LASER POINTER SCRIPT by Paul Kind (2017)
laser_pointer = laser_pointer or {}

-- declare stored variables
laser_pointer.laser_on = laser_pointer.laser_on or {}
laser_pointer.stored_hit = laser_pointer.stored_hit or {}
laser_pointer.stored_not_hit = laser_pointer.stored_not_hit or {}
laser_pointer.stored_actor = laser_pointer.stored_actor or {}
laser_pointer.stored_laser_unit = laser_pointer.stored_laser_unit or {}
laser_pointer.stored_contact_unit = laser_pointer.stored_contact_unit or {}
laser_pointer.message_sent = laser_pointer.message_sent or {}

function laser_pointer.start_laser(t, id)
    laser_pointer.laser_on[id] = true
    laser_pointer.stored_hit[id] = true
    laser_pointer.stored_not_hit[id] = true
    laser_pointer.message_sent[id] = false
end

function laser_pointer.stop_laser(t, id)
    laser_pointer.laser_on[id] = false
    laser_pointer.message_sent[id] = false
    
    if laser_pointer.stored_laser_unit[id] then
        stingray.Unit.set_unit_visibility(laser_pointer.stored_laser_unit[id], false)
    end
    
    if laser_pointer.stored_contact_unit[id] then
        stingray.Unit.set_unit_visibility(laser_pointer.stored_contact_unit[id], false)
    end
end

function laser_pointer.laser_pointer(t, id)
    --initialize local variables
    local my_direction = nil
    local my_scale = nil
    local hit = nil
    t.hit = nil
    t.not_hit = nil
    
    -- ensure athe starting point is supplied.
    if not t.start_position then
        if laser_pointer.message_sent[id] == false then
            print ("No start Position was supplied to the Laser Pointer Node")
            laser_pointer.message_sent[id] = true
        end
        
        return t
    end
    
    -- Ensure Length was supplied
    if not t.length then
        if laser_pointer.message_sent[id] == false then
            print "No Length was supplied to the Laser Pointer Node"
            laser_pointer.message_sent[id] = true
        end
        
        return t
    end
    
    if t.invert_projection == true then
        local quick_rotate = stingray.Quaternion.from_euler_angles_xyz(0, 0, 180)
        t.rotation = stingray.Quaternion.multiply(t.rotation, quick_rotate) 
    end

    -- Ensure that rotation was supplied, if so, calculate my direction
    if t.rotation then
        my_direction = stingray.Quaternion.forward(t.rotation)
    else
        if laser_pointer.message_sent[id] == false then
            print ("Rotation was not supplied to the Laser Pointer Node")
            laser_pointer.message_sent[id] = true
        end
        
        return t
    end
    
   -- check for all rewuired data if "Laser And Contact" selected.
    if t.projection == "laser and contact" then
        if not t.laser_unit then
            if not laser_pointer.stored_laser_unit[id] then
                laser_pointer.stored_laser_unit[id] = stingray.World.spawn_unit(pk_world.get_world(), "pk_add_ons/content/laser_pointer/laser", t.start_position, t.rotation)
                t.laser_unit = laser_pointer.stored_laser_unit[id]
            else
                t.laser_unit = laser_pointer.stored_laser_unit[id]
            end
        else
            laser_pointer.stored_laser_unit[id] = t.laser_unit
        end
        
        if not t.laser_contact_unit then
            if not laser_pointer.stored_contact_unit[id] then
                laser_pointer.stored_contact_unit[id] = stingray.World.spawn_unit(pk_world.get_world(), "pk_add_ons/content/laser_pointer/contact", t.start_position, t.rotation)
                t.laser_contact_unit = laser_pointer.stored_contact_unit[id]
            else
                t.laser_contact_unit = laser_pointer.stored_contact_unit[id]
            end
        else
            laser_pointer.stored_contact_unit[id] = t.laser_contact_unit
        end
        
        if laser_pointer.laser_on[id] then
            if t.laser_unit then
                stingray.Unit.set_unit_visibility(t.laser_unit, true)
            else
                if laser_pointer.message_sent[id] == false then
                    print ("No laser unit was supplied to the Laser Pointer Node")
                    laser_pointer.message_sent[id] = true
                else
                    return t  
                end
            end
            if t.laser_contact_unit then
                stingray.Unit.set_unit_visibility(t.laser_contact_unit, true)
            else
                if laser_pointer.message_sent[id] == false then
                    print ("No Contact Unit was supplied to the Laser Pointer Node")
                    laser_pointer.message_sent[id] = true
                else
                    return t
                end
            end
                    
        end
    end

    -- check for all required data if "Laser Only" selected.
    if t.projection == "laser only" then
        if not t.laser_unit then
            if not laser_pointer.stored_laser_unit[id] then
                laser_pointer.stored_laser_unit[id] = stingray.World.spawn_unit(pk_world.get_world(), "content/models/laser_pointer/laser", t.start_position, t.rotation)
                t.laser_unit = laser_pointer.stored_laser_unit[id]
            else
                t.laser_unit = laser_pointer.stored_laser_unit[id]
            end
        else
            laser_pointer.stored_laser_unit[id] = t.laser_unit
        end
    
        if laser_pointer.laser_on[id] then
            if t.laser_contact_unit then
                stingray.Unit.set_unit_visibility(t.laser_contact_unit, false)
            end
            
            if t.laser_unit then
                stingray.Unit.set_unit_visibility(t.laser_unit, true)
            else
                if laser_pointer.message_sent[id] == false then
                    print ("No laser unit was supplied to the Laser Pointer Node")
                    laser_pointer.message_sent[id] = true
                else
                    return t  
                end
            end
        end
    end

    -- Check for all required data if "Contact Only" selected.
    if t.projection == "contact only" then
        if not t.laser_contact_unit then
            if not laser_pointer.stored_contact_unit[id] then
                laser_pointer.stored_contact_unit[id] = stingray.World.spawn_unit(pk_world.get_world(), "content/models/laser_pointer/contact", t.start_position, t.rotation)
                t.laser_contact_unit = laser_pointer.stored_contact_unit[id]
            else
                t.laser_contact_unit = laser_pointer.stored_contact_unit[id]
            end
        else
            laser_pointer.stored_contact_unit[id] = t.laser_contact_unit
        end
        
        if laser_pointer.laser_on[id] then
            if t.laser_unit then
                stingray.Unit.set_unit_visibility(t.laser_unit, false)
            end
            
            if t.laser_contact_unit then
                stingray.Unit.set_unit_visibility(t.laser_contact_unit, true)
            else
                if laser_pointer.message_sent[id] == false then
                    print ("No Contact Unit was supplied to the Laser Pointer Node")
                    laser_pointer.message_sent[id] = true
                else
                    return t
                end
            end
        end
    end

    -- ok, all checks complete, initialize the node
    if not laser_pointer.laser_on[id] then
        if t.laser_contact_unit then
            stingray.Unit.set_unit_visibility(t.laser_contact_unit, false)
        end
        if t.laser_unit then
            stingray.Unit.set_unit_visibility(t.laser_unit, false)
        end
        t.common_out = true
        return t
    end
    
    
    -- set the position and rotation of the laser
    transform_matrix = stingray.Matrix4x4.from_quaternion_position(t.rotation, t.start_position)
    
    -- if x, y, z are "nil" set them to 0
    if not t.offset_x then
        t.offset_x = 0
    end
    if not t.offset_y then
        t.offset_y = 0
    end
    if not t.offset_z then
        t.offset_z = 0
    end
    
    -- create the offset vector3
    offset = stingray.Vector3(t.offset_x, t.offset_y, t.offset_z)
    
    -- use the offset vector3 to create the 4x4 matrix so we can perform the offset locally.
    t.start_position = stingray.Matrix4x4.transform(transform_matrix, offset)
    
    -- Perform the proper ray trace based on t.hit_filter
    if t.hit_filter then
        hit, t.collision_point, t.distance, t.hit_normal, t.hit_actor = stingray.PhysicsWorld.raycast(pk_world.get_physics_world(), t.start_position, my_direction, t.length, "closest", "types", t.hit_types, "collision_filter", t.hit_filter)
    else
        hit, t.collision_point, t.distance, t.hit_normal, t.hit_actor = stingray.PhysicsWorld.raycast(pk_world.get_physics_world(), t.start_position, my_direction, t.length, "closest", "types", t.hit_types)
    end
    
    -- if we are using a laser unit, set its transform/rotation.
    if t.laser_unit then
        stingray.Unit.set_local_position(t.laser_unit, 1, t.start_position)
        stingray.Unit.set_local_rotation(t.laser_unit, 1, t.rotation)
    end
    
    -- set the stored actor to the hit actor if the actor has changed.
        if laser_pointer.stored_actor[id] ~= t.hit_actor then
            laser_pointer.stored_actor[id] = t.hit_actor
            laser_pointer.stored_hit[id] = true
            laser_pointer.stored_not_hit[id] = true
        end
        
    -- did we hit an object?
    if hit and t.distance then
        t.distance_il_laser_scale = t.distance
        my_scale = stingray.Vector3(1, t.distance, 1)
        my_scale = my_scale * -1
        
        if t.laser_unit then
            stingray.Unit.set_local_scale(t.laser_unit, 1, my_scale)
        end
        
        if t.laser_contact_unit then
            stingray.Unit.set_local_position(t.laser_contact_unit, 1, t.collision_point)
            t.hit_normal_rotation = stingray.Quaternion.look(t.hit_normal)
            stingray.Unit.set_local_rotation(t.laser_contact_unit, 1, t.hit_normal_rotation)
        end
        
        t.hit_unit = stingray.Actor.unit(t.hit_actor)
        t.hit_actor_id = stingray.Actor.node(t.hit_actor)
        t.hit_position = t.collision_point
            -- fire the events
            -- Ensure t.hit only fires once.
        if laser_pointer.stored_hit[id] == true then
            laser_pointer.stored_hit[id] = false
            t.hit = true
        else
            t.hit = nil
        end
            
        t.not_hit = nil
        t.common_out = true
            
        t.hitting = true
        return t
    else
        t.distance_il_laser_scale = t.length
        my_scale = stingray.Vector3(1, t.length, 1)
        my_scale = my_scale * -1
        if t.laser_unit then
            stingray.Unit.set_local_scale(t.laser_unit, 1, my_scale)
        end
            
            -- disable the contact unit.
        if t.laser_contact_unit then
            stingray.Unit.set_unit_visibility(t.laser_contact_unit, false)
        end

        if laser_pointer.stored_not_hit[id] == true then
            laser_pointer.stored_not_hit[id] = false
            t.not_hit = true
        else
            t.not_hit = nil
        end
            
        t.hit = false
        t.common_out = true
        t.hitting = false
        t.laser_unit_out = t.laser_unit
        t.laser_contact_unit_out = t.laser_contact_unit
        return t
    end
end


