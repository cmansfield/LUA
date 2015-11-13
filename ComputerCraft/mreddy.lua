--[[ Made by AirsoftingFox. Please do not redistribute as your own ]]

-- Load APIS for ccSensor
os.unloadAPI()
os.loadAPI("/rom/apis/sensors")
data = {}

local function clear(mon) --This function is used to clear the terminal
	mon.clear()
	mon.setCursorPos(1,5)
	mon.write("Sensor Controller: Online")
	mon.setCursorPos(1,6)
	mon.write("Smart Sensors: Active")
end

local function MonitorOn() 
	local list = redstone.getSides()
	for i=1,6 do
		if peripheral.getType(list[i]) == "monitor" then
			return (list[i])
		end
	end
	return false
end

local function sensorNames(data)	--Not Currently Used
	worldSensor = data[2]
	proximitySensor = data[1]
end

local function resetSafe(SaveState) --Not Currently Used
	local State = nil
	local file = fs.open("/userconfig/Sensors","r")
	if not SaveState then
		State = file.readLine()
		State = file.readLine()
		file.close()
		return(State)
	else
		State = file.readLine()
		file.close()
		file = fs.open("/userconfig/Sensors","w")
		file.writeLine(State)
		file.writeLine(SaveState)
		file.close()
		return(true)
	end
end

-- Dictionary printer
function printDict(data)
	for i,v in pairs(data) do
		print(tostring(i).." - "..tostring(v))
	end
end

local function condenserCheck(checkData)
	local i = 1
	local condenserID
	condenserID = checkData[i]
	while true do 
		for k, v in string.gmatch(condenserID, "Condenser") do
			return(condenserID)
		end
		condenserID = checkData[i]
		i = i + 1
	end
end

-- main
local condenserTarget = nil
local i = 2
local side = MonitorOn()
local forData = {}

if side==false then
	print("There's no monitor attached to the computer. Please attach a monitor before running this program.")
	print("Press any key to exit")
	event = os.pullEvent("char")
	lua()
end
local mon = peripheral.wrap(side)
mon.setTextScale(1)           --Text Size
mon.clear()
mon.clear()
mon.setCursorPos(1,5)
mon.write("Sensor Controller: Online")
mon.setCursorPos(1,6)
mon.write("Smart Sensors: Active")
ctrl = sensors.getController()

data = sensors.getSensors(ctrl) 

-- sensorNames(data)	--Used when I want a more robust program
while true do
	i = 1
	--for i=1,3 do
		forData = sensors.getSensorInfo(ctrl,data[i])
		forData = sensors.getProbes(ctrl,data[i])
		inventoryInfo = forData[2]
		forData = sensors.getAvailableTargetsforProbe(ctrl,data[i],inventoryInfo)
		condenserTarget = condenserCheck(forData)
		sensors.setTarget(ctrl,data[i],condenserTarget)
		while true do
			forData = sensors.getSensorReadingAsDict(ctrl,data[i],condenserTarget,inventoryInfo)	--This is how we can get info from the sensor
			if forData.TotalItems <= 320 then
				mon.setCursorPos(1, 1)
				mon.write("Only "..forData.TotalItems.." Items Remaining!")
				mon.setCursorPos(8, 3)
				mon.write("Restock!!!")
				sleep(2)
				mon.clear()
				mon.setCursorPos(1, 1)
				mon.write("Only "..forData.TotalItems.." Items Remaining!")
				sleep(1)
			else
				mon.clear()
				mon.setCursorPos(1,5)
				mon.write("Sensor Controller: Online")
				mon.setCursorPos(1,6)
				mon.write("Smart Sensors: Active")
				break
			end
		end
	--end
	sleep(3)
	mon.clear()
	mon.setCursorPos(1,5)
	mon.write("Sensor Controller: Online")
	mon.setCursorPos(1,6)
	mon.write("Smart Sensors: Active")
end












