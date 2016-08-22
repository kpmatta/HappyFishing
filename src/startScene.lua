--[[=========================================================================
	Authors: Krishna Matta, Brandon Fields
	Date: Oct 18, 2014

	CS 596 - Final Project [ Happy Fising ]
	UAH - Huntsville

	Summary:
		Display the start up scene with startup background and play options.
		Selecting play leads to next level option for the play.
============================================================================]]


local widget = require( "widget" );
local composer = require( "composer");
local spriteSheetOptionsButtons = require("buttonTable");

local scene = composer.newScene();

local options;
local sceneGroup;

-----------------------------------------------------------------------
-- inital scene create event
-----------------------------------------------------------------------
function scene:create( event )
	sceneGroup = self.view;

	--store scene parameters
	options = event;

end

-----------------------------------------------------------------
-- scene:show event
-----------------------------------------------------------------
function scene:show( event )

	sceneGroup = self.view;

	-- Function to handle start button event
	local function onStartBtnEvent( event )

		-- on button up
	    if ( "ended" == event.phase ) then

	    	-- remove the button
	        event.target:removeSelf( );

	        local options = 
			{
				effect = "slideLeft",
				time = 800,
				params = 
			    {  
			    	nSpearsCnt = 5, 
			    	nTargetScore = 5000,
					strBackGround = "water_back_level1.png",
					nCurrentLevel = 1,
					nNextLevel = 2,
			    }
			}
	        
	        -- call the level1 scene
	        composer.removeScene("level1");
			composer.gotoScene("level1", options );
			
	    end
	end

	-- while showing the scene
	if( event.phase == "will" ) then

		-- load the startup image
		local imgStartup = display.newImage( "startup_bkground_portrait.png", display.contentCenterX, display.contentCenterY );
		sceneGroup:insert(imgStartup);

		-- load button image
		local spriteSheetButtons =  graphics.newImageSheet("button_sprite.png", spriteSheetOptionsButtons);

		--create resume button widget
		local buttonStart = widget.newButton
		{
		    x = display.contentWidth/2,
		    y = display.contentHeight - 150,
		    sheet = spriteSheetButtons,
		    defaultFrame = 3,
		    overFrame = 4,
		    onEvent = onStartBtnEvent,
		}

		sceneGroup:insert(buttonStart);

	end

end

----------------------------------------------------------------------
function scene:destroy( event )

	
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