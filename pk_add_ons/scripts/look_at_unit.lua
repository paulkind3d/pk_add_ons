require 'pk_add_ons/scripts/smooth_rotation'
require 'pk_add_ons/scripts/easing_functions'

look_at_unit = look_at_unit or {}

-- Look at function
look_at_unit.looker = {}
look_at_unit.observed = {}
look_at_unit.node_num = {}
look_at_unit.rotation = {}
look_at_unit.looker_unit_rotation = {}
look_at_unit.inverse_looker_unit_rotation = {}
look_at_unit.ulau_stored_delta = {}
look_at_unit.start_rotation = {}

function look_at_unit.unit_look_at_unit(t, id)
    --    1. find the vector from the looker to the observer (subtracting vectors = stingray.Vector3.subtract(vector_a, vector_b)  )
    --    2. turn vector into a rotation (look at function = stingray.Quaternion.look(dir, up)  )
    --    3. apply the roatation to the looker units mesh/unit (set the rotation)
    -- test to see if the needed looker unit is supplied.
        node_id = id
        
        if t.stop_looking == true then
            look_at_unit.start_rotation[node_id] = nil
            look_at_unit.ulau_stored_delta[node_id] = nil
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
        look_at_unit.looker[id] = stingray.Unit.world_position(t.looker_unit, 1)
        -- is a mesh supplied?
        if t.looker_unit_mesh then
            -- ok, get the mesh node # from the supplied mesh name.
            look_at_unit.node_num[id] = stingray.Unit.node(t.looker_unit, t.looker_unit_mesh)
            -- use that node number to discard the previously set looker position vector and replace it with the mesh position vector.
            look_at_unit.looker[id] = stingray.Unit.world_position(t.looker_unit, look_at_unit.node_num[id])
        end
        -- set the observed units position.
        look_at_unit.observed[id] = stingray.Unit.world_position(t.observed_unit, 1)
       
        -- subtract the vectors to get the vector between them
        local direction_vector = stingray.Vector3.subtract(look_at_unit.observed[id], look_at_unit.looker[id])
        
        -- test to see if this is going to be a horizontal rotation.
        if t.flat_rotation then
            -- it is, nullify the z value.
            direction_vector.z = 0
        end
        
        if t.invert_z then
            direction_vector.z = direction_vector.z * (-1)
        end
        
        -- look using the look at function with the direction vector.
        look_at_unit.rotation[id] = stingray.Quaternion.look(direction_vector)
        
        -- are we using a mesh?
        if t.looker_unit_mesh then
            -- yep, we are.  
            -- get the current rotation of the unit.
            look_at_unit.looker_unit_rotation[id] = stingray.Unit.world_rotation(t.looker_unit, 1)
            -- apply its inverse to nullify the rotation.
            look_at_unit.inverse_looker_unit_rotation[id] = stingray.Quaternion.inverse(look_at_unit.looker_unit_rotation[id])
            -- multiply the nullified rotation with the look at rotation of the supplied mesh to get the new correct rotation.
            look_at_unit.rotation[id] = stingray.Quaternion.multiply(look_at_unit.inverse_looker_unit_rotation[id], look_at_unit.rotation[id])
            
            -- Use smoothing?
             if t.smooth_results == true then
                if t.transition_time then
                    look_at_unit.rotation[id] = pk_math.smooth_rotation(stingray.Unit.local_rotation(t.looker_unit, look_at_unit.node_num[id]), look_at_unit.rotation[id], t.transition_time, node_id)
                else
                    print ("The transition time was not set in the Unit Look at Unit node")
                    return
                end
            end
        
            -- apply the rotation.
            stingray.Unit.set_local_rotation(t.looker_unit, look_at_unit.node_num[id], look_at_unit.rotation[id])
            
        
        else
            -- 
            -- lerp the results
            if t.smooth_results == true then
                if t.transition_time then
                    look_at_unit.rotation[id] = pk_math.smooth_rotation(stingray.Unit.world_rotation(t.looker_unit, 1), look_at_unit.rotation[id], t.transition_time, node_id)
                else
                    print ("The transition time was not set in the Unit Look at Unit node")
                    return
                end
            end
        
            stingray.Unit.set_local_rotation(t.looker_unit, 1, look_at_unit.rotation[id])
        end
        
        
        
        t.rotation_out = look_at_unit.rotation[id]
        return (t)
end
