replace_and_remember_material = replace_and_remember_material or {}

require 'script/lua/flow_callbacks'
replace_and_remember_material.unit_list = replace_and_remember_material.unit_list or {}
replace_and_remember_material.id_counter = 1
-- declare the world from simple_project
function replace_and_remember_material.get_world()
    -- return Appkit.SimpleProject.world
    return stingray.Application.flow_callback_context_world()
end

function replace_and_remember_material.get_physics_world()
    return stingray.World.physics_world(laser_pointer.get_world())
end

-- Get the Delta Time
function replace_and_remember_material.get_delta_time()
    return stingray.World.delta_time(pk_scripts.get_world())
end


-- Changes the material of the input data
function replace_and_remember_material.replace_and_remember_material(t, id)
    t.material_changed = false
    t.material_reset = false
    t.all_materials_reset = false
    t.out = false
    
    
    -- start by making sure the id is blank.
    local id = nil
    
    if t.unit_to_modify == nil then
        print ("no unit was supplied to the the change material node.")
    else
        id = stingray.Unit.id(t.unit_to_modify)
    end
    
    if t.mesh_to_modify == nil then
        print ("no mesh was supplied to the the change material node.")
    end
    
    local slot_id_box = nil
    local slot_id_hex_value = nil
    
    if t.mesh_slot_name_to_modify then
        slot_id_box = stingray.IdString64Box(t.mesh_slot_name_to_modify)
        slot_id_hex_value = stingray.IdString64.to_hex(t.mesh_slot_name_to_modify)
    end
    
    -- If original materials table does not exist in the effected unit, create a blank one and store it in the original_materials local variable..
    local original_materials = stingray.Unit.get_data(t.unit_to_modify, "original_material") or {}
    
    -- in the unit we will modify, store the original_materials local variable in the original materials unit data of the unit we want to modify.
    stingray.Unit.set_data(t.unit_to_modify, "original_material", original_materials)
    
    -- does original materials contain the given mesh_slot_name_to_modify?
    if not original_materials[slot_id_hex_value] then
        -- It does not, so create a key with this mesh slot with the value of the boxed original resource id.
        original_materials[slot_id_hex_value] = {stingray.IdString64Box(t.original_resource_id), slot_id_box}
    end 
    
    -- at this point, we have a table called "orinignal_materials" stored in the unit.  Inside this table we are storing the mesh slot name (as a key) and the original resource ID as the value.  
    -- So our table will be int the format of 
    -- slot_name : original_resource_id (aka_material)
    -- and will look something like this...
    -- Original Materials [
    -- (body_material)hexed : [(content/models/body_material)boxed, (body_material)boxed]
    -- (turret_material)hexed : [(content/model/turrent_material)boxed, (turret_material)boxed
    -- ]
    
    -- Next, we need to use a counter to create a variable inside our unit called replace_and_remember_material_unit_id.
    -- first will test to see if anything is stored there.
    if not stingray.Unit.has_data(t.unit_to_modify, "replace_and_remember_material_unit_id") then
        -- nope, ok, give it a unique number
        stingray.Unit.set_data(t.unit_to_modify, "replace_and_remember_material_unit_id", replace_and_remember_material.id_counter)
        -- in our (global) unit list, we will now add a key with the id and our unit as the value.
        replace_and_remember_material.unit_list[replace_and_remember_material.id_counter] = t.unit_to_modify
        -- and we will increment up the id counter.
        replace_and_remember_material.id_counter = replace_and_remember_material.id_counter + 1
    end
    
    -- Now we have a unique number stored inside our unit which we can grab later when we want to revert it back to the original material.
    -- we also have a list of units and corresponding unique id's which are stored globally.
    
    -- for example
    -- unit_list [
    -- 1 : tank
    -- 2 : wall
    -- 3 : roof
    -- 4 : floor
    -- ]
    
    -- and finally, we need to change the material to the given material_to_apply
    stingray.Unit.set_material(t.unit_to_modify, t.mesh_slot_name_to_modify, t.material_to_apply)
    -- return the outs we want to return
    t.material_changed = true
    t.out = true
    return t
end

-- resets the material of the current selection
function replace_and_remember_material.reset_material(t, id)
    t.material_changed = false
    t.material_reset = false
    t.all_materials_reset = false
    t.out = false
    
    local slot_id_hex_value = stingray.IdString64.to_hex(t.mesh_slot_name_to_modify)
    --end
    -- To reset our material we will need to reference the unit data we set when we changed the material in the first place.
    -- first, lets make a local variable and make it eqaul to the original materials table.
    local original_materials = stingray.Unit.get_data(t.unit_to_modify, "original_material")
    -- get the array in original materials
    local original_material = (original_materials[slot_id_hex_value])
    
    local slot_id = stingray.IdString64Box.unbox(original_material[2])
    local resource_id = stingray.IdString64Box.unbox(original_material[1])
    
    -- now we will simply set the material to the selected unit, mesh slot and the looked up material (which we will now unbox).
    stingray.Unit.set_material(t.unit_to_modify, slot_id, resource_id)
    
    -- return the outputs that signify what has happenend.
    t.material_reset = true
    t.out = true
    return t
end

-- reseta all materials ever effected
function replace_and_remember_material.reset_all_materials(t, id)
    t.material_changed = false
    t.material_reset = false
    t.all_materials_reset = false
    t.out = false
    
    -- To reset all the materials, we are going to use our list of units.
    -- First we will fo a for loop of the changed materials list. We will set unit_id to the key, and unit to the value.
    for unit_id, unit in pairs(replace_and_remember_material.unit_list) do
        -- now on each iteration, we will set original_materials to the table of materials in the unit.
        local original_materials = stingray.Unit.get_data(unit, "original_material")
            -- since this is a table, we will need to iterate through it as well.  here we will get the slot_name and the original material 
            for slot_hex_value, original_material in pairs(original_materials) do
                local slot_id = stingray.IdString64Box.unbox(original_material[2])
                local resource_id = stingray.IdString64Box.unbox(original_material[1])
    
                -- now we will simply set the material to the selected unit, mesh slot and the looked up material (which we will now unbox).
                stingray.Unit.set_material(unit, slot_id, resource_id)
        end
    end
    
    -- return the outputs that signify what has happenend.
    t.all_materials_reset = true
    t.out = true
    return t
end



--- String version

replace_and_remember_material_str = replace_and_remember_material_str or {}
replace_and_remember_material_str.unit_list = replace_and_remember_material_str.unit_list or {}
replace_and_remember_material_str.id_counter = 1

-- Changes the material of the input data
function replace_and_remember_material_str.replace_and_remember_material(t, id)
    t.material_changed = false
    t.material_reset = false
    t.all_materials_reset = false
    t.out = false
    
    -- start by making sure the id is blank.
    local id = nil
    local mesh_box
    
    if t.unit_to_modify == nil then
        print ("no unit was supplied to the the change material node.")
    else
        id = stingray.Unit.id(t.unit_to_modify)
    end
    
    if t.mesh_to_modify == nil then
        print ("no mesh was supplied to the the change material node.")
    end
    
    if t.mesh_slot_name_to_modify then
        mesh_box = stingray.IdString32Box(t.mesh_slot_name_to_modify) 
    end 
    
        
    -- Create the original materials table if it does not exist already.
    local original_materials = stingray.Unit.get_data(t.unit_to_modify, "original_material") or {}
    -- set the unit data to the original materials table.
    stingray.Unit.set_data(t.unit_to_modify, "original_material", original_materials)
    

    if not original_materials[t.mesh_slot_name_to_modify] then
        original_materials[t.mesh_slot_name_to_modify] = stingray.IdString64Box(t.original_resource_id)
    end 
    
    if not stingray.Unit.has_data(t.unit_to_modify, "replace_and_remember_material_unit_id") then
        stingray.Unit.set_data(t.unit_to_modify, "replace_and_remember_material_unit_id", replace_and_remember_material_str.id_counter)
        replace_and_remember_material_str.unit_list[replace_and_remember_material_str.id_counter] = t.unit_to_modify
        replace_and_remember_material_str.id_counter = replace_and_remember_material_str.id_counter + 1
        
    end

    
    
    -- change the material
    stingray.Unit.set_material(t.unit_to_modify, t.mesh_slot_name_to_modify, t.material_to_apply)
    
    t.material_changed = true
    t.out = true
    return t
end

-- resets the material of the current selection
function replace_and_remember_material_str.reset_material(t, id)
    t.material_changed = false
    t.material_reset = false
    t.all_materials_reset = false
    t.out = false
    
    local original_materials = stingray.Unit.get_data(t.unit_to_modify, "original_material")
    local material = original_materials[t.mesh_slot_name_to_modify]
    
    stingray.Unit.set_material(t.unit_to_modify, t.mesh_slot_name_to_modify, stingray.IdString64Box.unbox(material))
    
    t.material_reset = true
    t.out = true
    
    return t
end

-- reseta all materials ever effected
function replace_and_remember_material_str.reset_all_materials(t, id)
    t.material_changed = false
    t.material_reset = false
    t.all_materials_reset = false
    t.out = false
    
    for unit_id, unit in pairs(replace_and_remember_material_str.unit_list) do
        -- i = unit id, u = the unit
        local original_materials = stingray.Unit.get_data(unit, "original_material")
            for slot_name, original_material in pairs(original_materials) do
                stingray.Unit.set_material(unit, slot_name, stingray.IdString64Box.unbox(original_material))
        end
    end

    t.all_materials_reset = true
    t.out = true
    return t
end
    
