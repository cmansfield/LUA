--[[Made by AirsoftingFox. Please do not redistribute as your own ]]
compass = {direction = "north","north","east","south","west"},{home = "north","north","east","south","west"}
gps = {x = "0", y = "0", z = "0"}
jobStatus = "waiting"
slot = 1
turnflag = true


local function updatefile()
	local file = fs.open("/userconfig/status","w") --creates the "Access" file if one does not exist
	file.writeLine(jobStatus)
	file.writeLine(gps.x)
	file.writeLine(gps.y)
	file.writeLine(gps.z)
	file.writeLine(compass.home)
	file.writeLine(slot)
	file.writeLine(turnflag)
	file.close()
	return
end


local function obstacle(detect)
	local event = nil
	
	if detect == "forward" then
		while turtle.detect() do
			term.clear()
			term.setCursorPos(1,2)
			print("There's something in front of me!")
			print(" ")
			print("Please move the obstacle and then press Enter to resume")
			event = os.pullEvent()
		end
	elseif detect == "up" then
		while turtle.detectUp() do
			term.clear()
			term.setCursorPos(1,2)
			print("There's something above me!")
			print(" ")
			print("Please move the obstacle and then press Enter to resume")
			event = os.pullEvent()
		end
	elseif detect == "down" then
		term.clear()
		term.setCursorPos(1,2)
		print("There's something in below of me!")
		print(" ")
		print("Please move the obstacle and then press Enter to resume")
		event = os.pullEvent()
	end
	return
end


local function automove (move)
	local file
	if move == "forward" then
		if compass.direction == "north" then
			gps.y = gps.y + 1
		elseif compass.direction == "east" then
			gps.x = gps.x + 1
		elseif compass.direction == "south" then
			gps.y = gps.y - 1
		elseif compass.direction == "west" then
			gps.x = gps.x - 1
		end

		if not turtle.forward() then
			if compass.direction == "north" then
				gps.y = gps.y - 1
			elseif compass.direction == "east" then
				gps.x = gps.x - 1
			elseif compass.direction == "south" then
				gps.y = gps.y + 1
			elseif compass.direction == "west" then
				gps.x = gps.x + 1
			end
			obstacle("forward")
		end
		
	elseif move == "back" then
		if turtle.back() then
			if compass.direction == "north" then
				gps.y = gps.y - 1
			elseif compass.direction == "east" then
				gps.x = gps.x - 1
			elseif compass.direction == "south" then
				gps.y = gps.y + 1
			elseif compass.direction == "west" then
				gps.x = gps.x + 1
			end
		end

	elseif move == "up" then
		gps.z = gps.z + 1

		if not turtle.up() then
			gps.z = gps.z - 1
			obstacle("up")

		end
	elseif move == "down" then
		gps.z = gps.z - 1
		if not turtle.down() then
			gps.z = gps.z + 1

			obstacle("down")
		end
	elseif move == "turnLeft" then
		turtle.turnLeft()
		for i=1, 4 do
			if compass.direction == compass[i] then
				if i == 1 then
					compass.direction = compass[4]
					break
				else
					compass.direction = compass[i-1]
					break
				end
			end
		end

	elseif move == "turnRight" then
		turtle.turnRight()
		for i=1, 4 do
			if compass.direction == compass[i] then
				if i == 4 then
					compass.direction = compass[1]
					break
				else
					compass.direction = compass[i+1]
					break
				end
			end
		end
	end
end


local function wall()
	local wArgs = {x = gps.x, y = gps.y, z = gps.z, direction = compass.direction}
	local distance = 5
	local height = 1
	local event
	local a, i = 0
	local hCount = 0
	local file

	term.clear()
	term.setCursorPos(1,3)
	print("Enter wall distance")
	distance = read()
	term.clear()
	term.setCursorPos(1,3)
	print("Enter wall height")
	height = read()
	jobStatus = "wall"
	automove("up")
	automove("forward")

	turtle.select(slot)
	term.clear()
	
	hCount = hCount + (math.abs(tonumber(gps.z) - math.abs(tonumber(wArgs.z))))-1
	while hCount ~= math.abs(height)+math.abs(tonumber(wArgs.z)) do
		if turnflag then
			if wArgs.direction=="north" or wArgs.direction=="south" then
				a = math.abs(tonumber(gps.y)-tonumber(wArgs.y))
			else
				a = math.abs(tonumber(gps.x)-tonumber(wArgs.x))
			end
			
			
			for i=a, distance do
				if turtle.getItemCount(slot) == 0 then
					slot = slot + 1
					if slot == 10 then 
						slot = 1
						while turtle.getItemCount(slot) == 0 do
							term.clear()
							term.setCursorPos(3,2)
							print("Out of stock!")
							term.setCursorPos(3,3)
							print("Refill and press Enter")
							slot = 1
							event = os.pullEvent()
						end
						slot = 1

					end
				end
				turtle.select(slot)
				turtle.placeDown()
				if i~=distance-1 then
					automove("forward")
				end
			end
			turtle.select(slot)
			turtle.placeDown()
			automove("turnRight")
			automove("turnRight")
			automove("up")
			hCount = hCount + 1
			turnflag = false
		else
			if wArgs.direction=="north" or wArgs.direction=="south" then
				a = math.abs(math.abs(tonumber(wArgs.y)-tonumber(gps.y))-distance)+1
			else
				a = math.abs(math.abs(tonumber(wArgs.x)-tonumber(gps.x))-distance)+1
			end
			for i=a, distance do
				if turtle.getItemCount(slot) == 0 then
					slot = slot + 1
					if slot == 10 then 
						slot = 1
						while turtle.getItemCount(slot) == 0 do
							term.clear()
							term.setCursorPos(3,2)
							print("Out of stock!")
							term.setCursorPos(3,3)
							print("Refill and press Enter")
							slot = 1
							event = os.pullEvent()
						end
						slot = 1
					end
				end
				turtle.select(slot)
				turtle.placeDown()
				if i~=distance-1 then
					automove("forward")
				end
			end
			turtle.select(slot)
			turtle.placeDown()
			automove("turnRight")
			automove("turnRight")
			automove("up")
			hCount = hCount + 1
			turnflag = true
		end
	end
	jobStatus = "waiting"
end


local function floor()
	local fArgs = {x = gps.x, y = gps.y, z = gps.z, direction = compass.direction}
	local length = 1
	local width = 1
	local turnflag = true
	local i = 0
	local wCount = 0
	local file

	term.clear()
	term.setCursorPos(1,3)
	print("Enter floor length")
	length = read()
	term.clear()
	term.setCursorPos(1,3)
	print("Enter floor width")
	width = read()
	jobStatus = "floor"

	turtle.select(slot)
	term.clear()
	wCount = tonumber(fArgs.x)
	automove("up")
	automove("forward")
	while wCount ~= width+tonumber(fArgs.x) do
		for i=tonumber(fArgs.y)+1, length+tonumber(fArgs.y) do
			if turtle.getItemCount(slot) == 0 then
				slot = slot + 1
				if slot == 10 then 
					slot = 1
					while turtle.getItemCount(slot) == 0 do
						term.clear()
						term.setCursorPos(3,2)
						print("Out of stock!")
						term.setCursorPos(3,3)
						print("Refill and press Enter")
						slot = 1
						event = os.pullEvent()
					end
					slot = 1
				end
			end
			turtle.select(slot)
			turtle.placeDown()
			
			if i~=length+tonumber(fArgs.y) then
				automove("forward")
			end
			
		end
		if turnflag then
			automove("turnLeft")
			automove("forward")
			automove("turnLeft")
			--automove("forward")
			wCount = wCount + 1
			turnflag = false
		else 
			automove("turnRight")
			automove("forward")
			automove("turnRight")
			--automove("forward")
			wCount = wCount + 1
			turnflag = true
		end
	end
	jobStatus = "waiting"
end


local function sphere()
	local tArgs = {}
	local radius = 5
	local turnflag = true

	turtle.select(slot)
	term.clear()
	term.setCursorPos(1,3)
	print("Enter Sphere's Radius: ")
	tArgs[1] = read()
	radius = tonumber(tArgs[1])
	for k = -radius,radius do
		turnflag = true
		for i = 1,radius do
			automove("back")
		end
		automove("turnRight")
		for i = 1,radius do
			automove("back")
		end
		automove("turnLeft")
		for i = -radius, radius do
			for j = -radius, radius do
				if turtle.getItemCount(slot) == 0 then
					slot = slot + 1
					if slot == 10 then 
						slot = 1
						while turtle.getItemCount(slot) == 0 do
							term.clear()
							term.setCursorPos(3,2)
							print("Out of stock!")
							term.setCursorPos(3,3)
							print("Refill and press Enter")
							slot = 1
							event = os.pullEvent()
						end
						slot = 1
					end
					turtle.select(slot)
				end
				if math.sqrt(i*i + j*j + k*k) <= radius then
				turtle.placeDown()
			end
			automove("forward")
		end
		if turnflag == true then
			automove("turnRight")
			automove("forward")
			automove("turnRight")
			automove("forward")
			turnflag = false
		else
			automove("turnLeft")
			automove("forward")
			automove("turnLeft")
			automove("forward")
		
			turnflag = true
		end
		  
	end
	for i=1,radius do
		automove("forward")
	end
	automove("turnLeft")
	for i=0,radius do
		automove("back")
	end
	automove("up")
end
end


local function cylinder()
	local tArgs = {}
	local radius = 5
	local height = 5
	local turnflag = true

	turtle.select(slot)
	term.clear()
	term.setCursorPos(1,3)
	print("Enter cylinder's Radius: ")
	tArgs[1] = read()
	term.clear()
	term.setCursorPos(1,3)
	print("Enter cylinder's Height: ")
	tArgs[2] = read()
	radius = tonumber(tArgs[1])
	height = tonumber(tArgs[2])
	for j=1, height do
		automove("up")
		turnflag = true
		for i = 1,radius do
			automove("back")
		end
		automove("turnRight")
		for i = 1,radius do
			automove("back")
		end
		automove("turnLeft")
		for k = -radius,radius do
			for i = -radius, radius do
				if turtle.getItemCount(slot) == 0 then
					slot = slot + 1
					if slot == 10 then 
						slot = 1
						while turtle.getItemCount(slot) == 0 do
							term.clear()
							term.setCursorPos(3,2)
							print("Out of stock!")
							term.setCursorPos(3,3)
							print("Refill and press Enter")
							slot = 1
							event = os.pullEvent()
						end
						slot = 1
					end
					turtle.select(slot)
				end
				if math.floor(math.sqrt(i*i + k*k)) == radius then
					turtle.placeDown()
				end
				automove("forward")
			end
			if turnflag == true then
				automove("turnRight")
				automove("forward")
				automove("turnRight")
				automove("forward")
				turnflag = false
			else
				automove("turnLeft")
				automove("forward")
				automove("turnLeft")
				automove("forward")
				turnflag = true
			end

		end
		for i=1,radius do
			automove("forward")
		end
		automove("turnLeft")
		for i=0,radius do
			automove("back")
		end
	end
end


local function movemanual()
	local event, param1 = nil
	
	while true do
		term.clear()
		term.setCursorPos(1,1)
		print("GPS x:",gps.x," y:",gps.y," z:",gps.z)
		term.setCursorPos(1,2)
		print("Direction: ",compass.direction)
		term.setCursorPos(4,3)
		print("Press 'Up' to move turtle up")
		term.setCursorPos(4,4)
		print("press 'Down' to move turtle down")
		term.setCursorPos(4,5)
		print("Press 'Left' to move left")
		term.setCursorPos(4,6)
		print("Press 'Right' to move right")
		term.setCursorPos(4,7)
		print("Press 'F' to move forward")
		term.setCursorPos(4,8)
		print("Press 'B' to move back")
		term.setCursorPos(4,9)
		print("Press 'H' for GPS Home")
		term.setCursorPos(4,10)
		print("Press 'S' set new GPS Home")
		term.setCursorPos(4,11)
		print("Press 'R' to return to main menu")
		event, param1 = os.pullEvent()
		if event == "char" then
			if param1 == "h" then
				if tonumber(gps.x) > 0 then
					while compass.direction ~= "west" do
						automove("turnRight")
					end
					while tonumber(gps.x) ~= 0 do
						automove("forward")
					end
				elseif tonumber(gps.x) < 0 then
					while compass.direction ~= "east" do
						automove("turnRight")
					end
					while tonumber(gps.x) ~= 0 do
						automove("forward")
					end
				end
				if tonumber(gps.y) > 0 then
					while compass.direction ~= "south" do
						automove("turnRight")
					end
					while tonumber(gps.y) ~= 0 do
						automove("forward")
					end
				elseif tonumber(gps.y) < 0 then
					while compass.direction ~= "north" do
						automove("turnRight")
					end
					while tonumber(gps.y) ~= 0 do
						automove("forward")
					end
				end
				if tonumber(gps.z) > 0 then
					while tonumber(gps.z) ~= 0 do
						automove("down")
					end
				elseif tonumber(gps.z) < 0 then
					while tonumber(gps.z) ~= 0 do
						automove("up")
					end
				end
				while compass.direction ~= compass.home do
						automove("turnRight")
				end
			elseif param1 == "s" then
				term.clear()
				term.setCursorPos(1,3)
				print("Are you sure you want to change your Turtle's GPS Home?")
				term.setCursorPos(3,6)
				print("Press 'Y' for yes or 'N' for no")
				event2, param2 = os.pullEvent()
				while tostring(param2)~="y" or tostring(param2)~="n" do
					event2, param2 = os.pullEvent()
					if tostring(param2)=="y" then 
						term.clear()
						term.setCursorPos(1,3)
						print("Enter a new X value (moves turtle side to side)")
						gps.x = tonumber(read())
						if gps.x == null then
							gps.x = 0
						end
						term.clear()
						term.setCursorPos(1,3)
						print("Enter a new Y value (moves turtle forward and backward)")
						gps.y = tonumber(read())
						if gps.y == null then
							gps.y = 0
						end
						term.clear()
						term.setCursorPos(1,3)
						print("Enter a new Z value (moves turtle up and down)")
						gps.z = tonumber(read())
						if gps.z == null then
							gps.z = 0
						end
						compass.home = compass.direction
						break
					else 
						break
					end
				end
			end
		end
		if event == "key" then
			if param1 == 200 then		--up
				automove("up")
			elseif param1 == 208 then	--down
				automove("down")
			elseif param1 == 203 then	--left
				automove("turnLeft")
			elseif param1 == 205 then	--right
				automove("turnRight")
			elseif param1 == 33 then	--forward
				automove("forward")
			elseif param1 == 48 then	--back
				automove("back")
			elseif param1 == 19 then	--'r' to go back to the main menu
				updatefile()
				return
			end
		end
	end
end



--main
local k = 1
local event, param1 = nil

if not fs.exists("/userconfig") then 
	fs.makeDir("/userconfig")
end
if fs.exists("/userconfig/status") then
	local file = fs.open("/userconfig/status","r")
	jobStatus = file.readLine()
	gps.x = file.readLine()
	gps.y = file.readLine()
	gps.z = file.readLine()
	compass.home = file.readLine()
	slot = tonumber(file.readLine())
	turnflag = file.readLine()
	file.close()
end
if compass.home == null then
	compass.home = "north"
end

if slot == 11 then
	slot = 1
	while turtle.getItemCount(slot) == 0 do
		term.clear()
		term.setCursorPos(3,2)
		print("Out of stock!")
		term.setCursorPos(3,3)
		print("Refill and press Enter")
		slot = 11
		event = os.pullEvent()
		slot = 1
	end
end
while true do
	updatefile()
	term.clear()
	term.setCursorPos(1,1)
	print("Construction Turtle v1.2")
	term.setCursorPos(2,3)
	print("Press 'W' to make a wall")
	term.setCursorPos(2,4)
	print("press 'F' to make a floor")
	term.setCursorPos(2,5)
	print("Press 'S' to build a sphere")
	term.setCursorPos(2,6)
	print("Press 'C' to build Cylinder")
	term.setCursorPos(2,7)
	print("Press 'M' to manually move")
	term.setCursorPos(2,8)
	print("Press 'T' to exit")
	term.setCursorPos(1,10)
	print("**Remove all obstacles from build")
	term.setCursorPos(14,11)
	print("site**")
	event, param1 = os.pullEvent("char")
	if param1 == "w" then
		wall()
	elseif param1 == "f" then
		floor()
	elseif param1 == "s" then
		sphere()
	elseif param1 == "c" then
		cylinder()
	elseif param1 == "m" then
		movemanual()
	elseif param1 == "t" then
		term.clear()
		lua()
	end
	updatefile()
end
