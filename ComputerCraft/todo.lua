--[[ Made by AirsoftingFox. Please do not redistribute as your own ]]
--max of 13 tasks


local function MonitorOn() 
	local list = redstone.getSides()
	for i=1,6 do
		if peripheral.getType(list[i]) == "monitor" then
			return (list[i])
		end
	end
	return false
end

function printDict(data) -- Dictionary printer
	local side = MonitorOn()
	local mon = peripheral.wrap(side)
	local c = 1
	mon.clear()
	
	for i,v in pairs(data) do
		mon.setCursorPos(2, c)
		mon.write(tostring(i).." - "..tostring(v))
		c = c + 1
	end
	event = os.pullEvent("char")
end	

local function instructions()
	term.clear()
	term.setCursorPos(4,9)
	print("Keyboard Commands:")
	term.setCursorPos(2,10)
	print("N - New Task      Up - Move up")
	term.setCursorPos(2,11)
	print("D - Toggle Task   Down - Move down")
	term.setCursorPos(2,12)
	print("R - Remove Task   T - Exit program")
end

local function clearall(mon)
	term.clear()
	term.setCursorPos(1,1)
	print(" ")
	--mon.clear()
	mon.setCursorPos(2,1)
	mon.write(" ")
end

local function newName(listName)
	if not fs.exists("/userconfig") then 
		fs.makeDir("/userconfig")
	end
	if fs.exists("/userconfig/ToDo") then
		local file = fs.open("/userconfig/ToDo","r")
		listName = file.readLine()
		file.close()
		return(listName)
	else
		local file = fs.open("/userconfig/ToDo","w") --creates the "ToDo" file if one does not exist
		file.writeLine(listName)
		file.close()
	end
end


local function display(mon, cursorPos)
	local listName, task, complete = nil
	local toDoList, fileArray = {}
	local newLine = " "
    local a = 0
	local i = 0
	local listCount = 0

	if fs.exists("/userconfig/ToDo") then
		fileArray = fs.open("userconfig/ToDo", "r")
		while true do
			newLine = fileArray.readLine()
			if newLine == nil then break end
			table.insert(toDoList, newLine)
			listCount = listCount + 1
		end
	else
		print("The todo file is missing")
		print("Please reboot the computer")
		lua()
	end
	fileArray.close()
	listName = toDoList[1]
	mon.clear()
	mon.setCursorPos(2,1)
	mon.write("To-Do List: "..listName)
	mon.setCursorPos(1,2)
	mon.write("=================================================================================================")
	if cursorPos > 6 then
		for i=7,listCount do
			complete = string.sub(tostring(toDoList[i]), 1, 5)
			task = string.sub(tostring(toDoList[i]), 6, tostring(string.len(toDoList[i])))
			term.setCursorPos(3,-1+(i-6))
			if complete=="done:" then
				print("[Done] "..string.sub(task,1,22))
			else
				print("[    ] "..string.sub(task,1,22))
			end
		end
	
	else
		if listCount<7 then
			for i=2,listCount do
				complete = string.sub(tostring(toDoList[i]), 1, 5)
				task = string.sub(tostring(toDoList[i]), 6, tostring(string.len(toDoList[i])))
				term.setCursorPos(3,-1+i)
				if complete=="done:" then
					print("[Done] "..string.sub(task,1,22))
				else
					print("[    ] "..string.sub(task,1,22))
				end
			end
		else
			for i=2,7 do
				complete = string.sub(tostring(toDoList[i]), 1, 5)
				task = string.sub(tostring(toDoList[i]), 6, tostring(string.len(toDoList[i])))
				term.setCursorPos(3,-1+i)
				if complete=="done:" then
					print("[Done] "..string.sub(task,1,22))
				else
					print("[    ] "..string.sub(task,1,22))
				end
			end
		end
	end
	for i=2,listCount do
		complete = string.sub(tostring(toDoList[i]), 1, 5)
		task = string.sub(tostring(toDoList[i]), 6, tostring(string.len(toDoList[i])))
		mon.setCursorPos(3,2+i)
		if complete=="done:" then
			mon.write("[Done] "..task)
		else
			mon.write("[    ] "..task)
			a = a + 1
		end
	end
	if string.len(listName)<13 then
		mon.setCursorPos(27,1)
	else
		mon.setCursorPos(56,1)
	end
	mon.write(a.." uncompleted tasks")
	if cursorPos < 7 then
		term.setCursorPos(2,cursorPos)
		print("*")
	else
		term.setCursorPos(2,cursorPos-6)
		print("*")
	end
	return(listCount)
end

local function addtask(newTask)
	local toDoList, fileArray = {}
	local newLine = " "
    local i = 0
	local listCount = 0

	if fs.exists("/userconfig/ToDo") then
		fileArray = fs.open("userconfig/ToDo", "r")
		while true do
			newLine = fileArray.readLine()
			if newLine == nil then break end
			table.insert(toDoList, newLine)
			listCount = listCount + 1
		end
	else
		print("The todo file is missing")
		print("Please reboot the computer")
		lua()
	end
	fileArray.close()
	table.insert(toDoList, "work:"..newTask)
	fileArray = fs.open("userconfig/ToDo", "w")
	for i=1,listCount+1 do
		if i<15 then
			fileArray.writeLine(toDoList[i])
		else
			term.clear()
			term.setCursorPos(1,6)
			print("Too many tasks, please remove a task first")
			event = os.pullEvent("key")
		end
	end
	fileArray.close()
	return
end

local function toggle(taskNumber)
	local toDoList, fileArray = {}
	local storage, newLine = " "
    local i = 0
	local listCount = 0

	if fs.exists("/userconfig/ToDo") then
		fileArray = fs.open("userconfig/ToDo", "r")
		while true do
			newLine = fileArray.readLine()
			if newLine == nil then break end
			if taskNumber==listCount then
				if string.sub (newLine,1,5)=="done:" then
					storage = string.sub (newLine,6,string.len(newLine))
					table.insert(toDoList, "work:"..storage)
				else
					storage = string.sub (newLine,6,string.len(newLine))
					table.insert(toDoList, "done:"..storage)
				end
			else
				table.insert(toDoList, newLine)
			end
			listCount = listCount + 1
		end
	else
		print("The todo file is missing")
		print("Please reboot the computer")
		lua()
	end
	fileArray.close()
	fileArray = fs.open("userconfig/ToDo", "w")
	for i=1,listCount do
		fileArray.writeLine(toDoList[i])
	end
	fileArray.close()
	return
end

local function removetask(taskNumber)
	local toDoList, fileArray = {}
	local storage, newLine = " "
    local i = 0
	local listCount = 0

	if taskNumber < 1 then
		taskNumber = 1
	end
	if fs.exists("/userconfig/ToDo") then
		fileArray = fs.open("userconfig/ToDo", "r")
		while true do
			newLine = fileArray.readLine()
			if newLine == nil then break end
			if taskNumber~=listCount then
				table.insert(toDoList, newLine)
			end
			listCount = listCount + 1
		end
	else
		print("The todo file is missing")
		print("Please reboot the computer")
		lua()
	end
	fileArray.close()
	fileArray = fs.open("userconfig/ToDo", "w")
	for i=1,listCount-1 do
		fileArray.writeLine(toDoList[i])
	end
	fileArray.close()
	return
end




-- main
local i = 2
local a = nil
local storedName = " "
local side = MonitorOn()
local forData = {}
local cursorPos = 1
local listCount = 0

if side==false then
	print("There's no monitor attached to the computer. Please attach a monitor before running this program.")
	print("Press any key to exit")
	event = os.pullEvent("char")
	lua()
end
local mon = peripheral.wrap(side)
mon.setTextScale(1)           --Text Size

if fs.exists("/userconfig/ToDo") then
	storedName = newName()
else
	while string.len(storedName)<2 do
		print(" ")
		print("Start your new To-do list:")
		print(" ")
		storedName = read() --start here
		sleep(1)
	end
	newName(storedName)
end
term.clear()
mon.clear()
instructions()
listCount = display(mon, cursorPos)
while true do
	event, param1, message = os.pullEvent() --this is checking to see if a keycard is inserted or if the command to lockdown is given
	if event == "char" then
		if tostring(param1) == "r" then		--remove item from the list
			if listCount> 2 then
				term.clear()
				removetask(cursorPos)
				cursorPos = cursorPos - 1
				clearall(mon)
				instructions()
				listCount = display(mon, cursorPos)
			end
		elseif tostring(param1) == "n" then	--add new item to the list
			term.clear()
			term.setCursorPos(6, 4)
			print("Enter a new task: ")
			print(" ")
			a = read()
			term.clear()
			term.setCursorPos(18-(string.len(a)/2),4)
			print(a)
			term.setCursorPos(4,6)
			print("Create this task?")
			term.setCursorPos(4,7)
			print("Enter 'Y' for yes or 'N' for no")
			while tostring(message)~="y" or tostring(message)~="n" or tostring(message)~="Y" or tostring(message)~="N"do
				message = read()
				if tostring(message)=="y" or tostring(message)=="Y" then	
					addtask(a)
					clearall(mon)
					instructions()
					listCount = display(mon, cursorPos)
					break
				else 
					clearall(mon)
					instructions()
					listCount = display(mon, cursorPos)
					break
				end
			end	
		elseif tostring(param1) == "d" then	--used to toggle a completed task	
			toggle(cursorPos)
			clearall(mon)
			instructions()
			listCount = display(mon, cursorPos)
		elseif tostring(param1) == "t" then	--exit the program
			clearall(mon)
			term.setCursorPos(4,4)
			print("Sure you would like to exit?")
			term.setCursorPos(3,5)
			print("Press 'Y' for yes or 'N' for no")
			event, param1, message = os.pullEvent()
			while tostring(param1)~="y" or tostring(param1)~="n" do
				event, param1, message = os.pullEvent()
				if tostring(param1)=="y" then	
					return
				else 
					clearall(mon)
					instructions()
					listCount = display(mon, cursorPos)
					break
				end
			end
		end
	elseif event == "key" then
		if tonumber(param1) == 200 then	--arrow up
			if cursorPos~=1 then
				cursorPos = cursorPos - 1
			end
			clearall(mon)
			instructions()
			listCount = display(mon, cursorPos)
		elseif tonumber(param1) == 208 then	--arrow down
			if cursorPos~=15 and cursorPos~=listCount-1 then
				cursorPos = cursorPos + 1
			end
			clearall(mon)
			instructions()
			listCount = display(mon, cursorPos)
		end
	end
end

