--[[ Thanks for using the Auto-Power system
Please remember this is the intellectual property 
of AirsoftingFox. Please do not redistribute as your own.
Enjoy, and if you have any questions send me a message ]]

local function MonitorOn() 
	local list = redstone.getSides()
	for i=1,6 do
		if peripheral.getType(list[i]) == "monitor" then
			return (list[i])
		end
	end
	return false
end

local function RedstoneChange(OnOff,SideNot)
	local list = {"left", "right", "front", "back", "bottom", "top"}
	if OnOff then
		for i=1,6 do
			if list[i]~=SideNot then
				redstone.setOutput(list[i], true) 
			end
		end
	else
		for i=1,6 do
			if list[i]~=SideNot then
				redstone.setOutput(list[i], false)
			end
		end
	end
end
	
	
--main
local side = MonitorOn()
local mon = nil
if side then
	mon = peripheral.wrap(side)
end
if side then
	mon.setTextScale(1)
end
local CurrentTime, min, DayStatus, BoolOn = nil
local BoolOn = false

while true do 
	min = os.time() % 1
	min = min * 60
	CurrentTime=string.format("%02d:%02d", math.floor(os.time()), min)
	if os.time() >18.5 then
		DayStatus = "Night Time"
		RedstoneChange(false,side)
		BoolOn = false
	elseif os.time() >12 then
		DayStatus = "Afternoon!"
		RedstoneChange(true,side)
		BoolOn = true
	elseif os.time() >4.5 then
		DayStatus = "Good Morning"
		RedstoneChange(true,side)
		BoolOn = true
	else
		DayStatus = "Early Morning"
		RedstoneChange(false,side)
		BoolOn = false
	end
	term.clear()
	term.setCursorPos(1,2)
	if side then
		mon.clear()
		mon.setCursorPos(1, 2)
		mon.write(DayStatus)
		mon.setCursorPos(1, 4)
		mon.write(CurrentTime)
		mon.setCursorPos(1, 6)
		if BoolOn then
			mon.write("Current status: Powered On")
		else	
			mon.write("Current status: Powered Off")
		end
	end
	print(DayStatus)
	print(" ")
	print(CurrentTime)
	print(" ")
	print(" ")
	if BoolOn then
		print("Current status: Powered On")
	else	
		print("Current status: Powered Off")
	end
	sleep(5)
end