--[[=========================================================================
	Authors: Krishna Matta, Brandon Fields
	Date: Nov 22, 2014

	CS 596 - Final Project [ Happy Fising ]
	UAH - Huntsville

	Summary:
		This is scene acts as an intermediate scene to load the same scene again 
		
============================================================================]]

local composer = require( "composer")
local scene = composer.newScene();

-----------------------------------------------------------------------
-- inital scene create event
-----------------------------------------------------------------------
function scene:create( event )
	sceneGroup = self.view;

	-- display the previous scene background to avoid showing the black background 
	local imgBackground = display.newImage( event.params.strBackGround, display.contentCenterX, display.contentCenterY )
	imgBackground:toBack();
	sceneGroup:insert( imgBackground );

end

-----------------------------------------------------------------------
-- Show event
-----------------------------------------------------------------------
function scene:show(event)

	sceneGroup = self.view;

	if ( event.phase == "will") then 


	-- after displayed, go back the level1 (parameters will be updated for each level)
	elseif (event.phase == "did") then

		local options = 
		{
			effect = event.params.effect,
			time = 500,
			params = event.params
		}
        
        -- call the level1 scene
        composer.removeScene("level1");
		composer.gotoScene("level1", options );

	end

end

-----------------------------------------------------------------------
function scene:hide(event)

end

-----------------------------------------------------------------------
function scene:destroy(event)

end
-----------------------------------------------------------------------
-- scene event listeners
-----------------------------------------------------------------------
scene:addEventListener( "create", scene );
scene:addEventListener( "show", scene );
scene:addEventListener( "hide", scene );
scene:addEventListener( "destroy", scene );

return scene;	