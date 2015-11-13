local param1 = 0

term.clear()
term.setCursorPos(1,1)
textutils.slowWrite("Everything is awesome!")
while param1 ~= 28 do
	event, param1 = os.pullEvent()
end
return
