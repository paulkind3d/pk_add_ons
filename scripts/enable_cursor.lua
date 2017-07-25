pk_cursor = pk_cursor or {}

function pk_cursor.enable_cursor(t)
    stingray.Window.set_show_cursor(true)
end

function pk_cursor.disable_cursor(t)
    stingray.Window.set_show_cursor(false)
end

function pk_cursor.toggle_cursor(t)
    if stingray.Window.show_cursor() == true then
        stingray.Window.set_show_cursor(false)
    else
        stingray.Window.set_show_cursor(true)
    end
end
