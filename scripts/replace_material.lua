replace_material = replace_material or {}
-- Swap Materials
function replace_material.change_material(t)
    if t.unit and t.slot and t.material then
        stingray.Unit.set_material(t.unit, t.slot, t.material)
    end
    return t
end