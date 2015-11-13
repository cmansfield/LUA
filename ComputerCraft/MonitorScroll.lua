
strtpos = 12                  --Start position on screen
ypos = 1                      --text vertical position
speed = 0.2                   --Scroll Speed (Seconds)
text = "This is some Text"    --Displayed Text

local function MonitorOn() 
	local list = redstone.getSides()
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
		pos = strtpos
	else
		pos = pos - 1
	end
end