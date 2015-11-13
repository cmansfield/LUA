--[[ Made by Olympus Computing ]]--
--[[ Made by AirsoftingFox. Please do not redistribute as your own ]]

version = "v0.5"
menuStart = 7
waitTime = 6
storedName = ""
port = 0

local function ModemOn()
	local list = redstone.getSides()
	for i=1,6 do
		if peripheral.getType(list[i]) == "modem" then
		rednet.open(list[i])
		return true
		end
	end
	return false
end

local function header ()
	term.clear()
	term.setCursorPos(1,1)
	print("==================================================")
	term.setCursorPos(1,2)
	print("--------------------]Olympus[---------------------")
	term.setCursorPos(1,3)
	print("==================================================")
end

local function returnInstructions()
	term.clear()
	header()
	term.setCursorPos(9,5)
	print("Press ? to return to the main menu")
end

function MainMenu()
  term.setCursorPos(3, menuStart)
  print("> Internet Browser")
  term.setCursorPos(3, menuStart + 1)
  print("  Purchase Programs over the net")
  term.setCursorPos(3, menuStart + 2)
  print("  Check for updates")
  term.setCursorPos(3, menuStart + 3)
  print("  Upload your own website")  
  term.setCursorPos(3, menuStart + 4)
  print("  Cloud Storage")  
  term.setCursorPos(3, menuStart + 5)
  print("  Uninstall")  
  term.setCursorPos(3, menuStart + 6)
  print("  Exit ccWireless")  
end

local function mainReset ()
	term.clear()
	header()
	MainMenu()
end

local function findPort ()
	local packet
	local file
	local bLinked = false
	local key = os.getComputerID()
	
	if not fs.exists("/userconfig") then 
		fs.makeDir("/userconfig")
	end
	
	packet = "ping"
	rednet.broadcast(packet)
	
	sender, data, dis = rednet.receive(waitTime)
	if data == tostring(bit.bxor(string.byte(packet,1), key)) then
		port = sender
	end
	
	if fs.exists("/userconfig/client") then
		local file = fs.open("/userconfig/client","w")
		file.writeLine(name)
		file.writeLine(port)
		file.close()
	end
	
	return
end

local function newName(name)
	if not fs.exists("/userconfig") then 
		fs.makeDir("/userconfig")
	end
	if fs.exists("/userconfig/client") then
		local file = fs.open("/userconfig/client","r")
		name = file.readLine()
		port = tonumber(file.readLine())
		file.close()
		return(name)
	else
		local file = fs.open("/userconfig/client","w")
		file.writeLine(name)
		file.writeLine(port)
		file.close()
		findPort()
	end
end

local function fileList (dataType)
	local list = {}
	local keyboardCursor = 1
	local FileList = fs.list("/")
	local message = ""
	local compID = os.getComputerID()
	
	for _, file in ipairs(FileList) do 
		table.insert(list,file)
	end
	
	returnInstructions()
	
	while true do
		for i=1,#list do
			term.setCursorPos(3, menuStart + i)
			print("  "..list[i])
		end
		term.setCursorPos(3, menuStart + keyboardCursor)
		print(">")
		
		local event, button, X, Y = os.pullEvent("key")
	
		if event == "key" then
			if button == 200 and keyboardCursor ~= 1 then --up
				term.setCursorPos(3 , menuStart + keyboardCursor)
				print(" ")
				term.setCursorPos(3, (menuStart - 1) + keyboardCursor)
				print(">")
				keyboardCursor = keyboardCursor - 1
			elseif button == 208 and keyboardCursor ~= #list then --down
				term.setCursorPos(3 , menuStart + keyboardCursor)
				print(" ")
				term.setCursorPos(3, (menuStart + 1) + keyboardCursor)
				print(">")
				keyboardCursor = keyboardCursor + 1
			elseif button == 28 then --enter
				if list[keyboardCursor] == "rom" or list[keyboardCursor] == "temp" or list[keyboardCursor] == "userconfig" then
					term.clear()
					header()
					term.setCursorPos(9,6)
					print("Sorry but you cannot "..dataType.." that")
					message = read()
					return "53"
				else
					return list[keyboardCursor]
				end
			elseif button == 53 then -- user pressed ?, return to the main menu
				return "53"
			end
		else
			returnInstructions()
		end
	end
	return 
end

local function browser ()
	local dataType = "page"
	local compID = os.getComputerID()
	local packet = ""
	local url = ""
	local cont = ""
	local key = 0

	while true do
		url = ""
		term.clear()
		header()
		term.setCursorPos(1,16)
		print("Type 'list' to display all websites")
		term.setCursorPos(1,17)
		print("Type 'back' to leave the browser")
		term.setCursorPos(1,7)
		write("Enter Page URL: ")
		url = read()
		if url == "list" then
			dataType = "list"
			packet = dataType..","..url..",0,0,0,"..storedName..","..compID
			rednet.send(port, packet)
		elseif url == "back" then
			term.clear()
			term.setCursorPos(1,1)
			return
		else
			dataType = "page"
			packet = dataType..","..url..",0,0,0,"..storedName..","..compID
			rednet.send(port, packet)
		end
		
		sender, data, dis = rednet.receive(waitTime)
		term.clear()
		term.setCursorPos(1,1)
		if dis then
			if not fs.exists("/temp") then
				fs.makeDir("/temp")
			end
			term.setCursorPos(13,1)
			print("press enter to continue")
			term.setCursorPos(13,2)
			print("server is "..math.floor(dis).." meters away")
			term.setCursorPos(1,4)
			if url == "list" then
				print(data)
				cont = read()
			else
				if string.sub(data,0,5) ~= "Sorry" then
					local file = fs.open("/temp/"..url, "w")
					file.write(data)
					file.close()
					shell.run("/temp/"..url)
				else
					print(data)
					cont = read()
				end
			end
		else
			print("Error: could not find the server, press enter.")
			cont = read()
		end
	end
end

local function purchaseProgram ()
	local dataType = "program"
	local compID = os.getComputerID()
	local packet = ""
	local url = ""
	local message = ""
	local key = 0

	while true do
		url = ""
		term.clear()
		header()
		term.setCursorPos(1,16)
		print("Type 'list' to display all programs")
		term.setCursorPos(1,17)
		print("Type 'back' to leave the online store")
		term.setCursorPos(1,7)
		write("Enter Program Name: ")
		url = read()
		if url == "list" then
			dataType = "programlist"
			packet = dataType..","..url..",0,0,0,"..storedName..","..compID
			rednet.send(port, packet)
		elseif url == "back" then
			term.clear()
			term.setCursorPos(1,1)
			return
		else
			dataType = "program"
			packet = dataType..","..url..",0,0,0,"..storedName..","..compID
			rednet.send(port, packet)
		end
		
		sender, data, dis = rednet.receive(waitTime)
		term.clear()
		term.setCursorPos(1,1)
		if dis then
			term.setCursorPos(3,1)
			print("Online Store: Available programs for download")
			term.setCursorPos(13,2)
			print("press enter to continue")
			term.setCursorPos(1,4)
			if url == "list" then
				print(data)
				message = read()
			else
				if string.sub(data,0,5) ~= "Sorry" then
					local file = fs.open("/"..url, "w")
					term.clear()
					header()
					term.setCursorPos(4,6)
					if file then
						file.write(data)
						file.close()
						print("Program "..url.." was successfully installed")
						message = read()
					else
						print("Error: Could not install "..url)
						message = read()
					end	
				else
					print(data)
					message = read()
				end
			end
		else
			print("Error: could not find the server, press enter.")
			message = read()
		end
	end
	return
end

local function checkForUpdate ()
	local dataType = "update"
	local compID = os.getComputerID()
	local packet = ""
	local url = version
	local cont = ""
	local key = 0
	local file

	term.clear()
	header()
	term.setCursorPos(9,7)
	print("Checking for updates now")
	
	packet = dataType..","..url..",0,0,0,"..storedName..","..compID
	rednet.send(port, packet)

	
	sender, data, dis = rednet.receive(waitTime)
	term.clear()
	term.setCursorPos(13,1)
	if dis then
		print("press enter to continue")
		term.setCursorPos(5,4)

		if string.sub(data,0,5) == "Looks" then
			print(data)
			cont = read()
		else
			term.setCursorPos(13,4)
			print("Installing new Updates")
			file = fs.open("/startup", "w")
			file.write(data)
			file.close()
			os.reboot()
		end
	else
		print("Error: could not find the server")
		print("Press enter to return")
		cont = read()
	end
	return
end

local function submit ()
	local selectedFile = ""
	local message = ""
	local dataType = "submit"
	local compID = os.getComputerID()
	local packet = ""
	local data = ""
	local url = ""
	local file
	
	returnInstructions()
	term.setCursorPos(6,6)
	print("Select a program to submit to the server")
	selectedFile = fileList(dataType)
	if selectedFile == "53" then
		return
	end
	
	file = fs.open("/"..selectedFile, "r")
	data = file.readAll()
	file.close()
	url = selectedFile
	packet = dataType..","..url..",0,0,0,"..storedName..","..compID.."\n"..data

	rednet.send(port, packet)

	sender, data, dis = rednet.receive(waitTime)
	term.clear()
	term.setCursorPos(13,1)
	if dis then
		print("press enter to continue")
		term.setCursorPos(1,4)

		print(data)
		message = read()

	else
		print("Error: could not find the server")
		print("Press enter to return")
		message = read()
	end
	return
end

local function fileListFromString(data)
	local list = {}
	local keyboardCursor = 1
	local message = ""
	local compID = os.getComputerID()
	local iStart = 0
	local iIndex = 0
	
	while iStart < string.len(data) do
		iIndex = string.find(data, "\n", iStart)
		if iIndex == nil then
			table.insert(list, string.sub(data,iStart,string.len(data)))
			break
		end
		table.insert(list, string.sub(data,iStart,iIndex-1))
		iStart = iIndex + 1
	end
	
	returnInstructions()
	
	while true do
		for i=1,#list do
			term.setCursorPos(3, menuStart + i)
			print("  "..list[i])
		end
		term.setCursorPos(3, menuStart + keyboardCursor)
		print(">")
		
		local event, button, X, Y = os.pullEvent("key")
	
		if event == "key" then
			if button == 200 and keyboardCursor ~= 1 then --up
				term.setCursorPos(3 , menuStart + keyboardCursor)
				print(" ")
				term.setCursorPos(3, (menuStart - 1) + keyboardCursor)
				print(">")
				keyboardCursor = keyboardCursor - 1
			elseif button == 208 and keyboardCursor ~= #list then --down
				term.setCursorPos(3 , menuStart + keyboardCursor)
				print(" ")
				term.setCursorPos(3, (menuStart + 1) + keyboardCursor)
				print(">")
				keyboardCursor = keyboardCursor + 1
			elseif button == 28 then --enter
				if list[keyboardCursor] == "rom" or list[keyboardCursor] == "temp" or list[keyboardCursor] == "userconfig" then
					term.clear()
					header()
					term.setCursorPos(9,6)
					print("Sorry but you cannot "..dataType.." that")
					message = read()
					return "53"
				else
					return list[keyboardCursor]
				end
			elseif button == 53 then -- user pressed ?, return to the main menu
				return "53"
			end
		else
			returnInstructions()
		end
	end
	return 
end

local function cloudStorage ()
	local keyboardCursor = 0
	local message = ""
	local selectedFile = ""
	local dataType = "store"
	local compID = os.getComputerID()
	local packet = ""
	local data = ""
	local user = ""
	local url = ""
	local key = ""
	local file

	term.clear()
	header()
	term.setCursorPos(6,5)
	print("Send or retrieve data from the cloud?")
	term.setCursorPos(3, menuStart)
	print("> Send")
	term.setCursorPos(3, menuStart + 1)
	print("  Retrieve")
	term.setCursorPos(3, menuStart + 2)
	print("  Return to main menu")
	
	while true do
		local event, button = os.pullEvent("key")
		
		if event == "key" then
			if button == 200 and keyboardCursor ~= 0 then --up
				term.setCursorPos(3 , menuStart + keyboardCursor)
				print(" ")
				term.setCursorPos(3, (menuStart - 1) + keyboardCursor)
				print(">")
				keyboardCursor = keyboardCursor - 1
			elseif button == 208 and keyboardCursor ~= 2 then --down
				term.setCursorPos(3 , menuStart + keyboardCursor)
				print(" ")
				term.setCursorPos(3, (menuStart + 1) + keyboardCursor)
				print(">")
				keyboardCursor = keyboardCursor + 1
			elseif button == 28 then --enter
				if keyboardCursor == 0 then
					-- Send data
					selectedFile = fileList(dataType)
					if selectedFile == "53" then
						return
					end
					term.clear()
					header()
					term.setCursorPos(2,5)
					print("Please enter a new password to secure this file")
					term.setCursorPos(6,8)
					print("Username: "..storedName)
					term.setCursorPos(6,9)
					write("Password: ")
					key = read("*")
					file = fs.open("/"..selectedFile, "r")
					data = file.readAll()
					file.close()
					url = selectedFile
					packet = dataType..","..url..",0,"..key..",0,"..storedName..","..compID.."\n"..data

					rednet.send(port, packet)

					sender, data, dis = rednet.receive(waitTime)
					term.clear()
					term.setCursorPos(1,1)
					if dis then
						term.setCursorPos(13,1)
						print("press enter to continue")
						term.setCursorPos(13,2)
						print("server is "..math.floor(dis).." meters away")
						term.setCursorPos(1,4)
						print(data)
						message = read()
					else
						print("Error: could not find the server, press enter.")
						message = read()
					end
					return
				elseif keyboardCursor == 1 then
					-- retrieve data
					dataType = "retrieve"
					term.clear()
					header()
					term.setCursorPos(2,5)
					print("Please enter the username for your cloud storage")
					term.setCursorPos(6,8)
					write("Username: ")
					user = read()
					packet = dataType..",0,0,"..user..",0,"..storedName..","..compID
					
					rednet.send(port, packet)

					sender, data, dis = rednet.receive(waitTime)
					term.clear()
					header()
					term.setCursorPos(4,6)
					if string.find(data,"Error") == 1 then
						print(data)
						message = read()
						return
					end
					
					if dis then
						term.setCursorPos(6,6)
						print("Select a file to download from the cloud")
						selectedFile = fileListFromString(data)
						if selectedFile == "53" then
							return
						end

						dataType = "retrievefile"
						term.clear()
						header()
						term.setCursorPos(2,5)
						print("Please enter the password for file "..selectedFile)
						term.setCursorPos(6,8)
						write("Password: ")
						key = read("*")
						packet = dataType..","..selectedFile..","..user..","..key..",0,"..storedName..","..compID
						
						rednet.send(port, packet)

						sender, data, dis = rednet.receive(waitTime)

						term.clear()
						header()
						term.setCursorPos(4,6)
						
						if data == nil then
							return
						end
						
						if string.find(data,"Error") == 1 then
							print(data)
							message = read()
							return
						end
						
						local file = fs.open("/"..selectedFile, "w")
						
						if file then
							file.write(data)
							file.close()
							print("Program "..selectedFile.." was successfully installed")
							message = read()
						else
							print("Error: Could not install "..selectedFile)
							message = read()
						end	
					else
						term.setCursorPos(6,6)
						print("Error: could not find the server, press enter.")
						message = read()
					end
					return
				elseif keyboardCursor == 2 then
					-- exit the menu
					return
				end
			end
		end
	end
end

local function uninstall (program)
	fs.delete("/"..program)
	return
end

local function uninstallMenu ()
	local dataType = "delete"

	returnInstructions()
	term.setCursorPos(6,6)
	print("Select a program to delete")
	selectedFile = fileList(dataType)
	if selectedFile == "53" then
		return
	end

	uninstall (selectedFile)
	return
end








-- Main
local keyboardCursor = 0
local text = nil

if not ModemOn() then
	print("There's no modem attached to the computer. Please attach a modem before running this program.")
	text = read()
	os.reboot()
end

if fs.exists("/userconfig/client") then
	storedName = newName()
else
	while string.len(storedName)<2 do
		term.clear()
		header()
		term.setCursorPos(3,5)
		print("Please enter your username: ")
		print(" ")
		storedName = read() --start here
		sleep(1)
	end
	newName(storedName)
end

if port == 0 then
	term.clear()
	header()
	term.setCursorPos(3,5)
	print("Establishing network connection")
	print(" ")
	findPort ()
	print ("Error connecting to the network")
	print ("Possibly out of range?")
	return
end

mainReset ()

while true do
	local event, button = os.pullEvent("key")
	
	if event == "key" then
		if button == 200 and keyboardCursor ~= 0 then --up
			term.setCursorPos(3 , menuStart + keyboardCursor)
			print(" ")
			term.setCursorPos(3, (menuStart - 1) + keyboardCursor)
			print(">")
			keyboardCursor = keyboardCursor - 1
		elseif button == 208 and keyboardCursor ~= 6 then --down
			term.setCursorPos(3 , menuStart + keyboardCursor)
			print(" ")
			term.setCursorPos(3, (menuStart + 1) + keyboardCursor)
			print(">")
			keyboardCursor = keyboardCursor + 1
		elseif button == 28 then --enter
			if keyboardCursor == 0 then
				browser()
				keyboardCursor = 0
				mainReset ()
			elseif keyboardCursor == 1 then
				purchaseProgram ()
				keyboardCursor = 0
				mainReset ()
			elseif keyboardCursor == 2 then
				checkForUpdate ()
				keyboardCursor = 0
				mainReset ()
			elseif keyboardCursor == 3 then
				submit ()
				keyboardCursor = 0
				mainReset ()
			elseif keyboardCursor == 4 then
				cloudStorage ()
				keyboardCursor = 0
				mainReset ()
			elseif keyboardCursor == 5 then
				uninstallMenu ()
				keyboardCursor = 0
				mainReset ()
			elseif keyboardCursor == 6 then
				-- exit the program
				term.clear()
				term.setCursorPos(1,1)
				return
			end
		end
	else
		mainReset ()
	end
end





