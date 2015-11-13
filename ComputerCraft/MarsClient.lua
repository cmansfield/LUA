--[[ Thanks for downloading the Minecraft Advanced Remote Security system(MARS v1.0) ***Client***
Please remember this is the intellectual property 
of AirsoftingFox. Please do not redistribute as your own.
Enjoy, and if you have any questions leave a YouTube comment ]]

hostID, CorrectDistance = nil --global variables

function clear()
	term.clear()
	term.setCursorPos(1,1)
	print [[
Minecraft Advanced Remote System v1.0 - Client

	]]
end

local function wait(seconds)
	os.startTimer(seconds)
	local time = os.pullEventRaw("timer")
end

function ModemOn() --This function checks all sides of the computer for a modem and then turns it on
	local list = redstone.getSides()
	for a=1,6 do
		if peripheral.getType(list[a]) == "modem" then
		rednet.open(list[a])
		return true
		end
	end
	return false
end

local function newHost() --this function checks to see if a relationship between the host and client computers has been made
	local message, distance, event = nil
	if not fs.exists("/userconfig") then 
		fs.makeDir("/userconfig")
	end
	if fs.exists("/userconfig/Host") then
		local file = fs.open("/userconfig/Host","r")
		hostID = file.readLine()
		distance = file.readLine()
		file.close()
		return(distance)
	else
		local file = fs.open("/userconfig/Host","w") --creates the "Host" file if one does not exist
		rednet.broadcast("chirp")
		hostID, message, distance = rednet.receive(6)
		if message ~= tostring(os.computerID()) then
			print("Error: cannot connect to host computer")
			print("1.Try placing the client computer closer")
			print("2.Check for other computer interference")
			print(" ")
			print("Press any key to shutdown")
			file.close()
			fs.delete("/userconfig")
			event = os.pullEvent("char")
			os.shutdown()
		else
			file.writeLine(hostID)
			file.writeLine(distance)
			file.close()
			clear()
			print("Connecting with host: ",hostID)
			sleep(4)
			return(distance)
		end
	end
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

local function interface()
	local InterfacePass = "?"
	local x, y = nil
	rednet.send(tonumber(hostID), "interface")
	local senderID, message, distance = rednet.receive(3)
	while string.len(InterfacePass)<3 do
	clear()
	print("To perform this function you must enter your password: ")
		x, y = term.getCursorPos()
		InterfacePass = input(x,y,true)
	end
	length = tonumber(string.len(InterfacePass)) - 2
	if string.sub(InterfacePass, length, string.len(InterfacePass)) == message and tostring(senderID) == tostring(hostID) then
		return(true)
	else
		return(false)
	end
end


--Main
local tries = 4
local i = 1 --i variable is for the while loops
local senderID, handshake, distance, password, keycardList, event, xInitial, yInitial, a, x, y = nil
local param1 = "t"
local side = ModemOn()

clear()
if side=="false" then
	print("There's no modem attached to the computer. Please attach a modem before running this program.")
	i = read()
	os.reboot()
end
CorrectDistance = newHost()
while param1 == "t" do
	print("Press Any Key to Activate Security System")
	term.setCursorPos(1, 17)
	print [[Press "T" to exit the program ]]
	event, param1 = os.pullEventRaw("char")
	if tostring(param1) == "t" or tostring(param1) == "T" then
		if interface() then
			print("Ending program")
			lua()
		else
			clear()
			print("Error: wrong password or could not connect to host")
			wait(3) 
			clear()
		end
	end
end
rednet.send(tonumber(hostID), "lockdown")
sleep(0.5)
clear()
rednet.send(tonumber(hostID), "chirp")
senderID, handshake, distance = rednet.receive(6)
if handshake == nil then --This means the host computer never responded back
	clear()
	print [[
Error, could not connect with the computer
	
Try broadcasting your password?
Warning! Broadcasting your password is a security risk. Any computers nearby could receive your password.
	
Would you like to try broadcasting your password? [N/Y]
	]]
	while true do
		xInitial, yInitial = term.getCursorPos()
		a = input(xInitial,yInitial,false)
		if a == "N" or a == "n" then
			print("Rebooting in 4 seconds...")
			wait(4)
			os.reboot()
		elseif a == "Y" or a == "y" then
			clear()
			print("Password: ")
			xInitial, yInitial = term.getCursorPos()
			password = input(xInitial,yInitial,true)
			rednet.broadcast(password)
			print("Rebooting in 4 seconds...")
			wait(4)
			os.reboot()
		end
	end
elseif handshake ~= tostring(os.computerID()) then --or senderID ~= tonumber(hostID) or distance ~= CorrectDistance then This means a different computer than the host sent a message back
	print [[
Error, interference from another computer
Rebooting in 4 seconds...
	]]
	wait(4)
	os.reboot()
end
print("Password: ")
while true do
	for trycount=1,tries,1 do
		while true do
			password = nil
			event, param1 = os.pullEventRaw() --this is checking to see if a keycard is inserted or if the password is manually typed
			if event == "disk" then
				local side = param1
				if fs.exists("disk/Access") then
					keycard = fs.open("disk/Access", "r")
					password = tostring(keycard.readLine())
					keycard.close()
				else
					if fs.exists("disk/") then
						keycardList = fs.list("disk/") --This creates a table of all of the files on the disk
						for _, file in ipairs(keycardList) do
							password = tostring(file)
						end 
					end
				end
				disk.eject(side)
				break
			elseif event == "char" then
				local FirstChar = param1
				x, y = term.getCursorPos() --because the first char of the pass is pulled by the os.pullEvent() and not read() I have to manually add the first "*"
				print("*")
				x = x + 1
				term.setCursorPos(x, y)
				password = (FirstChar..input(x,y,true))
				break
			end
		end
		rednet.send(tonumber(hostID), password) --sends the password and waits for the reply
		senderID, message, distance = rednet.receive()
		if message == "open" and senderID == tonumber(hostID) then
			clear()
			print("Access Granted")
			sleep(4)
			os.reboot()
		elseif message == "close" and senderID == tonumber(hostID) then
			clear()
			print("Access Denied")
			print("Tries Left: ",tries-trycount)
			print(" ")
			print("Password: ")
		end
		if trycount == tries then
			print [[
			Number of tries exceeded
			Computer lockout for 1 minute
			]]
			wait(60)
			clear()
			print("Password: ")
		end
	end
end