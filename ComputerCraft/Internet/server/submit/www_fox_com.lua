local items = {}
local prices = {}

local listStart = 5
local param1 = 0
term.clear()
term.setCursorPos(13,1)
textutils.slowWrite("Welcome to AirsoftingFox's")
term.setCursorPos(20,2)
textutils.slowWrite("Online shop!")
term.setCursorPos(3,4)
print("Here are some popular items sold in my shop")
term.setCursorPos(15,5)
print("located at /warp shop")

for i=1,#items do
	term.setCursorPos(2,i + listStart)
	print(items[i])
	term.setCursorPos(27,i + listStart)
	print("$"..prices[i])
end

while param1 ~= 28 do
	event, param1 = os.pullEvent()
end
return
