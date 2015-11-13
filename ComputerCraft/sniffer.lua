local function logData(newLine)
	local file
	local data = ""
	
	if not fs.exists("/log") then
		file = fs.open("/log","w")
		file.close()
	end
	
	file = fs.open("/log","r")
	data = file.readAll()
	file.close()
	
	file = fs.open("/log","w")
	file.writeLine(newLine)
	file.write(data)
	file.close()
end

--Main
local data = ""
term.clear()
term.setCursorPos(1,1)
rednet.open("right")

while true do
	local senderID, message, protocol = rednet.receive()
	data = senderID..": "..message.." :"..protocol
	print(data)
	--logData(data)
end


--[[ 
	local modem = peripheral.wrap("right")
	modem.open(os.getComputerID())
	event, side, sChannel, rChannel, data, dist = os.pullEvent("modem_message")
	]]
