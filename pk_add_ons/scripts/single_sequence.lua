single_sequence = single_sequence or {}
single_sequence.sequence_counter = {}
single_sequence.counter_stop = {}

function single_sequence.fire_sequence(t, id)
    
        single_sequence.sequence_counter[id] = single_sequence.sequence_counter[id] or 1
        single_sequence.counter_stop[id] = single_sequence.counter_stop[id] or 1
        
        if t.sequence_used > 10 then
            t.sequence_used = 10
        end
        
        t.sequence_number = single_sequence.sequence_counter[id]
        
        if single_sequence.sequence_counter[id] < t.sequence_used then
            single_sequence.sequence_counter[id] = single_sequence.sequence_counter[id] + 1
            t["out"..t.sequence_number] = true
            t.common_out = true
        else
            if t.loop_and_repeat == true then
                single_sequence.sequence_counter[id] = 1
                t["out"..t.sequence_number] = true
                t.common_out = true
            else
                if single_sequence.counter_stop[id] == true then
                    t.sequence_complete = true
                    t.common_out = true
                    single_sequence.sequence_counter[id] = single_sequence.sequence_counter[id] + 1
                else
                    single_sequence.sequence_counter[id] = single_sequence.sequence_counter[id] + 1
                    t["out"..t.sequence_number] = true
                    t.common_out = true
                    single_sequence.counter_stop[id] = true
                end
                
            end
        end
        
        return t
end