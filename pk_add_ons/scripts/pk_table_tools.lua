pk_table_tools = pk_table_tools or {}
require 'script/lua/flow_callbacks'

pk_table_tools.unit_tables = {}
pk_table_tools.counter = {}

local function tablelength(t)
  local count = 0
  for _ in pairs(t) do 
      count = count + 1
  end
  count = count -- -1
  return count
end


-- add a unit to the table.
function pk_table_tools.create_unit_table(t)
    
    if pk_table_tools.unit_tables[t.table_name] then 
        print ("table already exists")
        return
    end
    -- create the table name\
    pk_table_tools.unit_tables[t.table_name] = {}
end

-- add a unit to the table.
function pk_table_tools.add_unit_to_table(t)
    
    if t.table_name == false then
        print ("table name not supplied in add unit to table")
        return
    end
    
    pk_table_tools.counter[t.table_name] = pk_table_tools.counter[t.table_name] or 0
    pk_table_tools.counter[t.table_name] = pk_table_tools.counter[t.table_name] + 1
    t.unit_id = pk_table_tools.counter[t.table_name]
    
    pk_table_tools.unit_tables[t.table_name][t.unit_id] = t.unit
    
    return t
end

-- get a unit in the unit table.
function pk_table_tools.get_unit_in_table(t)
    
    if t.table_name == false then
        print ("table name not supplied in get unit from table")
        return
    end
    
    if t.unit_id == false then
        print ("unit id not supplied in get unit in table")
        return
    end
    
    if pk_table_tools.unit_tables[t.table_name][t.unit_id] then
        t.unit = pk_table_tools.unit_tables[t.table_name][t.unit_id]
    else
        print ("Unit ID produces a Nil Unit")
        return
    end
    
    

    return t
end






-- get the first unit in the table
function pk_table_tools.get_first_unit_in_table(t)
    if not t.table_name then
        print ("table name not supplied in get first unit from table")
        return
    end

    local i = 0
    
    while i <= tablelength(pk_table_tools.unit_tables[t.table_name]) do
        
        if pk_table_tools.unit_tables[t.table_name][i] then
            t.unit = pk_table_tools.unit_tables[t.table_name][i]
            t.unit_id = i
            return t
        end
        
        i = i+1
    end
end


-- delete a unit from the unit table.
function pk_table_tools.delete_unit_from_table(t)
    if not t.table_name then
        print ("table name not supplied in Delete Unit from Unit Table")
        return
    end
    
    if not t.unit_id then
        print ("unit id not supplied in Delete Unit from Unit Table")
        return
    end
    
    if t.unit_id > tablelength(pk_table_tools.unit_tables[t.table_name]) then
        print ("Unit ID is our of range in Delete Unit from Unit Table")
        return
    end
    
    pk_table_tools.unit_tables[t.table_name][t.unit_id] = nil
end

function pk_table_tools.get_unit_table_length(t)
    t.table_length = tablelength(pk_table_tools.unit_tables[t.table_name])
   -- t.table_length = t.table_length - 1
    return t
end
