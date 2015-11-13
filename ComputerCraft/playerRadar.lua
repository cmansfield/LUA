--[[ Made by AirsoftingFox. Please do not redistribute as your own ]]

-- Load APIS for ccSensor
os.unloadAPI()
os.loadAPI("/rom/apis/sensors")
sensorSide = sensors.getController() --Stores the 'side' the sensor is located
sensorNames = sensors.getSensors(sensorSide) --Collects the sensor name


local function checkPlayer ()
	local forData = {}
	local worldProbe, playerTarget = nil
	local name = nil
	
	--setSensorRange(sensorSide,sensorNames[1],'2') 
 	forData = sensors.getProbes(sensorSide,sensorNames[1])
	

	
	for i,v in pairs(forData) do
		print(tostring(v))
	end
	local event = os.pullEvent()
	
	
	
	worldProbe = forData[3]
	forData = sensors.getAvailableTargetsforProbe(sensorSide,sensorNames[1],worldProbe)

	--forData = getSensorInfoAsTable(sensorSide,sensorNames[1],...) --errors out
	
	for i,v in pairs(forData) do
		print(tostring(v))
	end
	local event = os.pullEvent()

	
	return name
end

--main
checkPlayer()