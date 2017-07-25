super_contatenator = super_contatenator or {}

-- super concatenator
function super_contatenator.contatenate_string(t)
   
    local concatenator = ""
    if t.concatenator then
        concatenator = t.concatenator
    end

    local prefix = ""
    if t.prefix then
        prefix = t.prefix
    end

    local message1 = ""
    if t.message1 then
        message1 = t.message1
    end
    
    local message2 = ""
    if t.message2 then
        message2 = concatenator .. t.message2
    end
    
    local message3 = ""
    if t.message3 then
        message3 = concatenator .. t.message3
    end
    
    local message4 = ""
    if t.message4 then
        message4 = concatenator .. t.message4
    end
    
    local message5 = ""
    if t.message5 then
        message5 = concatenator .. t.message5
    end
    
    local message6 = ""
    if t.message6 then
        message6 = concatenator .. t.message6
    end
    
    local message7 = ""
    if t.message7 then
        message7 = concatenator .. t.message7
    end
    
    local message8 = ""
    if t.message8 then
        message8 = concatenator .. t.message8
    end

    local suffix = ""
    if t.suffix then
        suffix = t.suffix
    end

    t.concatenated_string = prefix .. message1 .. message2 .. message3 .. message4 .. message5 .. message6 .. message7 .. message8 .. suffix
    return t
end