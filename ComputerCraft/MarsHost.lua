--[[ Thanks for downloading the Minecraft Advanced Remote Security system(MARS v1.0) ***Host***
Please remember this is the intellectual property 
of AirsoftingFox. Please do not redistribute as your own.
Enjoy, and if you have any questions leave a YouTube comment ]]

--[[current features programed:
More secure handshake (use senderID instead[fail-safe to this, only ignore if it's not the correct pass]),
secure wireless connection, multiple user created keycards(up to 8,888,887 only 44mb), user-friendly 
(checks for modems and it doesn't matter which side), ability to add usernames to keycards,
fail-safes, anti-brute force attack, password protected interface for both computers,
password isn't programed into the code, auto-startup friendly, hack-proof the wait time,
keycards have a unique 7 digit pass and ID (protects user created pass),
safe from server resets, anti-broadcast attacks, remove keycards from list,
stored login history (see attempted passwords and the computer that send them),
password is stored on the host computer and NOT the client computer ]]

storedpass = "?" -- password cannot be the following: interface, client's ID, the host's ID, chirp, or ???
clientID = nil
LogData = {} --This array is to store the log data before saving it
LogCount = 0 --global variable

local function clear() --This function is used to clear the terminal
	term.clear()
	term.setCursorPos(1,1)
	print [[
Minecraft Advanced Remote System v1.0 - Host
MARS System Online
	
	]]
end

local function instructions()
	term.setCursorPos(1, 13)
	print [[Insert a blank disk to create a new keycard
Press "R" to remove a keycard from the system
Press "L" to activate lockdown
Press "U" to deactivate lockdown
Press "T" to exit the program ]]
end

local function input(xInitial, yInitial, IsPass) --This function was created in place of the read() command
	local event, param1, text = nil
	while true do
		event, param1 = os.pullEventRaw()
		term.setCursorPos(xInitial, yInitial)
		if event == "char" then
			if not text then
				text = param1
			else
				text = (text..param1)
			end
			if IsPass then
				for i=1,string.len(text) do
					print("*")
					term.setCursorPos(xInitial + i, yInitial)
				end
			else
				print(text)
			end
			term.setCursorPos(xInitial, yInitial)
		elseif event == "key" and param1 == 28 and text ~= nil then
			return(text)
		elseif event == "key" and param1 == 14 and text ~= nil then
			text = string.sub(text, 1, string.len(text) - 1)
			term.setCursorPos(xInitial + string.len(text), yInitial)
			print(" ")
		end
	end
end

local function ModemOn() --This function checks all sides of the computer for a modem and then turns it on
	local list = redstone.getSides()
	for i=1,6 do
		if peripheral.getType(list[i]) == "modem" then
		rednet.open(list[i])
		return true
		end
	end
	return false
end

local function new(NewPass) --This file will be used to create a new password file or pull the existing one for comparison 
	if not fs.exists("/userconfig") then 
		fs.makeDir("/userconfig")
	end
	if fs.exists("/userconfig/Access") then
		local file = fs.open("/userconfig/Access","r")
		NewPass = file.readLine()
		file.close()
		return(NewPass)
	else
		local file = fs.open("/userconfig/Access","w") --creates the "Access" file if one does not exist
		file.writeLine(NewPass)
		file.writeLine("unlock")
		file.close()
	end
end

local function newClient() --this function checks to see if a relationship between the host and client computers has been made
	local message = nil
	if fs.exists("/userconfig/Client") then
		local file = fs.open("/userconfig/Client","r")
		clientID = file.readLine()
		--distance = file.readLine() might use this code to increase wireless security in a MARS patch
		file.close()
		return
	else
		local file = fs.open("/userconfig/Client","w") --creates the "Client" file if one does not exist
		while message ~= "chirp" do
			clientID, message, distance = rednet.receive()
		end
		file.writeLine(clientID)
		file.writeLine(distance)
		file.close()
		rednet.send(clientID, tostring(clientID))
		clear()
		print("Connecting with computer: ",clientID)
		sleep(5)
		return
	end
end

local function interface() --This function is used to exit the program if the correct pass is entered
	local x, y = nil
	local InterfacePass = "???"
	clear()
	print("To perform this function you must enter your password: ")
	x, y = term.getCursorPos()
	InterfacePass = input(x, y, true) 
	if InterfacePass == storedpass then
		return(true)
	else
		return(false)
	end
end

local function keycard()
	local keycardNew, keycardFS, keycardID, keycardName a = nil
	local FileListHD = fs.list("/userconfig/") --This creates a table of all of the files in the userconfig folder
	local FileListDisk = fs.list("disk/") --This creates a table of all of the files on the disk. 
	
	for _, file in ipairs(FileListDisk) do --this finds the file stored on the keycard and then saves it to keycardID
		keycardID = tostring(file)
	end
	for _, file in ipairs(FileListHD) do --once keycardID has the disk's ID it can compare it to the stored files in the userconfig
		if keycardID == tostring(file) then
			clear()
			print("This keycard ID already exists")
			print("Would you like to delete it? [N/Y]")
			while true do
				a = read()
				if a == "N" or a == "n" then
					print("Please remove floppy disk from drive")
					sleep(3)
					clear()
					return
				elseif a == "Y" or a == "y" then --Still need to test these feature
					clear()
					print("Removing keycard from system")
					fs.delete("/userconfig/"..keycardID)
					print("Complete")
					print(" ")
					print("Please remove floppy disk from drive")
					sleep(4)
					clear()
					return
				end
			end
		end
	end 
	clear()
	print("Would you like to create a new keycard? [N/Y]")
	while true do
		a = read()
		if a == "N" or a == "n" then
			print("Please remove floppy disk from drive")
			sleep(3)
			clear()
			return
		elseif a == "Y" or a == "y" then
			clear()
			print("What's the Username for this keycard")
			keycardName = tostring(read())
			keycardNew = math.abs(math.random(1111111, 9999999))
			keycardFS = fs.open("disk/"..tostring(keycardNew), "w")
			keycardFS.close()
			keycardFS = fs.open("/userconfig/"..tostring(keycardNew), "w")
			keycardFS.writeLine(keycardName)
			keycardFS.close()
			clear()
			print("Keycard "..keycardNew.." for "..keycardName.." was created successfully")
			print(" ")
			print("Please remove keycard from drive")
			sleep(4)
			clear()
			return
		end
	end	
end

local function resetSafe(SaveState)
	local State = nil
	local file = fs.open("/userconfig/Access","r")
	if not SaveState then
		State = file.readLine()
		State = file.readLine()
		file.close()
		return(State)
	else
		State = file.readLine()
		file.close()
		file = fs.open("/userconfig/Access","w")
		file.writeLine(State)
		file.writeLine(SaveState)
		file.close()
		return(true)
	end
end

local function removeKeycard() --this function removes user created keycards from the system
	local FileListHD = fs.list("/userconfig/")
	local event, param1, message, Username, file = nil
	local count = 1
	local countTotal = 1
	local page = 1
	local x = 2
	local y = 4
	local Keycards = {}
	for _, file in ipairs(FileListHD) do 
		Keycards[countTotal] = file
		countTotal = countTotal + 1
	end
	countTotal = countTotal - 3
	while true do
		clear()
		x = 2
		y = 4
		term.setCursorPos(1,2)
		print("                   ")
		term.setCursorPos(1,2)
		print("Remove Keycard             'B' - Back")
		term.setCursorPos(3,17)
		print("<--- Previous Page            Next Page --->")
		while Keycards[count] ~= "Access" do
				if count~=countTotal and count~=(page*6)+1 then
					term.setCursorPos(x, y)
					file = fs.open("/userconfig/"..Keycards[count],"r")
					Username = file.readLine()
					print(count..": "..Username.." ID: "..Keycards[count])
					file.close()
					y = y + 2
				else
					--count = count - 1
					break
				end
			count = count + 1
		end
		
		while true do
			event, param1, message = os.pullEventRaw() --this is checking to see if a keycard is inserted or if the command to lockdown is given
			if event == "key" then
				if param1 == 205 and countTotal>page*6 then --right arrow key
					page = page + 1
					break
				elseif param1 == 203 and page>1 then --left arrow key
					page = page - 1
					count = ((page-1)*6)+1
					break
				elseif param1 == 48 then --return back to menu
					clear()
					instructions()
					return
				elseif param1 == 2 then --keypress number 1
					count = 1 + (6 * (page - 1))
					if Keycards[count] and Keycards[count]~="Access" and Keycards[count]~="Client" and Keycards[count]~="logs" then
						fs.delete("/userconfig/"..Keycards[count])
						return
					else
						count = 1
						page = 1
					end
				elseif param1 == 3 then --keypress number 2
					count = 2 + (6 * (page - 1))
					if Keycards[count] and Keycards[count]~="Access" and Keycards[count]~="Client" and Keycards[count]~="logs" then
						fs.delete("/userconfig/"..Keycards[count])
						return
					else
						count = 1
						page = 1
					end
				elseif param1 == 4 then --keypress number 3
					count = 3 + (6 * (page - 1))
					if Keycards[count] and Keycards[count]~="Access" and Keycards[count]~="Client" and Keycards[count]~="logs" then
						fs.delete("/userconfig/"..Keycards[count])
						return
					else
						count = 1
						page = 1
					end
				elseif param1 == 5 then --keypress number 4
					count = 4 + (6 * (page - 1))
					if Keycards[count] and Keycards[count]~="Access" and Keycards[count]~="Client" and Keycards[count]~="logs" then
						fs.delete("/userconfig/"..Keycards[count])
						return
					else
						count = 1
						page = 1
					end
				elseif param1 == 6 then --keypress number 5
					count = 5 + (6 * (page - 1))
					if Keycards[count] and Keycards[count]~="Access" and Keycards[count]~="Client" and Keycards[count]~="logs" then
						fs.delete("/userconfig/"..Keycards[count])
						return
					else
						count = 1
						page = 1
					end
				elseif param1 == 7 then --keypress number 6
					count = 6 + (6 * (page - 1))
					if Keycards[count] and Keycards[count]~="Access" and Keycards[count]~="Client" and Keycards[count]~="logs" then
						fs.delete("/userconfig/"..Keycards[count])
						return
					else
						count = 1
						page = 1
					end
				end
			end
		end
	end
end

local function logs() --This function will check for a "log" file if one exists then it will save log information
	local line = 1 --This variable is used to store each line in the "logs" file
	local LogString = nil
	if not fs.exists("/userconfig") then 
		fs.makeDir("/userconfig")
	end
	if fs.exists("/userconfig/logs") then
		local file = fs.open("/userconfig/logs","r")
		line = file.readLine()
		while line do
			if LogString then
				LogString = LogString..line.."\n"
			else
				LogString = line.."\n"
			end
			line = file.readLine()
		end
		file.close()
	else
		local file = fs.open("/userconfig/logs","w") --creates the "logs" file if one does not exist
		file.write("Security System Log File") --had to place some text in the log file after creating it or it would provide a nil error
		file.close()
		local file = fs.open("/userconfig/logs","r")
		line = file.readLine()
		if LogString then
			LogString = LogString..line.."\n"
		else
			LogString = line.."\n"
		end
		file.close()
	end
	file = fs.open("/userconfig/logs","w")
	LogString = LogString..textutils.serialize(LogData) --converting all of the array's variables into a single string
	file.write(LogString)
	file.close()
end


--Main
local side = ModemOn()
local event, param1, hacker = nil
local message = "???"
local tries = 5
local length = 0
clear()
if side=="false" then
	print("There's no modem attached to the computer. Please attach a modem before running this program.")
	print("Press any key to reboot")
	event = os.pullEvent("char")
	os.reboot()
end

if fs.exists("/userconfig/Access") then
	storedpass = new()
else
	while string.len(storedpass)<5 do
		clear()
		print [[
	
No Password Detected
Password must be between 5 and 15 characters

Please enter a new password: ]]
		storedpass = read()
		if storedpass == "interface" or storedpass == "chirp" then
			print("Sorry but your password cannot be "..storedpass)
			sleep(3)
			storedpass = "?"
		end
	end
	new(storedpass)
end
if fs.exists("/userconfig/Client") then
	newClient()
else
	clear()
	print [[
	
No Client Computer Detected

Please boot the client computer now ]]
	newClient()
end
clear()
if resetSafe() == "unlock" then --This checks to see if there was a server reset, if there was then it will reactivate the system
	redstone.setOutput("back",false)
else
	redstone.setOutput("back",true)
end
instructions()
while true do
	event, param1, message = os.pullEventRaw() --this is checking to see if a keycard is inserted or if the command to lockdown is given
	if event == "disk" then
		if interface() then
			clear()
			keycard()
		end
		clear()
		instructions()
	elseif event == "char" then
		if tostring(param1) == "r" then
			if interface() then
				clear()
				removeKeycard()
			end
			clear()
			instructions()
		elseif tostring(param1) == "l" then
			redstone.setOutput("back",true)
			resetSafe("lock")
		elseif tostring(param1) == "u" then
			if interface() then
				redstone.setOutput("back",false)
				rednet.send(tonumber(clientID), "open")
				resetSafe("unlock")
			end
			clear()
			instructions()
		elseif tostring(param1) == "t" then
			if interface() then
				lua()
			else 
				clear()
				instructions()
			end
		end
	elseif event == "rednet_message" then
		if message == "lockdown" and tostring(param1) == tostring(clientID) then 
			redstone.setOutput("back",true)
			resetSafe("lock")
		elseif message == storedpass or fs.exists("/userconfig/"..tostring(message)) and tostring(param1) ~= tostring(hacker) then --Powerdown the home security if the sent pass is correct
			redstone.setOutput("back",false)
			rednet.send(param1, "open")
			logs()
			resetSafe("unlock")
			os.reboot()
		elseif message == "chirp" and tostring(param1) == tostring(clientID) then --this elseif makes sure the "chirp" is from the correct computer
			rednet.send(param1, tostring(clientID))
			clear()
			instructions()			
			LogCount = LogCount + 1
			LogData[LogCount] = "Computer: "..param1 --This is storing the client computer's ID in the LogData array
		elseif tostring(param1) == tostring(clientID) and message == "interface" then
			length = tonumber(string.len(storedpass)) - 2
			rednet.send(tonumber(clientID),string.sub(storedpass, length, string.len(storedpass)))
		elseif tostring(param1) == tostring(clientID) or not fs.exists("/userconfig/"..message) and message ~= storedpass then
			rednet.send(param1, "close") --sent password did not match the stored pass
			if LogCount <= 9 then
				LogCount = LogCount + 1
				LogData[LogCount] = message --This is storing the incorrect passwords into the LogData array
			end
		elseif tostring(param1) ~= tostring(clientID) and message ~= storedpass then
			hacker = param1
		end
	end
end
