--[[ Made by AirsoftingFox. Please do not redistribute as your own ]]

password = "default"


local function instructions()
	term.setCursorPos(1, 16)
	print [[
Press "?" to exit the program ]]
end

local function wait(seconds)
	os.startTimer(seconds)
	local time = os.pullEventRaw("timer")
end

local function input(xInitial, yInitial, IsPass)
	local event, param1, text = nil
	while true do
		event, param1 = os.pullEventRaw()
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

local function interface() --This function is used to exit the program if the correct pass is entered
	local x, y = nil
	local InterfacePass = "???"
	term.clear()
	print("To perform this function you must enter your password: ")
	x, y = term.getCursorPos()
	InterfacePass = input(x, y, true) 
	if InterfacePass == storedData() then
		return(true)
	else
		return(false)
	end
end

--main
local text = nil
local x = 2
local y = 5
redstone.setOutput("left",false)
redstone.setOutput("right",false)
term.clear()
password = storedData()


while true do
	term.clear()
	term.setCursorPos(1,2)
	print("Welcome!")
	instructions()
	term.setCursorPos(1,4)
	print("Please enter password: ")
	event, param1, message = os.pullEventRaw()
	if event == "key" and param1 == 53 then
		if interface() then
			lua()
		else 
			term.clear()
			instructions()
		end
	else
		text = input(x, y, true)
		if text == password then
			print(" ")
			print("Correct!")
			redstone.setOutput("left",true)
			redstone.setOutput("right",true)
			wait(5)
			redstone.setOutput("left",false)
			redstone.setOutput("right",false)
		else
			print(" ")
			print("Sorry but that's not correct")
			wait(3)
		end
	end
end