function pk_math.super_sum(t)
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