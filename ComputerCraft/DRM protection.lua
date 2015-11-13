--[[ Made by AirsoftingFox. Please do not redistribute as your own ]]

local args = { ... }
local program = {}

if #args <1 then
  print ("Usage:")
  print("")
  print("drm <<program name>>")
  return
  elseif #args > 2 then
  print ("Usage:")
  print("")
  print("drm <<program name>>")
  return
end

local function SetupDRM()
	local newHash = nil
	local key = os.getComputerID()

	if not fs.exists("/userconfig") then 
		fs.makeDir("/userconfig")
	end
	if not fs.exists("/userconfig/DRM") then
		local file = fs.open("/userconfig/DRM","w") --creates the "DRM" file if one does not exist
		newHash = math.abs(math.random(1111111, 9999999))
		file.writeLine(newHash)
		
		for i=1,string.len(newHash) do
			file.writeLine(bit.bxor(string.byte(newHash,i), key))
		end
		file.close()
	end
end

--main
local file
local program
local programName = args[1]

if fs.exists("/" .. programName) then
	SetupDRM()
	file = fs.open("/"..programName,"r")
	program = file.readAll()
	file.close()
	file = fs.open("/"..programName,"w")
	file.writeLine("if not fs.exists(\"/userconfig/DRM\") then")
	file.writeLine("term.clear()")
	file.writeLine("print(\"Error, this program can only be installed once\")")
	file.writeLine("return")
	file.writeLine("end")
	file.writeLine("")
	file.writeLine("local file = fs.open(\"/userconfig/DRM\",\"r\")")
	file.writeLine("local id = os.getComputerID()")
	file.writeLine("local drmHash = file.readLine()")
	file.writeLine("local line = nil")
	file.writeLine("for i=1,string.len(drmHash) do")
	file.writeLine("line = file.readLine()")
	file.writeLine("if tonumber(line) ~= bit.bxor(string.byte(drmHash,i), id) then")
	file.writeLine("term.clear()")
	file.writeLine("print(\"Error, this program can only be installed once\")")
	file.writeLine("file.close()")
	file.writeLine("return")
	file.writeLine("end")
	file.writeLine("end")
	file.writeLine("file.close()")
	file.writeLine("")

	file.write(program)
	file.close()
	
else
	term.clear()
	print ("")
	print ("Error, program " .. programName .. " cannot be found")
	return
end