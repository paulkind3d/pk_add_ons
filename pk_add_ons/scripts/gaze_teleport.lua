-- Gaze Teleport by Paul Kind 2017
gaze_teleport = gaze_teleport or {}
require 'script/lua/flow_callbacks'

function gaze_teleport.get_world()
    -- return Appkit.SimpleProject.world
    return stingray.Application.flow_callback_context_world()
end

function gaze_teleport.get_physics_world()
    return stingray.World.physics_world(laser_pointer.get_world())
end

-- Get the Delta Time
function gaze_teleport.get_delta_time()
    return stingray.World.delta_time(pk_scripts.get_world())
end

-- Create  Variables.
gazed = gazed or {}
gazed.initialize = true
gazed.hit = nil
gazed.position = nil
gazed.distance = nil
gazed.normal = nil
gazed.normal_rotation = nil
gazed.actor = nil
gazed.unit = nil
gazed.stored_position = nil
gazed.reset_position = true
gazed.store_trigger_time = true
gazed.trigger_time = nil
gazed.reset_trigger_time = true
gazed.teleport_time = nil
gazed.reset_teleport_time = true
gazed.teleport_percent_complete = 0
gazed.stored_distance = nil
gazed.init_hit = nil
gazed.init_position = nil
gazed.init_distance = nil
gazed.init_normal = nil
gazed.init_actor = nil



function gaze_teleport.gaze(t)
    gazed.hit = false
    gazed.init_hit = false
    t.common_out = true
    t.teleport_complete = false
    t.teleport_percent_complete = 0
    gazed_stored_distance = 0
    t.gazed_distance = gazed.stored_distance
    if gazed.initialize == true then
        stingray.Unit.set_unit_visibility(t.teleport_icon, false)
        gazed.initialize = false
    end

    local gaze_rotation = stingray.Quaternion.forward(t.gaze_rotation)
    -- cast an initial ray to see if you are hitting somthing.  (No Filter)
    gazed.init_hit, gazed.init_position, gazed.init_distance, gazed.init_normal, gazed.init_actor = stingray.PhysicsWorld.raycast(gaze_teleport.get_physics_world(), t.gaze_position, gaze_rotation, t.gaze_length, "closest", "types", "both")
    

    if gazed.init_hit == true then
        -- Create a Raycast "gaze" which will take the filter into account to see if the raycast is valid.
        gazed.hit, gazed.position, gazed.distance, gazed.normal, gazed.actor = stingray.PhysicsWorld.raycast(gaze_teleport.get_physics_world(), t.gaze_position, gaze_rotation, t.gaze_length, "closest", "types", "both", "collision_filter", "gaze_teleport")
        
        -- Test the filtered rays distance vs the unfiltered ray and also test if you are looking downwards as if either case is true, we can assume its not a valid teleport location.
        if gazed.distance ~= gazed.init_distance or gazed.position["z"] >= t.gaze_position["z"] then
            -- set gazed.hit back to false.
            gazed.hit = false
            gazed.reset_trigger_time = true
            gazed.reset_teleport_time = true
            gazed.reset_position = true
            t.icon_distance = gazed.stored_distance
            stingray.Unit.set_unit_visibility(t.teleport_icon, false)
            return t
        end
    end

    if gazed.hit == true then
        if gazed.reset_position == true then
            gazed.stored_position = stingray.Vector3Box(gazed.position)
            gazed.stored_distance = gazed.distance
            gazed.reset_position = false
        end

        local stored_position = stingray.Vector3Box.unbox(gazed.stored_position)

        -- Is the gaze within the gaze_allowance amount on X,Y,Z?
        if gazed.position["x"] < stored_position["x"] + t.gaze_allowance * gazed.distance and gazed.position["x"] > stored_position["x"] - t.gaze_allowance * gazed.distance and gazed.position["y"] < stored_position["y"] + t.gaze_allowance * gazed.distance and gazed.position["y"] > stored_position["y"] - t.gaze_allowance * gazed.distance and gazed.position["z"] < stored_position["z"] + t.gaze_allowance * gazed.distance and gazed.position["z"] > stored_position["z"] - t.gaze_allowance * gazed.distance then
            --reset the trigger timer?
            if gazed.reset_trigger_time == true then
                gazed.trigger_time = stingray.World.time(gaze_teleport.get_world()) + t.trigger_time
                gazed.reset_trigger_time = false
            end
            -- 
            if gazed.trigger_time <= stingray.World.time(gaze_teleport.get_world()) then
                -- Place Icon.
                stingray.Unit.set_unit_visibility(t.teleport_icon, true)
                stingray.Unit.set_local_position(t.teleport_icon, 1, stored_position)
                gazed.normal_rotation = stingray.Quaternion.look(gazed.normal)
                stingray.Unit.set_local_rotation(t.teleport_icon, 1, gazed.normal_rotation)

                -- start teleport timer
                if gazed.reset_teleport_time == true then
                    gazed.teleport_time = stingray.World.time(gaze_teleport.get_world()) + t.teleport_time
                    gazed.reset_teleport_time = false
                end

                if gazed.teleport_time <= stingray.World.time(gaze_teleport.get_world()) then
                    local my_pose = stingray.Matrix4x4.from_quaternion_position(stingray.Quaternion.identity(), stored_position)
                    stingray.Matrix4x4.set_scale(my_pose, t.h_m_d_scale)

                    if t.h_m_d_type == "steam_vr" then
                        stingray.SteamVR.set_tracking_space(stored_position, stingray.Quaternion.identity(), t.h_m_d_scale)
                    end

                    if t.h_m_d_type == "oculus_vr" then
                        stingray.Oculus.set_tracking_space(stored_position, stingray.Quaternion.identity(), t.h_m_d_scale)
                    end

                    if t.h_m_d_type == "google_vr" then
                        stingray.GoogleVR.set_tracking_space_pose(my_pose)
                    end

                    if t.h_m_d_type == "gear_vr" then
                        stingray.GearVR.set_tracking_space_pose(my_pose)
                    end

                    gazed.reset_trigger_time = true
                    gazed.reset_teleport_time = true
                    gazed.reset_position = true
                    t.icon_distance = gazed.stored_distance
                    stingray.Unit.set_unit_visibility(t.teleport_icon, false)
                    t.teleport_complete = true
                    return t
                else
                    t.teleport_percent_complete = (stingray.World.time(gaze_teleport.get_world()) - (gazed.teleport_time - t.teleport_time)) / t.teleport_time
                    t.icon_distance = gazed.stored_distance
                    return t
                end

                 --print (tostring(stingray.World.time(gaze_teleport.get_world())))
                 --print (tostring(gazed.trigger_time))
            end

        else
            gazed.reset_trigger_time = true
            gazed.reset_teleport_time = true
            gazed.reset_position = true
            t.icon_distance = gazed.stored_distance
            stingray.Unit.set_unit_visibility(t.teleport_icon, false)
            return t
        end
    end
    return t
end
