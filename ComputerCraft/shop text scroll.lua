
strtpos = 43                  --Start position on screen
ypos = 1                      --text vertical position
speed = 0.2                   --Scroll Speed (Seconds)
size = 2                      --text size
text = "Welcome to AirsoftingFox's ComputerCraft shop"    --Displayed Text

local function MonitorOn() 
local list = redstone.getSides()
event, param1 = nil
setredstone.setOutput("left", false)
sleep(1)
event, param1 = os.pullEvent("redstone")
	for i=1,6 do
		if peripheral.getType(list[i]) == "monitor" then
		return (list[i])
		end
	end
	return false
end

--main
local pos = strtpos
local poslimit = 0 - strtpos
local side = MonitorOn()
local count = 1

if side==false then
	print("There's no monitor attached to the computer. Please attach a monitor before running this program.")
	print("Press any key to exit")
	event = os.pullEvent("char")
	lua()
end
local mon = peripheral.wrap(side)
mon.setTextScale(2)           --Text Size

while true do
	mon.clear()
	mon.setCursorPos(pos, ypos)
	mon.write(text)
	sleep(speed)
	if pos == poslimit then
		redstone.setOutput("left", false)
		sleep(1)
		event, param1 = os.pullEvent("redstone")
		count = 1
		pos = strtpos
	else
		if count >= 43 then
			pos = pos - 1
		else
			for i=1,43 do
				count = count + 1
				pos = pos - 1
				mon.clear()
				mon.setCursorPos(pos, ypos)
				mon.write(text)
				sleep(speed)
			end
				redstone.setOutput("left", true)
		end
	end
end