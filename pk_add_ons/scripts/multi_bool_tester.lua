-- Written by Paul Kind 2017

multi_bool_test = multi_bool_test or {}

function multi_bool_test.check_passed(t)
	 if t.bool_1_in ~= nil and t.bool_1_in ~= t.bool_1_rule then
    	t.passed_test = false
    	t.common_out = true
    	return t
    end


    if t.bool_2_in ~= nil and t.bool_2_in ~= t.bool_2_rule then
    	t.passed_test = false
    	t.common_out = true
    	return t
    end

    if t.bool_3_in ~= nil and t.bool_3_in ~= t.bool_3_rule then
    	t.passed_test = false
    	t.common_out = true
    	return t
    end

    if t.bool_4_in ~= nil and t.bool_4_in ~= t.bool_4_rule then
    	t.passed_test = false
    	t.common_out = true
    	return t
    end

    if t.bool_5_in ~= nil and t.bool_5_in ~= t.bool_5_rule then
    	t.passed_test = false
    	t.common_out = true
    	return t
    end

    if t.bool_6_in ~= nil and t.bool_6_in ~= t.bool_6_rule then
    	t.passed_test = false
    	t.common_out = true
    	return t
    end

    if t.bool_7_in ~= nil and t.bool_7_in ~= t.bool_7_rule then
    	t.passed_test = false
    	t.common_out = true
    	return t
    end

    if t.bool_8_in ~= nil and t.bool_8_in ~= t.bool_8_rule then
    	t.passed_test = false
    	t.common_out = true
    	return t
    end

    t.passed_test = true
    t.common_out = true
    return t
end
