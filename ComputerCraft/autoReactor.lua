--[[ Made by AirsoftingFox. Please do not redistribute as your own ]]

--[[In order to make this program work you MUST do the following:
red bundled wire (inverted) to the reactor
blue bundled wire (inverted) to a timer connected to the ice filter
ice filter's timer must be set at 4.8sec
the ice pneumatic line must not exceed 5 tubes
orange bundled wire (inverted) to a timer connected to the dump filter
dump filter's timer can be set to any time, faster the better
All dump contents MUST be dumped into lava or void or else they will 
	go back into the reactor.
green bundled wire is connected directly to the new fuel filter, this 
	filter will be attached to a chest with NEW uranium cells to refill
	the reactor.
When installing for the first time make sure there aren't any other
	reactors near by, place the sensor next to your 6 chamber reactor.
	Add a lever to the side of the reactor and power it on to ensure 
	the reactor is off. Fill the reactor will 46 new uranium cells and 
	6 stacks of ice. Place your computer, monitor, and sensor control 
	box where ever you would like. Run a bundled wire from the BACK of
	the computer to the reactor site. Following the setup above attach
	the bundled wire to the correct locations. Make sure any MFSU's 
	being powered by the reactor are close by, this ensures the sensor 
	will pick up the data from the MFSU.
Optional: have colored wires off shoot from the main bundled wire line
	and add lamps for each stage. Red for active, Orange for dumping, 
	Green for refilling, and Blue for pumping ice. 
]]


-- Load APIS for ccSensor
os.unloadAPI()
os.loadAPI("/rom/apis/sensors")
data = {}
storedName = "?"
tickDelta = nil
ctrl = sensors.getController()
sensorData = sensors.getSensors(ctrl)




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

local function isReactor(checkData)
	local i = 1
	local reactorID
	reactorID = checkData[i]
	while true do 
		if string.match(reactorID,"Reactor") then
			return(reactorID)
		else
			print("There's no reactor detected by the sensor. Please place sensor near a reactor.")
			print("Press any key to reboot")
			event = os.pullEvent("char")
			os.reboot()
		end
		i = i + 1
		reactorID = checkData[i]
	end
end

function checkItems (checkData)
	local i = 1
	local itemIce = ""
	local itemFuel = ""
	local int iceTotal = 0
	local int fuelTotal = 0
	local int fuelCount = 0
	--itemIce = checkData[i]
	--printDict(checkData)
	for i,v in pairs(checkData) do
		itemIce = tostring(v)
		if itemIce then
			if string.find(itemIce, 'ice') then
				if string.len(itemIce)>12 then
					iceTotal = iceTotal + tonumber(string.sub(itemIce, 1, 2))
				else
					iceTotal = iceTotal + tonumber(string.sub(itemIce, 1, 1))
				end
			elseif string.match(itemIce,"CellUran") then
				if string.match(itemIce,"-") then
					fuelTotal = tonumber(string.sub(itemIce, 22, string.len(itemIce)))
					fuelTotal = math.floor(fuelTotal / 320)
				else
					fuelTotal = tonumber(string.sub(itemIce, 21, string.len(itemIce)))
					fuelTotal = math.floor((10000 - fuelTotal) / 100)
				end
				fuelCount = fuelCount + 1
			end
		else
		end
	end
	return iceTotal, fuelTotal, fuelCount
end

local function checkReactor ()
	local forData = {}
	local reactorProbe, reactorTarget, reactorContentProbe = nil
	local heat, output, size, totalIce, totalFuel, fuelCount = nil
	
	--setSensorRange(ctrl,sensorData[1],'2') 
 	forData = sensors.getProbes(ctrl,sensorData[1])
	reactorProbe = forData[2]
	reactorContentProbe = forData[5]
	forData = sensors.getAvailableTargetsforProbe(ctrl,sensorData[1],reactorProbe)
	if fs.exists("/userconfig/ReactorID") then
		local file = fs.open("/userconfig/ReactorID","r")
		reactorTarget = file.readLine()
		file.close()
	else
		local file = fs.open("/userconfig/ReactorID","w") --creates the "ReactorID" file if one does not exist
		reactorTarget = isReactor(forData)
		file.writeLine(reactorTarget)
		file.close()
	end
	sensors.setTarget(ctrl,sensorData[1],reactorTarget)
	forData = sensors.getSensorReadingAsDict(ctrl,sensorData[1],reactorTarget,reactorProbe)
	heat = forData.heat
	output = forData.output
	size = forData.size
	forData = sensors.getSensorReadingAsDict(ctrl,sensorData[1],reactorTarget,reactorContentProbe)
	totalIce, totalFuel, fuelCount = checkItems(forData)
	return heat, output, size, totalIce, totalFuel, fuelCount
end

local function checkMFSU ()
	local forData = {}
	local energyA = {}
	local c = 1
	local mfsuCount = 0
	local storedPercentage = {}
	
	--setSensorRange(ctrl,sensorData[1],'2') 
	forData = sensors.getProbes(ctrl,sensorData[1])
	euInfo = forData[3]
	forData = sensors.getAvailableTargetsforProbe(ctrl,sensorData[1],euInfo)
	storageName = forData[1]
	if storageName then
		for i,v in pairs(forData) do
			storageName = tostring(v)
			if storageName then
				if string.find(storageName, "MFSU") or string.find(storageName, "MFE") then
					sensors.setTarget(ctrl,sensorData[1],forData[c])
					energyA = sensors.getSensorReadingAsDict(ctrl,sensorData[1],forData[c],euInfo)
					storedPercentage[c] = energyA.energy / energyA.maxStorage
					c = c + 1
				end
				mfsuCount = mfsuCount + 1
			end
		end
		return mfsuCount, storedPercentage
	else
		mfsuCount = 0
		storedPercentage[1] = 0
		return mfsuCount, storedPercentage
	end
end

local function display(mon, senorName, status) 
	local heatabs, tick
	local heat, output, size, totalIce, totalFuel = nil
	local mfsuCount, storedPercentage
	heat, output, size, totalIce, totalFuel, fuelCount = checkReactor()
	mfsuCount, storedPercentage = checkMFSU()
	tick = 0
	
	--totalFuel = 2500
	mon.clear()
	mon.setCursorPos(2,1)
	mon.write("Nuclear Reactor: "..senorName)
	mon.setCursorPos(1,2)
	mon.write("=========================================================")
	mon.setCursorPos(35,1)
	mon.write("Reactor Status: ")
	mon.setCursorPos(51,1)
	mon.write(status)
	if tickDelta then
		tick = math.floor((60/(((storedPercentage[1] - tickDelta)*10000000)/2000))*10)/10
		tickDelta = storedPercentage[1]
	else 
		if storedPercentage[1] then
			tickDelta = storedPercentage[1]
		end
	end
	mon.setCursorPos(2,4)
	mon.write("EU output: "..output.."eu per "..tick.." ticks")
	mon.setCursorPos(2,5)
	mon.write("Warnings: None")
	mon.setCursorPos(1,7)
	mon.write("--- Reactor Information ---")
	mon.setCursorPos(2,9)
	mon.write("Number of reactor chambers")
	mon.setCursorPos(29,9)
	mon.write(": "..size)
	mon.setCursorPos(2,10)
	mon.write("Number of uranium cells")
	mon.setCursorPos(29,10)
	mon.write(": "..fuelCount)
	mon.setCursorPos(2,11)
	mon.write("Ice remaining: ")
	mon.setCursorPos(29,11)
	mon.write(": "..totalIce)
	mon.setCursorPos(1,14)
	mon.write("EU Storage")
	
	if mfsuCount then
		for i=1,mfsuCount do
			mon.setCursorPos(2,14+i)
			mon.write("MFSU-"..i.."      [")
			mon.setCursorPos(24,14+i)
			mon.write("] "..math.floor(storedPercentage[i]*100).."%")
			for a=1,9 do
				mon.setCursorPos(14+a,14+i)
				if a< math.floor(storedPercentage[i]*10) then
					mon.write("#")
				else
					mon.write(" ")
				end
			end
			if i==4 then break end
		end
	end
	mon.setCursorPos(40,17)
	mon.write("Fuel")
	mon.setCursorPos(41,16)
	mon.write("--")
	mon.setCursorPos(41,6)
	mon.write("--")
	mon.setCursorPos(50,17)
	mon.write("Heat")
	mon.setCursorPos(51,16)
	mon.write("--")
	mon.setCursorPos(51,6)
	mon.write("--")
	heatabs = (heat / 60)
	for i=1,9 do
		mon.setCursorPos(51,16-i)
		if i<heatabs/10 and (i+1)>heatabs/10 then
			mon.write("==")
			mon.setCursorPos(54,16-i)
			mon.write(math.floor(heatabs).."%")
		else
			mon.write("||")
		end
		if 1>heatabs/10 then
			mon.setCursorPos(54,16)
			mon.write(math.floor(heatabs).."%")
		end
		mon.setCursorPos(41,16-i)
		if i<totalFuel/10 and (i+1)>totalFuel/10 then
			mon.write("==")
			mon.setCursorPos(44,16-i)
			mon.write(math.floor(totalFuel).."%")
		else
			mon.write("||")
		end
		if 1>totalFuel/10 then
			mon.setCursorPos(44,16)
			mon.write(math.floor(totalFuel).."%")
		elseif totalFuel==100 then
			mon.setCursorPos(44,6)
			mon.write(math.floor(totalFuel).."%")
		end
	end
	return totalFuel, fuelCount, totalIce
end

local function newName(reactorName)
	if not fs.exists("/userconfig") then 
		fs.makeDir("/userconfig")
	end
	if fs.exists("/userconfig/Sensors") then
		local file = fs.open("/userconfig/Sensors","r")
		reactorName = file.readLine()
		file.close()
		return(reactorName)
	else
		local file = fs.open("/userconfig/Sensors","w") --creates the "Sensors" file if one does not exist
		file.writeLine(reactorName)
		file.close()
	end
end




function main ()
local condenserTarget, status, fuelLevel, fuelCount, totalIce = nil
local i = 2
local side = MonitorOn()
local forData = {}

sleep(2)	--wait for chunk loading
if side==false then
	print("There's no monitor attached to the computer. Please attach a monitor before running this program.")
	print("Press any key to exit")
	event = os.pullEvent("char")
	lua()
end
local mon = peripheral.wrap(side)
mon.setTextScale(1)           --Text Size
if fs.exists("/userconfig/Sensors") then
	storedName = newName()
else
	while string.len(storedName)<2 do
		print(" ")
		print("Enter a new reactor name:")
		print(" ")
		storedName = read()
		sleep(1)
	end
	newName(storedName)
end
status = "startup"
while true do
	if status=="startup" then
		fuelLevel, fuelCount, totalIce = display(mon, storedName, status)
		sleep(3)
		if fuelCount == 0 then
			status = "refill"
		else
			status = "active"
		end
			--add code here to load status from file if server reset
		
	elseif status=="active" then
		redstone.setBundledOutput("back", colors.red+colors.blue) --red will power on the reactor, remember to invert the redstone
		fuelLevel, fuelCount, totalIce = display(mon, storedName, status)
		sleep(3)
		if fuelLevel<5 then
			status = "refill"
		end
	elseif status=="refill" then
		redstone.setBundledOutput("back", 0)	--shuts off the reactor
		while fuelCount~=0 do
			redstone.setBundledOutput("back", colors.orange)	--powers on the dumping filter, add a timer to redstone
			fuelLevel, fuelCount, totalIce = display(mon, storedName, status)
			sleep(3)
		end
		redstone.setBundledOutput("back", 0)	--shuts off the dumping filter
		fuelLevel, fuelCount, totalIce = display(mon, storedName, status)
		for i=1,46 do
			redstone.setBundledOutput("back", colors.green)	--powers on the fuel filter, add a timer to redstone
			sleep(0.5)
			redstone.setBundledOutput("back", 0)
			sleep(0.5)
		end
		fuelLevel, fuelCount, totalIce = display(mon, storedName, status)
		redstone.setBundledOutput("back", 0)
		redstone.setBundledOutput("back", colors.blue)	--powers on the ice filter, add a timer to redstone
		fuelLevel, fuelCount, totalIce = display(mon, storedName, status)
		sleep(28.8)
		fuelLevel, fuelCount, totalIce = display(mon, storedName, status)
		if fuelCount > 46 then
			status = "shutdown"
		else
			status = "active"
			redstone.setBundledOutput("back", colors.red) --red will power on the reactor, remember to invert the redstone
			sleep(3)
		end
	elseif status=="shutdown" then
		fuelLevel, fuelCount, totalIce = display(mon, storedName, status)
		redstone.setBundledOutput("back", 0)
		print(" ")
		print("Error with the reactor fuel")
		print("Reactor shutdown to prevent meltdown")
		lua()
	end
end
end



local status = pcall(main)
if status then
	print("there were errors")
end












