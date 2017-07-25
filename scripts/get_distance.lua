function pk_math.get_distance(t)
    t.distance = stingray.Vector3.distance(t.position_1, t.position_2)
    return t
end

