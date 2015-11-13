--[Olympus Networking Main]--
--[[ Made by AirsoftingFox. Please do not redistribute as your own ]]--

--[[ Things to work on
**Required**
Setup a serial key system for downloaded programs
Have the server restart every hour
**Extra**
E-mail system
Set up web pages with the ability to access sub pages
]]

version = "v0.5"

-- Constants
REQUEST_INDEX = 1
URL_INDEX = 2
URL2_INDEX = 3
KEY_INDEX = 4
DISTANCE_INDEX = 5
USERNAME_INDEX = 6
SENDER_ID_INDEX = 7
REQUEST_TYPES = {"page","list","program","programlist","update","submit","store","retrieve","retrievefile"}

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

local function debug (tTable)
	for i=1,#tTable do
	  print(i .. ": " .. tTable[i])
	end
end

local function getListUser (fileType, username)
	local list = ""
	local FileList
	
	FileList = fs.list("/server/"..fileType.."/"..username.."/")
	
	for _, file in ipairs(FileList) do 
		list = file.."\n"..list
	end
	return list
end

local function getList (fileType)
	local list = ""
	local FileList

	FileList = fs.list("/server/"..fileType.."/")

	for _, file in ipairs(FileList) do 
		list = file.."\n"..list
	end
	return list
end

local function logData(newLine) --This function will check for a "log" file if one exists then it will save log information
	local file
	local data = ""
	
	if not fs.exists("/server/log") then
		file = fs.open("/server/log","w")
		file.close()
	end
	
	file = fs.open("/server/log","r")
	data = file.readAll()
	file.close()
	
	if string.len(newLine) > 55 then
		newLine  = string.sub(newLine,0,55)
	end
	
	file = fs.open("/server/log","w")
	file.writeLine(newLine)
	file.write(data)
	file.close()
end

local function send (tTable, message)
	-- relay1,relay2,senderID,message
	local port =  tonumber(tTable[#tTable])
	local index = 0
	
	message = tTable[SENDER_ID_INDEX].."\n"..message
	
	for i=SENDER_ID_INDEX+1, #tTable do
		message = tTable[i]..","..message
	end

	if tostring(port) == tTable[SENDER_ID_INDEX] then
		message = string.sub(message,string.find(message,"\n")+1,string.len(message))
	else 
		if tostring(port) == string.sub(message,0,string.find(message,",")-1) then
			message = string.sub(message,string.find(message,",")+1,string.len(message))
		end
	end
	
	rednet.send(port, message)
end

local function sendData (tTable)
	local requestType = tTable[REQUEST_INDEX]
	local url = tTable[URL_INDEX]
	
	local file

	if fs.exists("/server/"..requestType.."s/"..url) then
		file = fs.open("/server/"..requestType.."s/"..url, "r")
		data = file.readAll()
		file.close()
		send(tTable, data)
	elseif fs.exists("/server/"..requestType.."/"..url) then
		file = fs.open("/server/"..requestType.."/"..url, "r")
		data = file.readAll()
		file.close()
		send(tTable, data)
	else
		send(tTable, "Sorry, couldn't find the requested "..requestType)
	end
end

local function unpackage ()
	local sender
	local sHeader = ""
	local message = ""
	local sHeaderTemp = ""
	local tTable = {}
	local iCrop = 0
	local distance = 0
	local iHeaderStart = 0
	local iHeaderIndex = 0
	
	sender, sHeader, distance = rednet.receive()

	if sHeader == "ping" then
		message = tostring(bit.bxor(string.byte(sHeader,1), sender))
		rednet.send(sender, message)
		return tTable
	end
	
	for i=1,#REQUEST_TYPES do
		if string.sub(sHeader,0,string.len(REQUEST_TYPES[i])) == REQUEST_TYPES[i] then
			sHeaderTemp = sHeader
			
			if string.find(sHeader, "\n") then
				iCrop = string.find(sHeader, "\n") - 1
				sHeaderTemp = string.sub(sHeader,0,iCrop)
			end
			
			while iHeaderStart < string.len(sHeaderTemp) do
				iHeaderIndex = string.find(sHeaderTemp, ",", iHeaderStart)
				if iHeaderIndex == nil then
					table.insert(tTable, string.sub(sHeaderTemp,iHeaderStart,string.len(sHeaderTemp)))
					break
				end
				table.insert(tTable, string.sub(sHeaderTemp,iHeaderStart,iHeaderIndex-1))
				iHeaderStart = iHeaderIndex + 1
			end
		end
	end

	return tTable, sHeader, distance
end



-- Main
local iHeaderIndex = 0
local data = ""
local url = ""
local secondary = ""
local keyPass = ""
local newLine = ""
local sHeader = ""
local username = ""
local client = 0
local distance = 0
local totalDistance = 0
local requestType = "page"
local tTable = {}
local file

if not ModemOn() then
	print("There's no modem attached to the computer. Please attach a modem before running this program.")
	url = read()
	os.reboot()
end

term.clear()
term.setCursorPos(1,1)
print("Main Server "..version.." Started")
while true do

	tTable, sHeader, distance = unpackage ()
		
	if #tTable > SENDER_ID_INDEX - 1 then 
		requestType = tTable[REQUEST_INDEX]
		url = tTable[URL_INDEX]
		totalDistance =  tonumber(tTable[DISTANCE_INDEX]) + distance
		client =  tonumber(tTable[SENDER_ID_INDEX])
		username = tTable[USERNAME_INDEX]
		secondary = tTable[URL2_INDEX]
		keyPass = tTable[KEY_INDEX]
			
		if tTable[URL_INDEX] ~= "" then
			if requestType == "page" then
				sendData (tTable)
				newLine = username.."("..client..") requested a "..requestType..": "..url.." "..totalDistance.." meters"
			elseif requestType == "list" then
				data = getList ("pages")
				send(tTable, data)
				newLine = username.."("..client..") requested a "..requestType..": "..url.." "..totalDistance.." meters"
			elseif requestType == "program" then
				sendData (tTable)
				newLine = username.."("..client..") requested a "..requestType..": "..url.." "..totalDistance.." meters"
			elseif requestType == "programlist" then
				data = getList ("programs")
				send(tTable, data)
				newLine = username.."("..client..") requested a "..requestType..": "..url.." "..totalDistance.." meters"
			elseif requestType == "update" then
				local list = ""
				local FileList = fs.list("/server/update/")
				
				for _, file in ipairs(FileList) do 
					list = file
				end

				if list ~= url  and list ~= "" then
					tTable[URL_INDEX] = list
					sendData (tTable)
				else
					send(tTable, "Looks like you have the latest version!")
				end
				newLine = username.."("..client..") requested an "..requestType..": "..url.." "..totalDistance.." meters"
			elseif requestType == "submit" then
				if string.find(sHeader, "\n") == nil then 
					send(tTable, "Error storing file")
				else
					iHeaderIndex = string.find(sHeader, "\n")
					data = string.sub(sHeader, iHeaderIndex, string.len(sHeader))
					if fs.exists("/server/"..requestType.."/"..url) then
						send(tTable, "Sorry, but that has already been submitted")
						newLine = tostring(client).." sent a submission that already exists"
					else
						file = fs.open("/server/submit/"..url, "w")
						if file then 
							file.write(data)
							file.close()
							send(tTable, "Thank you for your submission, please allow time for an admin to review")
						else
							send(tTable, "Error storing file")
						end
						newLine = username.."("..tostring(client)..") requested to "..requestType..": "..url.." "..totalDistance.." meters"
					end
				end
			elseif requestType == "store" then
				iHeaderIndex = string.find(sHeader, "\n")
				data = string.sub(sHeader, iHeaderIndex, string.len(sHeader))
				
				if not fs.exists("/server/cloud/"..username) then
					fs.makeDir("/server/cloud/"..username)
				end
				
				file = fs.open("/server/cloud/"..username.."/"..url, "w")
				if file then 
					file.writeLine(keyPass)
					file.write(data)
					file.close()
					send(tTable, "File stored on the cloud")
				else
					send(tTable, "Error storing file")
				end
				newLine = username.."("..tostring(client)..") requested to "..requestType..": "..url.." "..totalDistance.." meters"
			elseif requestType == "retrieve" then
				if fs.exists("/server/cloud/"..keyPass) then
					data = getListUser("cloud",keyPass)
					send(tTable, data)
					newLine = username.."("..client..") requested to "..requestType.." a file list from user: "..keyPass.." "..totalDistance.." meters"
				else
					send(tTable,"Error: user not found")
				end
			elseif requestType == "retrievefile" then
				if fs.exists("/server/cloud/"..secondary) then
					file = fs.open("/server/cloud/"..secondary.."/"..url,"r")
					newLine = file.readLine()
					if newLine == keyPass then
						data = file.readAll()
						send(tTable, data)
						newLine = username.."("..client..") requested to retrieve a file from user: "..secondary.." **"..url.."** "..totalDistance.." meters"
					else
						send(tTable,"Error: Incorrect password")
					end	
				else
					send(tTable,"Error: user not found")
				end
			
			
			
				
			end
			
			print(newLine)
			logData(newLine)
		else
			send(tTable, "Sorry, couldn't process your request")
		end
	end
end
