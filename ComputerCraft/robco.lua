--[[Made by AirsoftingFox. Please do not redistribute as your own ]]

term.clear()
myTimer = os.startTimer(0)
password = "default"
version = "1.2"
song = {"13","cat","blocks","chirp","far","mall","mellohi","stal","strad","ward","11","wait"}
length = {180,180,180,345,180,180,197,96,150,180,255,71,238}

function titleBar()
  term.setCursorPos(1,1)
  term.clearLine()
  term.setCursorPos(5, 1)
  print("ROBCO INDUSTRIES UNIFIED OPERATING SYSTEM")
end

function MainMenu()
  term.setCursorPos(3, 10)
  print("> Unlock Safe")
  term.setCursorPos(3, 11)
  print("  Unlock Door")
    term.setCursorPos(3, 12)
  print("  Intercom Music")
  term.setCursorPos(3, 13)
  print("  Intercontinental Ballistic Missile Controls")  
    term.setCursorPos(3, 14)
  print("  Exit Terminal")  

end

function drawDesktop()
  term.clear()
  titleBar()
  term.setCursorPos(7, 2)
  print("COPYRIGHT 2075-2077 ROBCO INDUSTRIES")
  term.setCursorPos(20, 3)
  print("-Server 6-")
  term.setCursorPos(3, 5)
  print("-RobCo Trespasser Management System-  v"..version)
  term.setCursorPos(3, 6)
  print("Welcome User: H$#JK8#@!")
  term.setCursorPos(3, 7)
  print("Checking for System Update:")
  term.setCursorPos(31, 7)
  print("FAILED")
  term.setCursorPos(3, 8)
  print("-------------------------------------------")
end

local function instructions()
	term.setCursorPos(5, 14)
	print ("Press \"?\" to return to the main menu")
end

local function DJinstructions()
	term.setCursorPos(5,13)
	print ("Place a music disk into a disk drive")
	term.setCursorPos(5,14)
	print ("and then press play")
	term.setCursorPos(5,16)
	print ("Press \"?\" to return to the main menu")
end

local function DriveOn() 
	local list = redstone.getSides()
	for i=1,6 do
		if peripheral.getType(list[i]) == "drive" then
			return (list[i])
		end
	end
	return false
end

local function wait(seconds)
	os.startTimer(seconds)
	local time = os.pullEventRaw("timer")
	if event == "timer" and param1 == myTimer then
		play()
		time = os.pullEventRaw("timer")
	end
end

local function play ()
	local side = DriveOn()
	local songTitle
	local songIndex
	
	if side~=false and disk.hasAudio(side) then
		songTitle = disk.getAudioTitle(side)

		for i=1, table.getn(song) do
			if string.find(songTitle, song[i]) ~= nil then
					songIndex = i
				break
			end
		end
		myTimer = os.startTimer(length[songIndex])
		disk.playAudio(side)	
	else
		return
	end
end

local function stop ()
	if myTimer ~= nil then
		myTimer = os.startTimer(0)
		sleep(1)
	end
	disk.stopAudio()
end

local function input(xInitial, yInitial, IsPass)
	local event, param1, text = nil
	while true do
		event, param1 = os.pullEventRaw()
		if event == "timer" and param1 == myTimer then
			play()
		end
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
		elseif event == "key" and param1 == 28 and text ~= nil then --Enter Key
			return(text)
		elseif event == "key" and param1 == 14 and text ~= nil then --Backspace
			text = string.sub(text, 1, string.len(text) - 1)
			term.setCursorPos(xInitial + string.len(text), yInitial)
			print(" ")
		end
	end
end

local function storedData()
	local pass = nil
	if not fs.exists("/userconfig") then 
		fs.makeDir("/userconfig")
	end
	if fs.exists("/userconfig/Hash") then
		local file = fs.open("/userconfig/Hash","r")
		pass = file.readLine()
		file.close()
		return(pass)
	else
		term.setCursorPos(1,2)
		print("Looks like this is the first time you've used this program. Please enter your new password now:")
		pass = read()
		local file = fs.open("/userconfig/Hash","w") --creates the "ToDo" file if one does not exist
		file.writeLine(pass)
		file.close()
		return(pass)
	end
end

local function PasswordMenu()
	local text = nil
	local x = 28
	local y = 10
	redstone.setOutput("left",false)
	redstone.setOutput("right",false)
	redstone.setOutput("back",false)
	term.clear()
	password = storedData()

	while true do
		term.clear()
		drawDesktop()
		term.setCursorPos(3, 10)
		print("> Please enter password: ")
		instructions()
		term.setCursorPos(28, 10)
		event, param1, message = os.pullEventRaw()
		if event == "timer" and param1 == myTimer then
			play()
		end
		if event == "key" and param1 == 53 then
			term.clear()
			drawDesktop()
			MainMenu()
			Main()
		else
			text = input(x, y, true)
			if text == password then
				term.setCursorPos(28, 10)
				print("Correct!            ")
				redstone.setOutput("left",true)
				redstone.setOutput("right",true)
				redstone.setOutput("back",true)
				wait(5)
				redstone.setOutput("left",false)
				redstone.setOutput("right",false)
				redstone.setOutput("back",false)
			else
				term.setCursorPos(13, 12)
				print("Sorry but that's not correct")
				wait(3)
			end
		end
	end
end


local function icbmMenu ()
	while true do
		term.clear()
		drawDesktop()
		term.setCursorPos(3, 10)
		print("> Error, no connection to the server")
		term.setCursorPos(5, 11)
		print("Contact the system administrator")
		instructions()
		term.setCursorPos(28, 10)
		event, param1, message = os.pullEventRaw()
		if event == "timer" and param1 == myTimer then
			play()
		end
		if event == "key" and param1 == 53 then
			term.clear()
			drawDesktop()
			MainMenu()
			Main()
		else
			wait(1)
		end
	end
end


local function intercom ()
	local keyboardCursor = 0
	
	term.clear()
	drawDesktop()
	term.setCursorPos(3, 10)
	print("> Play Music Disk")
	term.setCursorPos(3, 11)
	print("  Stop Music Disk")
	DJinstructions()
	
	while true do
		term.setCursorPos(28, 10)
		event, param1, message = os.pullEventRaw()
		if event == "timer" and param1 == myTimer then
			play()
		end
		if event == "key" then
			if param1 == 53 then
				term.clear()
				drawDesktop()
				MainMenu()
				Main()
			elseif param1 == 200 and keyboardCursor ~= 0 then --up
				term.setCursorPos(3 , 10 + keyboardCursor)
				print(" ")
				term.setCursorPos(3, 9 + keyboardCursor)
				print(">")
				keyboardCursor = keyboardCursor - 1
			elseif param1 == 208 and keyboardCursor ~= 1 then --down
				term.setCursorPos(3 , 10 + keyboardCursor)
				print(" ")
				term.setCursorPos(3, 11 + keyboardCursor)
				print(">")
				keyboardCursor = keyboardCursor + 1
			elseif param1 == 28 then --enter
				if keyboardCursor == 0 then
					play()
				elseif keyboardCursor == 1 then
					stop()
				end
			end
		end
	end
end


function Main()
	local keyboardCursor = 0
	local text = nil
	local x = 28
	local y = 10
	
	while true do
		local event, button, X, Y = os.pullEventRaw()
		if event == "timer" and button == myTimer then
			play()
		end
		
		if event == "key" then
			if button == 200 and keyboardCursor ~= 0 then --up
				term.setCursorPos(3 , 10 + keyboardCursor)
				print(" ")
				term.setCursorPos(3, 9 + keyboardCursor)
				print(">")
				keyboardCursor = keyboardCursor - 1
			elseif button == 208 and keyboardCursor ~= 4 then --down
				term.setCursorPos(3 , 10 + keyboardCursor)
				print(" ")
				term.setCursorPos(3, 11 + keyboardCursor)
				print(">")
				keyboardCursor = keyboardCursor + 1
			elseif button == 28 then --enter
				if keyboardCursor == 0 or keyboardCursor == 1 then
					PasswordMenu()
				elseif keyboardCursor == 2 then
					intercom ()
				elseif keyboardCursor == 3 then
					icbmMenu()
				elseif keyboardCursor == 4 then
					term.clear()
					password = storedData()

					while true do
						term.clear()
						drawDesktop()
						term.setCursorPos(3, 10)
						print("> Please enter password: ")
						instructions()
						term.setCursorPos(28, 10)
						event, param1, message = os.pullEventRaw()
						if event == "timer" and param1 == myTimer then
							play()
						end
						if event == "key" and param1 == 53 then
							term.clear()
							drawDesktop()
							MainMenu()
							Main()
						else
							text = input(x, y, true)
							if text == password then
								term.clear()
								lua()
							else
								term.setCursorPos(13, 12)
								print("Sorry but that's not correct")
								wait(3)
							end
						end
					end
				end
			end
		else
		   slc = 0
		   drawDesktop()
		   MainMenu()
		end
	end
end

--main
drawDesktop()
wait(1)
MainMenu()
Main()

