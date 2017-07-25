-- System Time by Paul Kind 2017

function pk_world.get_system_time(t)
    -- get the system time.
    local pk_time = os.time()
    -- convert to a useful format.
    local nice_date = (os.date("*t", pk_time))
    
    -- extract the time to useful (numeric) outputs.
    t.current_day = nice_date.day
    t.current_month = nice_date.month
    t.current_minute = nice_date.min
    t.current_second = nice_date.sec
    t.current_year = nice_date.year
    t.current_hour = nice_date.hour
    
    -- Check to see if we need to adjust for 12 or 24 hour output.
    if t.twelve_hour_notation == true then
        if t.current_hour > 12 then
            t.current_hour = t.current_hour - 12
        end
    end

    -- check to see if AM or PM
    if t.current_hour < 12 then
        t.meridiem = "AM"
    else
        t.meridiem = "PM"
    end

    -- convert outputs and make convenient strings available.
    t.current_day_str = tostring(t.current_day)
    t.current_month_str = tostring(t.current_month)
    t.current_minute_str = tostring(t.current_minute)
    t.current_second_str = tostring(t.current_second)
    t.current_year_str = tostring(t.current_year)
    t.current_hour_str = tostring(t.current_hour)
    return t
end