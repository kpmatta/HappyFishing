--[[=========================================================================
	Authors: Krishna Matta, Brandon Fields
	Date: Oct 18, 2014

	CS 596 - Final Project [ Happy Fising ]
	UAH - Huntsville

	Summary:
		Display the actual game scene. this is jest wrapper to the level object.
		Calls equivalent level object methods 
		
============================================================================]]

local composer = require( "composer");

-- get common level object
local level = require("level");

local scene = composer.newScene();

-----------------------------------------------------------------------
-- inital scene create event
-----------------------------------------------------------------------
function scene:create( event )
	
	-- call level object to create scene
	level:create(event, self);

end

-----------------------------------------------------------------
-- scene:show event
-----------------------------------------------------------------
function scene:show( event )

	-- call common level show
	level:show(event, self);

end

-----------------------------------------------------------------
-- 
-----------------------------------------------------------------
function scene:destroy( event )

	level:destroy(event, self);

end

-----------------------------------------------------------------
-- 
-----------------------------------------------------------------
function scene:resumeGame()

	-- call resume method
	level:resumeGame();

end

-----------------------------------------------------------------
-- 
-----------------------------------------------------------------
function scene:reloadlevel()

	-- call reload level method
	level:reloadLevel();

end

-----------------------------------------------------------------
-- 
-----------------------------------------------------------------
function scene:goToStart()

	-- call goto start method
	level:goToStart();

end

-----------------------------------------------------------------
-- 
-----------------------------------------------------------------
function scene:nextLevel()

	-- call next level method
	level:nextLevel();

end

-----------------------------------------------------------------------
-- scene event listeners
-----------------------------------------------------------------------
scene:addEventListener( "create", scene );
scene:addEventListener( "show", scene );
scene:addEventListener( "hide", scene );
scene:addEventListener( "destroy", scene );

-- Return scene object.
return scene;