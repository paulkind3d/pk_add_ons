color_to_percent = color_to_percent or {}
-- color to percent
function color_to_percent.get_color_from_vector(t)
    t.color[1] = t.color[1]/255
    t.color[2] = t.color[2]/255
    t.color[3] = t.color[3]/255

    t.percent = t.color
    return t
end
