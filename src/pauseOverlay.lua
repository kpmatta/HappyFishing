--[[=========================================================================
	Authors: Krishna Matta, Brandon Fields
	Date: Oct 18, 2014

	CS 596 - Final Project [ Happy Fising ]
	UAH - Huntsville

	Summary:
		Displays pause overlay scene
============================================================================]]

local widget = require( "widget" );
local composer = require( "composer");
local spriteSheetOptionsButtons = require("buttonTable");

local scene = composer.newScene();

local dX = display.contentCenterX;
local dY = display.contentCenterY;
local scrWidth = display.contentWidth
local scrHeight = display.contentHeight


local buttonId = "";

local function buttonHandler(event)

	if ( event.phase == "ended") then

		-- get current selected button id
		buttonId = event.target.id;

		composer.hideOverlay("fade", 400);			

	end

end

-----------------------------------------------------------------------
-- inital scene create event
-----------------------------------------------------------------------
function scene:create( event )
	local sceneGroup = self.view;
 
 	local params = event.params;

	-- load buttons
	local spriteSheetButtons =  graphics.newImageSheet("button_sprite.png", spriteSheetOptionsButtons);

 	--create overlay background
	local overlay = display.newRoundedRect(dX, dY,scrWidth*0.8, scrHeight*0.8, 10)
	overlay.alpha = 0.8
	overlay:setFillColor(black)
		
	--add overlay image to scene group
	sceneGroup:insert (overlay)

	-- Create first multi-line text object
	local txtOptions = 
	{
	    text = params.msg,
	    x = dX,
	    y = dY,
	    width = overlay.width,     --required for multi-line and alignment
	    font = native.systemFontBold,
	    fontSize = 60,
	    align = "center"
	}

	local txtMsg = display.newText( txtOptions );
	txtMsg:toFront( );

	txtMsg:setFillColor(1, 0, 0);
	sceneGroup:insert(txtMsg);

	-- Create level text object
	local txtLevel = display.newText( "Level : "..params.nCurrentLevel, dX,  dY - ((scrHeight*0.8)/2 - 60),
						native.systemFontBold, 60 );
	txtLevel:setFillColor( 0, 1, 0 );
	sceneGroup:insert(txtLevel);

	-- Create score text object
	local txtScore = display.newText( "Score: "..params.nScore.." / "..params.nTargetScore,
						dX, txtLevel.y + 70, native.systemFont, 60 );

	txtScore:setFillColor(0, 1, 0);
	sceneGroup:insert(txtScore);


	-- count number of buttons to be created
	local buttonCount = 0;
	if ( params.restartBtn == 1 ) then
		buttonCount = buttonCount + 1;
	end
	
	if ( params.resumeBtn == 1 ) then
		buttonCount = buttonCount + 1;
	end

	if ( params.homeBtn == 1 ) then
		buttonCount = buttonCount + 1;
	end

	if ( params.nextBtn == 1 ) then
		buttonCount = buttonCount + 1;
	end

	local xOffset = dX - (overlay.width/2);

	if ( buttonCount == 1 ) then 
		xOffset = dX
	end

	--create start screen button widget if required
	if ( params.homeBtn == 1 ) then 

		local buttonHome = widget.newButton
		{
		    x = xOffset,
		    y = dY + overlay.height/2.2,
		    id = "start",
		    sheet = spriteSheetButtons,
		    defaultFrame = 1,
		    overFrame = 2,
		    onEvent = buttonHandler,
		}
		sceneGroup:insert (buttonHome);

		-- calculate the next button offset 
		xOffset = xOffset + ( overlay.width / (buttonCount-1) );

	end
	
 	--create restart button widget if required
	if ( params.restartBtn == 1 ) then 

		local buttonRestart = widget.newButton
		{
		    x = xOffset, 
		    y = dY + overlay.height/2.2,
		    id = "restart",
		    sheet = spriteSheetButtons,
		    defaultFrame = 7,
		    overFrame = 8,
		    onEvent = buttonHandler,
		}

		sceneGroup:insert(buttonRestart);
		xOffset = xOffset + ( overlay.width / (buttonCount-1) );
	end


 	--create resume button widget if required
 	if ( params.resumeBtn == 1 ) then 

		local buttonResume = widget.newButton
		{
		    x = xOffset,
		    y = dY + overlay.height/2.2,
		    id = "resume",
		    sheet = spriteSheetButtons,
		    defaultFrame = 3,
		    overFrame = 4,
		    onEvent = buttonHandler,
		}
		sceneGroup:insert(buttonResume);
		xOffset = xOffset + ( overlay.width / (buttonCount-1) );
	end

	-- create the next button if required
	if ( params.nextBtn == 1 ) then 

		local buttonNext = widget.newButton
		{
		    x = xOffset,
		    y = dY + overlay.height/2.2,
		    id = "next",
		    sheet = spriteSheetButtons,
		    defaultFrame = 9,
		    overFrame = 10,
		    onEvent = buttonHandler,
		}
		sceneGroup:insert (buttonNext);
		xOffset = xOffset + ( overlay.width / (buttonCount-1) );

	end

end

-----------------------------------------------------------------
-- scene:show event
-----------------------------------------------------------------
function scene:show( event )
	--store reference to parent scene
	parent = event.parent;
end

-----------------------------------------------------------------
-- scene:destroy event
-----------------------------------------------------------------
function scene:destroy( event )

end

-----------------------------------------------------------------
-- scene:hide event
-----------------------------------------------------------------
function scene:hide( event )
	
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object

    print("in hide overlay")

    if ( phase == "did" ) then
        
        -- call the appropriate method for each button selection
        if(parent ~= nil) then
       		if ( buttonId == "start") then
       			parent:goToStart();
       			
       		elseif ( buttonId == "resume") then
   				parent:resumeGame();

       		elseif ( buttonId == "restart" ) then
  				parent:reloadlevel();
  			
  			elseif ( buttonId == "next" ) then 
  				parent:nextLevel();
  			end
     	end

      	buttonId = "";
    end
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