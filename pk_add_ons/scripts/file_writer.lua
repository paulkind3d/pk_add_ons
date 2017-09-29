file_writer = file_writer or {}

function file_writer.input_data(t, id)
	-- set the mode of the read writ operation.
	if t.file_path == nil then
		t.file_path = ""
	end

	local my_mode = nil

	if t.file_mode == "write_w" then
		my_mode = "w"
	end

	if t.file_mode == "append_a" then
		my_mode = "a"
	end

	if t.file_mode == "read_and_write_r+" then
		my_mode = "r+" 
	end

	if t.file_mode == "overwrite_w+" then
		my_mode = "w+"
	end
	-- set the type of the file.
	local file_type = nil

	if t.file_type == "Lua" then
		file_type = ".lua"
	end

	if t.file_type == "Text" then
		file_type = ".txt"
	end
	-- concatenate the file name and the file type
	local file_name = t.file_path .. t.file_name .. file_type


	-- create the file
	local my_file = io.open(file_name, my_mode)
	-- set the file output. 
	-- io.output(my_file)
	-- append the data to the file
	-- io.write(t.text_data)
	my_file:write(t.text_data)
	my_file:close()
	-- close the file
	-- io.close(my_file)
end


-- -- Opens a file in read
-- file = io.open("test.lua", "r")

-- -- sets the default input file as test.lua
-- io.input(file)

-- -- prints the first line of the file
-- print(io.read())

-- -- closes the open file
-- io.close(file)

-- -- Opens a file in append mode
-- file = io.open("test.lua", "a")

-- -- sets the default output file as test.lua
-- io.output(file)

-- -- appends a word test to the last line of the file
-- io.write("-- End of the test.lua file")

-- -- closes the open file
-- io.close(file)


