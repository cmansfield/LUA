--[[ Made by AirsoftingFox. Please do not redistribute as your own ]]--

--[[ Things to add for v1.0
	* Add monitor support
	* Optimize program
	* Add more types of pets
	* Add the ability to have more than one pet
	
	Things to add
	* Bonus dinosaur unlock
	* Have certain animals locked until previous pet reaches a certain lvl
]]

version = ""

-- Constants
ANIMATION_WAIT_TIME = 1
FILE_PATH = "game/data"

defaultPet = { 	name = "defaultName", 
				type = "Dog", 
				status = "alive", 
				level = 1, 
				rarecandy = 0, 
				exp = 0, 
				health = 100, 
				fun = 60, 
				energy = 80, 
				love = 50, 
				food = 80, 
				limit = { 
					exp = 100, 
					health = 100, 
					fun = 100, 
					energy = 100, 
					love = 100, 
					food = 100 
				} 
			}
defualtTypes = { "Dog", "Cat", "Fox" }

local function deceasedPet ()
	local leftStart = 24
	local yStart = 3
	
		--[[
           _______
          /______ \
         |       \ |
         | R.I.P | |
         |       | |
         |       | |
         |       | |
         |       | |
         |       | |
        ^ ^^^^^ ^^^^^^
		 ]]
	
	term.setCursorPos(leftStart,yStart)
	write("           _______    ")
	term.setCursorPos(leftStart,yStart+1)
	write("          /______ \\  ")
	term.setCursorPos(leftStart,yStart+2)
	write("         |       \\ | ")
	term.setCursorPos(leftStart,yStart+3)
	write("         | R.I.P | |  ")
	term.setCursorPos(leftStart,yStart+4)
	write("         |       | |  ")
	term.setCursorPos(leftStart,yStart+5)
	write("         |       | |  ")
	term.setCursorPos(leftStart,yStart+6)
	write("         |       | |  ")
	term.setCursorPos(leftStart,yStart+7)
	write("         |       | |  ")
	term.setCursorPos(leftStart,yStart+8)
	write("         |       | |  ")
	term.setCursorPos(leftStart,yStart+9)
	write("        ^ ^^^^^ ^^^^^^")
end

local function foxDefault ()
	local leftStart = 20
	local yStart = 1

	--[[
        ,-.      .-,
        |-.\ __ /.-|
        \ _'    _  /
        / _'q  p _ \
        '._=/  \=_.'
          {'\()/'}'\
          {      }  \
          \ '--'  .- \
          |-      /   \
        .-"";` .;...__ `|
       /    |           /
       `-../____,..---'`
]]
	
	term.setCursorPos(leftStart,yStart)
	write("        ,-.      .-,")
	term.setCursorPos(leftStart,yStart+1)
	write("        |-.\\ __ /.-|")
	term.setCursorPos(leftStart,yStart+2)
	write("        \\ _     _  /")
	term.setCursorPos(leftStart,yStart+3)
	write("        / _ q  p _ \\")
	term.setCursorPos(leftStart,yStart+4)
	write("        '._=/  \\=_. ")
	term.setCursorPos(leftStart,yStart+5)
	write("          {'\\()/'}'\\")
	term.setCursorPos(leftStart,yStart+6)
	write("          {      }  \\")
	term.setCursorPos(leftStart,yStart+7)
	write("          \\ '--'  .- \\")
	term.setCursorPos(leftStart,yStart+8)
	write("          |-      /   \\")
	term.setCursorPos(leftStart,yStart+9)
	write("        .-\"\";' .;...__ '")
	term.setCursorPos(leftStart,yStart+10)
	write("       /    |          /")
	term.setCursorPos(leftStart,yStart+11)
	write("       '-../____,..---' ")
end

local function writeOut ( xStart, yStart, stringOut )

end

local function foxAnimation ()
	local leftStart = 20
	local yStart = 1	
	
	while true do
		if pet.status == "sleeping" then
			foxDefault()
			term.setCursorPos(leftStart,yStart+3)
			write("        / _ -  - _ \\")
		
			
			term.setCursorPos(leftStart+23,yStart+2)
			write("       ")
			term.setCursorPos(leftStart+22,yStart+3)
			write("       ")
			term.setCursorPos(leftStart+21,yStart+4)
			write("       ")
			term.setCursorPos(leftStart+23,yStart+2)
			write("Z")
			term.setCursorPos(leftStart+22,yStart+3)
			write("z")
			term.setCursorPos(leftStart+21,yStart+4)
			write("z")
			sleep( ANIMATION_WAIT_TIME )
			if pet.status == "none" then
			else
				foxDefault()
				term.setCursorPos(leftStart,yStart+3)
				write("        / _ -  - _ \\")	
			
				
				term.setCursorPos(leftStart+23,yStart+2)
				write("       ")
				term.setCursorPos(leftStart+22,yStart+3)
				write("       ")
				term.setCursorPos(leftStart+21,yStart+4)
				write("       ")
				term.setCursorPos(leftStart+25,yStart+2)
				write("Z")
				term.setCursorPos(leftStart+23,yStart+3)
				write("z")
				term.setCursorPos(leftStart+21,yStart+4)
				write("z")
				sleep( ANIMATION_WAIT_TIME )
			end
		elseif pet.status == "deceased" then
			deceasedPet ()
			sleep ( ANIMATION_WAIT_TIME )
		elseif pet.status == "none" then
			sleep ( ANIMATION_WAIT_TIME )
		else -- Idle animation
			foxDefault()

			term.setCursorPos(leftStart,yStart+9)
			write("        .-\"\";' .;...__ '")
			term.setCursorPos(leftStart,yStart+10)
			write("       /    |          /")
			term.setCursorPos(leftStart,yStart+11)
			write("       '-../____,..---' ")
			
			
			
			sleep( ANIMATION_WAIT_TIME )
			if pet.status == "none" then
			else
				foxDefault()

				
				
				
				term.setCursorPos(leftStart,yStart+9)
				write("        .-\"\";' .;...__ '")
				term.setCursorPos(leftStart,yStart+10)
				write("       /    |          /")
				term.setCursorPos(leftStart,yStart+11)
				write("       '-../____,..---' ")
				
				sleep( ANIMATION_WAIT_TIME )
			end
		end
	end
	
	
end

local function catDefault()
	local leftStart = 24
	local yStart = 4
	
		--[[
            |\___/|
           =) ^Y^ (=
            \  ^  /
             )=*=(
            /     \
            |     |
           /| | | |\
           \| | |_|/\
           //_// ___/
               \_)
		 ]]
	
	term.setCursorPos(leftStart,yStart)
	write("         |\\___/|   ")
	term.setCursorPos(leftStart,yStart+1)
	write("        =) ^v^ (=   ")
	term.setCursorPos(leftStart,yStart+2)
	write("         \\  ^  /   ")
	term.setCursorPos(leftStart,yStart+3)
	write("          )=*=(     ")
	term.setCursorPos(leftStart,yStart+4)
	write("         /     \\   ")
	term.setCursorPos(leftStart,yStart+5)
	write("         |     |    ")
	term.setCursorPos(leftStart,yStart+6)
	write("        /| | | |\\  ")
	term.setCursorPos(leftStart,yStart+7)
	write("        \\| | |_|/\\")
	term.setCursorPos(leftStart,yStart+8)
	write("        //_// ___/  ")
	term.setCursorPos(leftStart,yStart+9)
	write("            \\_)    ")
end

local function catAnimation ()
	local leftStart = 24
	local yStart = 4
	
	while true do
		if pet.status == "sleeping" then
			term.setCursorPos(leftStart,yStart+5)
			write("   |\\      __,,---,,_      ")
			term.setCursorPos(leftStart,yStart+6)
			write("   /,\\.-- '    -.  ;-;;,_  ")
			term.setCursorPos(leftStart,yStart+7)
			write("  |,4-_ ) )-,_. ,\\ (   '-' ")
			term.setCursorPos(leftStart,yStart+8)
			write(" '---' (_/--'  \\-'\\_)     ")
			
			term.setCursorPos(leftStart+10,yStart+2)
			write("       ")
			term.setCursorPos(leftStart+9,yStart+3)
			write("       ")
			term.setCursorPos(leftStart+8,yStart+4)
			write("       ")
			term.setCursorPos(leftStart+10,yStart+2)
			write("Z")
			term.setCursorPos(leftStart+9,yStart+3)
			write("z")
			term.setCursorPos(leftStart+8,yStart+4)
			write("z")
			sleep( ANIMATION_WAIT_TIME )
			if pet.status == "none" then
			else
				term.setCursorPos(leftStart,yStart+5)
				write("   |\\      __,,---,,_      ")
				term.setCursorPos(leftStart,yStart+6)
				write("   /,\\.-- '    -.  ;-;;,_  ")
				term.setCursorPos(leftStart,yStart+7)
				write("  |,4-_ ) )-,_. ,\\ (   '-' ")
				term.setCursorPos(leftStart,yStart+8)
				write(" '---' (_/--'  \\-'\\_)     ")
				
				term.setCursorPos(leftStart+10,yStart+2)
				write("       ")
				term.setCursorPos(leftStart+9,yStart+3)
				write("       ")
				term.setCursorPos(leftStart+8,yStart+4)
				write("       ")
				term.setCursorPos(leftStart+12,yStart+2)
				write("Z")
				term.setCursorPos(leftStart+10,yStart+3)
				write("z")
				term.setCursorPos(leftStart+8,yStart+4)
				write("z")
				sleep( ANIMATION_WAIT_TIME )
			end
		elseif pet.status == "deceased" then
			deceasedPet ()
			sleep ( ANIMATION_WAIT_TIME )
		elseif pet.status == "none" then
			sleep ( ANIMATION_WAIT_TIME )
		else -- Idle animation
			catDefault()
			term.setCursorPos(leftStart,yStart+9)
			write("            \\_)    ")
			sleep( ANIMATION_WAIT_TIME )
			if pet.status == "none" then
			else
				catDefault()
				term.setCursorPos(leftStart,yStart+9)
				write("           (_/    ")
				sleep( ANIMATION_WAIT_TIME )
			end
		end
	end
end

local function dogDefault()
	local leftStart = 24
	local yStart = 4
	
		--[[
		/|_/|
	   / ^ ^(_o
	  /    __.'
	  /     \
	 (_) (_) '._
	   '.__     '. .-''-'.
		  ( '.   ('.____.''
		  _) )'_, )
		 (__/ (__/
		 ]]
	
	term.setCursorPos(leftStart,yStart)
	write("    /|_/|               ")
	term.setCursorPos(leftStart,yStart+1)
	write("   /    (_o             ")
	term.setCursorPos(leftStart,yStart+2)
	write("  /    __.'             ")
	term.setCursorPos(leftStart,yStart+3)
	write("  /     \\              ")
	term.setCursorPos(leftStart,yStart+4)
	write(" (_) (_) '._            ")
	term.setCursorPos(leftStart,yStart+5)
	write("   '.__     '. .-''-'.  ")
	term.setCursorPos(leftStart,yStart+6)
	write("      ( '.   ('.____.'' ")
	term.setCursorPos(leftStart,yStart+7)
	write("      _) )'_, )         ")
	term.setCursorPos(leftStart,yStart+8)
	write("     (__/ (__/          ")
end

local function dogAnimation ()
	local leftStart = 24
	local yStart = 4
	
	while true do
		if pet.status == "sleeping" then
			dogDefault()
			term.setCursorPos(leftStart+5,yStart+1)
			write("- -")
			term.setCursorPos(leftStart+13,yStart)
			write("       ")
			term.setCursorPos(leftStart+12,yStart+1)
			write("       ")
			term.setCursorPos(leftStart+11,yStart+2)
			write("       ")
			term.setCursorPos(leftStart+13,yStart)
			write("Z")
			term.setCursorPos(leftStart+12,yStart+1)
			write("z")
			term.setCursorPos(leftStart+11,yStart+2)
			write("z")
			sleep( ANIMATION_WAIT_TIME )
			if pet.status == "none" then
			else
				dogDefault()
				term.setCursorPos(leftStart+5,yStart+1)
				write("- -")
				term.setCursorPos(leftStart+13,yStart)
				write("       ")
				term.setCursorPos(leftStart+12,yStart+1)
				write("       ")
				term.setCursorPos(leftStart+11,yStart+2)
				write("       ")
				term.setCursorPos(leftStart+15,yStart)
				write("Z")
				term.setCursorPos(leftStart+13,yStart+1)
				write("z")
				term.setCursorPos(leftStart+11,yStart+2)
				write("z")
				sleep( ANIMATION_WAIT_TIME )
			end
		elseif pet.status == "deceased" then
			deceasedPet ()
			sleep ( ANIMATION_WAIT_TIME )
		elseif pet.status == "none" then
			sleep ( ANIMATION_WAIT_TIME )
		else -- Idle animation
			dogDefault()
			term.setCursorPos(leftStart+5,yStart+1)
			write("^ ^")
			term.setCursorPos(leftStart,yStart+4)
			write(" (_) (_)")
			term.setCursorPos(leftStart,yStart+5)
			write("   '.__ ")
			term.setCursorPos(leftStart+14,yStart+4)
			write("       ")
			term.setCursorPos(leftStart,yStart+5)
			write("   '.__     '. .-''-'.  ")
			term.setCursorPos(leftStart,yStart+6)
			write("      ( '.   ('.____.''")
			sleep( ANIMATION_WAIT_TIME )
			if pet.status == "none" then
			else
				dogDefault()
				term.setCursorPos(leftStart+5,yStart+1)
				write("^ ^")
				term.setCursorPos(leftStart,yStart+4)
				write("  /     ")
				term.setCursorPos(leftStart,yStart+5)
				write(" (_) (_)")
				term.setCursorPos(leftStart+14,yStart+4)
				write(".-''-'.")
				term.setCursorPos(leftStart+13,yStart+5)
				write(".'.____.' ")
				term.setCursorPos(leftStart,yStart+6)
				write("      ( '.   (          ")
				sleep( ANIMATION_WAIT_TIME )
			end
		end
	end
end

function defaultPet:changeName ( value )
	if string.len( value) > 15 then
		value = string.sub(value, 0, 15)
	end
	self.name = value
end

function defaultPet:addToLimit ( property, value )
	self["limit"][property] = self["limit"][property] + value
	self[property] = self[property] + value
end

function defaultPet:checkLevel ()
	if self.exp > self["limit"]["exp"] then
		self.level = self.level + 1
		self.rarecandy = self.rarecandy + 1
		self["limit"]["exp"] = math.floor(self["limit"]["exp"] * 1.1)
		self.exp = self["limit"]["exp"] - self.exp
	end
end

function defaultPet:setLimit ( property, value )
	self["limit"][property] = value
end

function defaultPet:addExp ( value )
	if self.love > 90 then
		self.exp = self.exp + ( math.floor( value * (pet["limit"]["love"]/100 ) ) )
	else
		self.exp = self.exp + value
	end
	self:checkLevel()
end

function defaultPet:addValue ( property, value )
	if property == "love" then
		if self.love + value > 80 and self.fun < 60 or self.health < 50 then
			self.love = 80
		else
			if self[property] + value > self["limit"][property] then
				self[property] = self["limit"][property]
			end
			self[property] = self[property] + value
		end
	else
		if self[property] + value > self["limit"][property] then
			self[property] = self["limit"][property]
		end
		self[property] = self[property] + value
	end
end

function defaultPet:subValue ( property, value )
	if value > self[property] then
		self[property] = 0
	end
	self[property] = self[property] - value
end

function defaultPet:new (o)
	setmetatable (o, { __index = defaultPet })
	return o
end

pet = defaultPet:new({})
----------------------------------------------------
------------------End of Pet Class------------------
----------------------------------------------------

local function debug ( tTable )
	for i, v in pairs( tTable ) do
		print(i .. ": " .. v)
	end
end

local function input(xInitial, yInitial)
	local event, param1, text = nil
	while true do
		event, param1 = os.pullEvent()
		term.setCursorPos(xInitial, yInitial)
		if event == "char" then
			if not text then
				text = param1
			else
				text = (text..param1)
			end

			write(text)
		elseif event == "key" and param1 == 28 and text ~= nil then --Enter Key
			return(text)
		elseif event == "key" and param1 == 14 and text ~= nil then --Backspace
			text = string.sub(text, 1, string.len(text) - 1)
			term.setCursorPos(xInitial + string.len(text), yInitial)
			write(" ")
		end
	end
end

local KEY = 5

local function writeBinary( dataString )
	local data = ""
	local dataLine = ""
	local cData
	local file = fs.open( FILE_PATH, "a" )

	for i=1, #dataString do
		cData = ( string.byte( string.sub(dataString, i, i) )+KEY )
		dataLine = dataLine..string.char( cData )
	end
  
	if file then
		file.writeLine( dataLine )
		file.close()
	else
		print( "Could not open file!" )
	end
end

local function saveGameData( pet )
	local file
	local data = ""
	
	if not fs.exists( "/game" ) then
		fs.makeDir( "/game" )
	end
	
	file = fs.open( FILE_PATH, "w" )
	file.close()
	
	for i, v in pairs( pet ) do
		--if i == "limit" then
		--	for j, k in pairs( v ) do
		--		file.writeLine( "limit,"..j..":"..k )
		--	end
		--else
			writeBinary( i..":"..v )
		--end
	end

	writeBinary("*exp:"..pet["limit"]["exp"])
	writeBinary("*health:"..pet["limit"]["health"])
	writeBinary("*energy:"..pet["limit"]["energy"])
	writeBinary("*food:"..pet["limit"]["food"])
	writeBinary("*fun:"..pet["limit"]["fun"])
	writeBinary("*love:"..pet["limit"]["love"])
	
end

local function readBinary ( file )
	local data = ""
	local dataLine = ""
	local byte
	
	dataLine = file.readLine()
	
	if dataLine ~= nil then
		for i=1, #dataLine do
			byte = string.byte( string.sub(dataLine, i, i) )-KEY
			data = data..string.char( byte )
		end
	end

	return data
end

local function loadGameData() 
	local file
	local index = 0
	local data = ""
	local dataType = ""
	
	if not fs.exists( FILE_PATH ) then
		file = fs.open( FILE_PATH )
		file.close()
	end

	file = fs.open ( FILE_PATH, "r" )
	data = readBinary ( file )

	while data ~= nil do 
		if data == "" then 
			break
		end
		dataType = string.sub( data, 0, 1 )
		if dataType == "*" then
			index = string.find( data, ":" )
			dataType = string.sub( data, 0, index-1)
			if dataType == "*exp" then
				pet:setLimit( "exp", tonumber( string.sub( data, index+1, string.len( data ) ) ) )
			elseif dataType == "*health" then
				pet:setLimit( "health", tonumber( string.sub( data, index+1, string.len( data ) ) ) )
			elseif dataType == "*energy" then
				pet:setLimit( "energy", tonumber( string.sub( data, index+1, string.len( data ) ) ) )
			elseif dataType == "*food" then
				pet:setLimit( "food", tonumber( string.sub( data, index+1, string.len( data ) ) ) )
			elseif dataType == "*fun" then
				pet:setLimit( "fun", tonumber( string.sub( data, index+1, string.len( data ) ) ) )
			elseif dataType == "*love" then
				pet:setLimit( "love", tonumber( string.sub( data, index+1, string.len( data ) ) ) )
			end
		else
			index = string.find( data, ":" )
			dataType = string.sub( data, 0, index-1)
			if dataType == "name" or dataType == "type" or dataType == "status" then			
				pet[dataType] = string.sub( data, index+1, string.len( data ) )
			else
				pet[dataType] = tonumber( string.sub( data, index+1, string.len( data ) ) )
			end
		end
		data = readBinary ( file )
	end
	file.close()
end

local function menuDisplay ()
	term.setCursorPos(1,13)
	write("==================================================")
	term.setCursorPos(1,15)
	write("C - Change Name   L - Play    P - Pet    F - Feed")
	term.setCursorPos(7,16)
	write("U - Upgrade Stats      E - Exit")
	term.setCursorPos(1,16)
	write("==================================================")
end

local function header()
	local xStart = 1
	local yStart = 1

	term.setCursorPos(xStart,yStart)
	write("  .-------------------------------------------.    ")
	term.setCursorPos(xStart,yStart+1)
	write(" /  .-.                                   .-.  \\  ")
	term.setCursorPos(xStart,yStart+2)
	write("|  /   \\     My Little                   /   \\  |")
	term.setCursorPos(xStart,yStart+3)
	write("|\\|  | /|           ComputerCraft       |\\  | |/|")
	term.setCursorPos(xStart,yStart+4)
	write("| \\---' |                       Pet     | \\---' | ")
	term.setCursorPos(xStart,yStart+5)
	write(" \\     / ------------------------------- \\     / ")
	term.setCursorPos(xStart,yStart+6)
	write("  \\---'                                   \\---'   ")
--[[
  .--------------------------------------------------------.
 /  .-.                                                .-.  \
|  /   \      My Little                               /   \  |
|\|  | /|            ComputerCraft                   |\  | |/|
| `---' |                        Pet                 | `---' |
 \     / -------------------------------------------- \     /
  `---'                                                `---'
  ]]

end

local function border ()
	local leftStart = 1
	local rightStart = 41

	for i=1,20,4 do
		term.setCursorPos(leftStart,i)
		write("( ( / /  ")
		term.setCursorPos(leftStart,i+1)
		write(" \\ \\ / \\ ")
		term.setCursorPos(leftStart,i+2)
		write("  \\ \\') )")
		term.setCursorPos(leftStart,i+3)
		write(" / \\ / / ")
		
		term.setCursorPos(rightStart,i)
		write("( ( / /  ")
		term.setCursorPos(rightStart,i+1)
		write(" \\ \\ / \\ ")
		term.setCursorPos(rightStart,i+2)
		write("  \\ \\') )")
		term.setCursorPos(rightStart,i+3)
		write(" / \\ / / ")
	end
end

local function menuSelect (tTable)
	local keyboardCursor = 1
	local menuStart = 10
	local xStart = 14
	local count = 1

	for i, v in pairs( tTable ) do
		term.setCursorPos(xStart, menuStart + count)
		write("  "..v)
		count = count + 1
	end
	
	while true do
		term.setCursorPos(xStart, menuStart + keyboardCursor)
		print(">")
		
		local event, button, X, Y = os.pullEvent("key")
	
		if button == 200 and keyboardCursor ~= 1 then --up
			term.setCursorPos(xStart , menuStart + keyboardCursor)
			print(" ")
			term.setCursorPos(xStart, (menuStart - 1) + keyboardCursor)
			print(">")
			keyboardCursor = keyboardCursor - 1
		elseif button == 208 and keyboardCursor ~= #tTable then --down
			term.setCursorPos(xStart , menuStart + keyboardCursor)
			print(" ")
			term.setCursorPos(xStart, (menuStart + 1) + keyboardCursor)
			print(">")
			keyboardCursor = keyboardCursor + 1
		elseif button == 28 then --enter

			return tTable[keyboardCursor]

		elseif button == 53 then -- user pressed ?, return to the main menu
			return "53"
		end
	end
end

local function statbar ( property, pet )
	local sStat = ""
	local number = 0
	
	number = math.floor((pet[property] / pet.limit[property]) * 10)
	
	if number > 10 then
		number = 10
	end
	
	if number > 0 then
		for i=1,number do
			sStat = "#"..sStat
		end
	end
	
	return sStat
end

local function currentStats ( pet )
	local statBars

	term.setCursorPos(1,5)
	write("Pet Name: "..pet.name)
	term.setCursorPos(1,6)
	write(" ("..pet.level.." lvl)")
	if pet.health < 1 then
		write(" - deceased")
	end
	term.setCursorPos(1,7)
	statBars = statbar ( "health", pet )
	write("Health:"..statBars)
	term.setCursorPos(1,8)
	statBars = statbar ( "energy", pet )
	write("Energy:"..statBars)
	term.setCursorPos(1,9)
	statBars = statbar ( "food", pet )
	write("Hunger:"..statBars)
	term.setCursorPos(1,10)
	statBars = statbar ( "fun", pet )
	write("Fun:   "..statBars)
	term.setCursorPos(1,11)
	statBars = statbar ( "love", pet )
	write("Love:  "..statBars)
	term.setCursorPos(1,12)
	statBars = statbar ( "exp", pet )
	write("Exp:   "..statBars)
end

local function changeName ()
	local sNewName = ""
	
	term.clear()
	border()
	term.setCursorPos(17,6)
	write("Please enter your")
	term.setCursorPos(20,7)
	write("pet's name:")

	while string.len( sNewName ) < 3 do 
		sNewName = input(22, 8)
	end
	
	return sNewName
end

local function updateStats ()
	local tStats = {}
	local tIndex = { "health", "energy", "food", "fun", "love" }
	local index = 0
	local selection = ""
	
	while true do
		tStats = { 
			"Health      ("..(pet["limit"]["health"]/10-10)..")", 
			"Energy      ("..(pet["limit"]["energy"]/10-10)..")", 
			"Better Food ("..(pet["limit"]["food"]/10-10)..")", 
			"Buy Toys    ("..(pet["limit"]["fun"]/10-10)..")", 
			"Exp Boost   ("..(pet["limit"]["love"]/10-10)..")" 
		}
		
		term.clear()
		border()
		term.setCursorPos(14, 5)
		write("Which stats would you")
		term.setCursorPos(14,6)
		write("like to upgrade?")
		term.setCursorPos(10,8)
		write("Number of upgradable stats: "..pet.rarecandy)
		term.setCursorPos(14,17)
		write("Press \"?\" to return")
		
		selection = menuSelect( tStats )
		
		if selection == "53" then
			break
		end
		
		for i=1,#tStats do
			if selection == tStats[i] and pet.rarecandy > 0 then
				pet:addToLimit ( tIndex[i], 10 )
				pet.rarecandy = pet.rarecandy - 1
			end
		end
		selection = ""
	end
end

local function isDeceased ()
	if pet.status == "deceased" then
		return true
	else
		return false
	end
end

local function isNone ()
	if pet.status == "none" then
		return true
	else
		return false
	end
end

local function animation ()
	if pet.type == "Dog" then
		while true do
			if not isNone() then
				dogAnimation ()
			end
			sleep ( 0 )
		end
	elseif pet.type == "Cat" then
		while true do
			if not isNone() then
				catAnimation ()
			end
			sleep ( 0 )
		end
	elseif pet.type == "Fox" then
		while true do
			if not isNone() then
				foxAnimation ()
			end
			sleep ( 0 )
		end
	end
end

local function atrophy()
	local ATROPHY_TIME = 30

	while true do
		sleep( ATROPHY_TIME )
		if not isDeceased() and not isNone() then
			pet:addValue ( "energy", 5 )
			pet:subValue ( "fun", 5 )
			pet:subValue ( "love", 2 )
			pet:subValue ( "food", 4 )
			if pet.food < 5 then
				pet:subValue ( "health", 5 )
				pet:subValue ( "love", 5 )
			elseif pet.food > 80 then
				pet:addValue ( "health", 10 )
			end
			if pet.health < 1 then
				pet.status = "deceased"
			elseif pet.energy < 30 then
				pet.status = "sleeping"
			else 
				pet.status = "idle"
			end
			
			term.clear()
			menuDisplay()
			currentStats ( pet )
			saveGameData( pet )
		end
	end
end

local function mainInput()
	local status = ""
	while true do
		event, param1, message = os.pullEvent("char")
		if tostring(param1) == "c" and not isDeceased() then		-- change name
			status = pet.status
			pet.status = "none"
			name = changeName()
			pet:changeName( name )
			pet.status = status
			term.clear()
			menuDisplay()
			currentStats ( pet )
		elseif tostring(param1) == "l" and not isDeceased() then	-- play
			if pet.energy > 20 then
				pet:subValue ( "energy", 5 )
				pet:addValue ( "fun", 10 )
				pet:addValue ( "love", 2 )
				pet:addExp( 20 )
			end
			term.clear()
			menuDisplay()
			currentStats ( pet )	
		elseif tostring(param1) == "p" and not isDeceased() then	-- pet
			if pet.energy > 0 then
				pet:subValue ( "energy", 3 )
				pet:addValue ( "love", 5 )
				pet:addExp( 15 )
			end
			term.clear()
			menuDisplay()
			currentStats ( pet )	
		elseif tostring(param1) == "f" and not isDeceased() then	-- feed
			if pet.food < pet["limit"]["food"] then
				pet:addValue ( "energy", 5 )
				pet:addValue ( "love", 3 )
				pet:addValue ( "food", 10 )
				pet:addExp( 5 )
			end
			term.clear()
			menuDisplay()
			currentStats ( pet )
		elseif tostring(param1) == "u" then	-- upgrade
			status = pet.status
			pet.status = "none"
			updateStats ()
			pet.status = status
			term.clear()
			menuDisplay()
			currentStats ( pet )
		elseif tostring(param1) == "e" then	-- exit
			term.clear()
			term.setCursorPos(1,1)
			return
		end
		if not isDeceased() then
			pet.status = "idle"
			saveGameData( pet )
		else
			fs.delete( "/game" )
		end
	end
end






-- Main
local name = ""
local selection
local parallelStatus = 0

table.insert(pet, limit)
if fs.exists("/game/data") then
	loadGameData()
else
	term.clear()
	border ()
	header()
	term.setCursorPos(17, 8)
	write("Which type of pet")
	term.setCursorPos(18, 9)
	write("would you like?")
	
	repeat
		pet.type = menuSelect (defualtTypes)
	until pet.type ~= "53"
		
	while string.len(name) < 3 do
		term.clear()
		border()
		header()
		term.setCursorPos(12,8)
		write("Enter your new pet's name: ")
		name = input(22, 9)
	end
	pet:changeName( name )
	saveGameData( pet )
end

term.clear()
menuDisplay()
currentStats ( pet )

while true do
	parallelStatus = parallel.waitForAny(mainInput, atrophy, animation)

	if parallelStatus == 1 then
		return
	end
	
	sleep( 1 )
end

