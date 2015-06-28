
Nov. 12
Added transition.cancel() to level.lua destroy() function.
Added "toStart" scene. This is a scene to go to before going back to start scene. It will allow us to remove the level scene therefore everything will be cleaned up properly. 


Do we need a globals file?


--Use this to print out whats in the table in question
for k,v in pairs( <table name> ) do
   print( k .. " => ", v )
end