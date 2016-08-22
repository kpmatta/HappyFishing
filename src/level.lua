


--[[=========================================================================
	Authors: Krishna Matta, Brandon Fields
	Date: Oct 18, 2014

	CS 596 - Final Project [ Happy Fising ]
	UAH - Huntsville

	Summary:
		Common code for the whole game.
		This file implements the level object, which can be called 
		by composer scenes  
		
============================================================================]]
local ads = require( "ads" );
local bannerAppID = "ca-app-pub-9375609238462354/3341307827";
local adProvider = "admob";
local appID = "happyAdd"

local widget = require( "widget" );
local composer = require( "composer");
local physics = require( "physics");
--local math = require("math");

-- get sprite table objects from file
local spriteSheetOptionsImages = require("fishTable");
local spriteSheetOptionsButtons = require("buttonTable");

physics.start();
physics.setGravity( 0, 0 )

--physics.setDrawMode( "hybrid" )

math.randomseed( os.time() )

-- scene width and height
local scrWidth = display.contentWidth;
local scrHeight = display.contentHeight;

-- line to draw, to show the direction and force.
local lineForce = nil;

local colorEmbossed = 
{
    highlight = { r=0, g=0, b=0 },
    shadow = { r=0.3, g=0.3, b=0.3 }
}

-- create background images table
local backgroundImgeTable =
{ 
	"water_back_level1.png",
	"water_back_level2.png", 
};

-- load audio files into a table, don't update the order
-- this order linked to imagedata
local audioTable = {};
audioTable[1] = audio.loadSound( "Applause_Light.mp3" );
audioTable[2] = audio.loadStream( "beep.mp3" );
audioTable[3] = audio.loadStream( "water_flow.mp3" );
audioTable[4] = audio.loadSound( "Bubbles.mp3" );
audioTable[5] = audio.loadSound( "Grenade.mp3" );
audioTable[6] = audio.loadSound( "Water Splash.mp3" );
audioTable[7] = audio.loadSound( "Gun_Silencer.mp3" );
audioTable[8] = audio.loadSound( "ArcticNight.mp3" );
audioTable[9] = audio.loadSound( "HeShallFeed.mp3" );
audioTable[10] = audio.loadSound( "Gurlitte-Novelette.mp3" );


-- initialize the data for sprite images
-- when the image loaded, image will be attached with these attributes
-- this table should match the fishTable.lua
local spriteImgData = 
{
    {score = 1000, tag = "fish", audio = 7 },        -- light orange
    {score = 1500, tag = "fish", audio = 7 },        -- yellow, blue fish
    {score = 2000, tag = "fish", audio = 7 },        -- orange stripe fish
    {score = 1000, tag = "fish", audio = 7 },        -- black fish
    {score = 4000, tag = "fish", audio = 7 },        -- diamond blue fish
    {score = 100, tag = "fish", audio = 7 },         -- crab
    {score = 2000, tag = "fish", audio = 7 },        -- green fish
    {score = 500, tag = "fish", audio = 7 },        -- light orange baloon fish
    {score = 2000, tag = "fish", audio = 7 },        -- very small orange fish
    {score = 1200, tag = "fish", audio = 7 },        -- scarlet, gray cartoon fish
    {score = 1500, tag = "fish", audio = 7 },        -- very small green fish
    {score = 500, tag = "fish", audio = 7 },        -- cyan baloon fish
    {score = 2000, tag = "fish", audio = 7 },         -- small rainbow fish
    {score = 750, tag = "fish", audio = 7 },         -- seahorse
    {score = 1000, tag = "fish", audio = 7 },        -- yellow stripes fish
    {score = -500, tag = "shark", audio = 2 },        -- shark
    {score = 0, tag = "submarine", audio = 2},        -- submarine
    {score = -1000, tag = "bomb", audio = 5},         -- bomb
}

-- initialize level object
local level = { nScore = 0, 
				nSpearsCnt = 0,
				nTargetScore = 0,
				strBackGround = "",
				nCurrentLevel = 0,
				nNextLevel = 0, 
				nSpearBaseRadius = 250,
				nSpearX = display.contentWidth * 0.55;
				nSpearY = display.contentHeight - 250/2;
				nTotalLevels = 10,
				timer1 = nil,
				timer2 = nil,
				timer3 = nil,
				event,
				params };

local function addListener( event )
   -- The 'event' table includes:
    -- event.name: string value of "adsRequest"
    -- event.response: message from the ad provider about the status of this request
    -- event.phase: string value of "loaded", "shown", or "refresh"
    -- event.type: string value of "banner" or "interstitial"
    -- event.isError: boolean true or false
 
   -- local msg = event.response
    -- Quick debug message regarding the response from the library
    --print( "Message from the ads library: ", msg )
 
    --if ( event.isError ) then
    --    print( "Error, no ad received", msg )
    --else
    --    print( "Ah ha! Got one!" )
   -- end
end

ads.init(adProvider, appID, addListener);

-------------------------------------------------------------------------------
-- Distance between two points
-------------------------------------------------------------------------------
local function distance(pt1, pt2)

	return math.sqrt( math.pow( (pt1.x - pt2.x), 2) + 
						math.pow( (pt1.y - pt2.y), 2) );
end


-------------------------------------------------------------------------------
-- returns the degrees between (0,0) and pt
-------------------------------------------------------------------------------
function angleOfPoint( pt )
   
   local radian = math.atan2(pt.y, pt.x)
   
   local angle = radian*180/math.pi
   
   if angle < 0 then 
   		angle = 360 + angle 
   end

   return angle
end

-------------------------------------------------------------------------------
-- returns the degrees between two points (note: 0 degrees is 'east')
-------------------------------------------------------------------------------
function angleOfLine( a, b )
   local _x = b.x - a.x;
   local _y = b.y - a.y;
   local vec = { x = _x, y = _y }

   return angleOfPoint( vec );
end

-----------------------------------------------------------------------------
-- Create pond border
-----------------------------------------------------------------------------
function level:createPond()

	-- create rectangles at four sides of the screen
	-- acts as a main boundary of the game.
	-- tag the object with "wall", set the audio table id for collision sound
	local boxPondLeft = display.newRect( 0, 0, 5, scrHeight );
	boxPondLeft.anchorX = 0;
	boxPondLeft.anchorY = 0;
	boxPondLeft.tag = "wall";
	boxPondLeft.audio = 2;
	boxPondLeft.isVisible = false;

	local boxPondRight = display.newRect( scrWidth-5, 0, 5, scrHeight );
	boxPondRight.anchorX = 0;
	boxPondRight.anchorY = 0;
	boxPondRight.tag = "wall";
	boxPondRight.audio = 2;
	boxPondRight.isVisible = false;

	local boxPondTop = display.newRect( 0, 0, scrWidth, 5);
	boxPondTop.anchorX = 0;
	boxPondTop.anchorY = 0;
	boxPondTop.tag = "wall";
	boxPondTop.audio = 2;
	boxPondTop.isVisible = false;

	local boxPondBottom = display.newRect( 0, scrHeight-5, scrWidth, 5);
	boxPondBottom.anchorX = 0;
	boxPondBottom.anchorY = 0;
	boxPondBottom.tag = "wall";
	boxPondBottom.audio = 2;
	boxPondBottom.isVisible = false;

	-- add all walls to physics and scene group
	physics.addBody( boxPondLeft, "static" );
	physics.addBody( boxPondRight, "static" );
	physics.addBody( boxPondTop, "static" );
	physics.addBody( boxPondBottom, "static" );

	self.sceneGroup:insert( boxPondLeft );
	self.sceneGroup:insert( boxPondRight );
	self.sceneGroup:insert( boxPondTop );
	self.sceneGroup:insert( boxPondBottom );

	-- create back ground image
	self.imgBackground = display.newImage( self.strBackGround, 
											display.contentCenterX,
											display.contentCenterY )
	self.imgBackground:toBack();

	-- add to view group
	self.sceneGroup:insert( self.imgBackground );
end

------------------------------------------------------------------------
-- create text to display score
------------------------------------------------------------------------
function level:createScore()

	local color = 
	{
	    highlight = { r=0.3, g=0.3, b=0.3 },
	    shadow = { r=0.3, g=0.3, b=0.3 }
	}

	
	local txtHeight = 45;
	local baseWidth = 250;
	local baseHeight = txtHeight + 15;
	local xOffset = 10;
	local yOffset = scrHeight - 15;

	-- Level : text
	self.txtLevel = display.newEmbossedText( "Level: ".. self.nCurrentLevel, 
						xOffset, yOffset, native.systemFontBold, txtHeight );
	
	-- anchor to bottom left
	self.txtLevel.anchorX = 0;
	self.txtLevel.anchorY = 1;
	self.txtLevel:setFillColor( 0, 0, 0 );
	self.txtLevel:setEmbossColor(colorEmbossed);
	self.sceneGroup:insert(self.txtLevel);
	self.txtLevel:setEmbossColor( color )

	-- Score required box
	---------------------------------------------------------------------------
	-- create outer rectangle for score
	yOffset = yOffset - txtHeight - 50;
	self.outerRectReq = display.newRoundedRect( xOffset, yOffset, baseWidth, baseHeight, 15 );
	self.outerRectReq.strokeWidth = 10;
	self.outerRectReq:setStrokeColor( 0.5, 0.5, 0 );
	self.outerRectReq:setFillColor( 0, 0, 0, 0 );
	self.outerRectReq.anchorX = 0;
	self.outerRectReq.anchorY = 0.5;
   	self.sceneGroup:insert(self.outerRectReq);

   	-- set inner as nil for tracking
   	self.innerRect = nil;

	-- Score required text
	self.txtScoreReq = display.newEmbossedText( ""..self.nTargetScore,
							xOffset + (baseWidth/2), yOffset, 
							native.systemFont, txtHeight );

	-- anchor to bottom left
	self.txtScoreReq.anchorX = 0.5;
	self.txtScoreReq.anchorY = 0.5;
	self.txtScoreReq:setFillColor( 0, 0, 0 );
	self.txtScoreReq:setEmbossColor(colorEmbossed);
	self.sceneGroup:insert(self.txtScoreReq);
	self.txtScoreReq:setEmbossColor( color );

	-- Current score box
	---------------------------------------------------------------------------
	-- create outer rectangle for score
	yOffset = yOffset - txtHeight - 20;
	self.outerRect = display.newRoundedRect( xOffset, yOffset, baseWidth, baseHeight, 15 );
	self.outerRect.strokeWidth = 10;
	self.outerRect:setStrokeColor( 0.5, 0.5, 0 );
	self.outerRect:setFillColor( 0, 0, 0, 0 );
	self.outerRect.anchorX = 0;
	self.outerRect.anchorY = 0.5;
   	self.sceneGroup:insert(self.outerRect);

   	-- set inner as nil for tracking
   	self.innerRect = nil;

	-- current score
	self.txtScore = display.newEmbossedText( ""..self.nScore,
							xOffset + (baseWidth/2), yOffset, 
							native.systemFont, txtHeight );

	-- anchor to bottom left
	self.txtScore.anchorX = 0.5;
	self.txtScore.anchorY = 0.5;
	self.txtScore:setFillColor( 0, 0, 0 );
	self.txtScore:setEmbossColor(colorEmbossed);
	self.sceneGroup:insert(self.txtScore);
	self.txtScore:setEmbossColor( color )
	
	----------------------------------------------------------------------------
    -- create circle spear count
    --xOffset = xOffset + baseWidth + 10 + (baseHeight/1.5);
	--self.circleSpearCnt = display.newCircle( xOffset, yOffset, baseHeight/1.5 )
	--self.circleSpearCnt.strokeWidth = 5;
	--self.circleSpearCnt:setStrokeColor( 1, 0.8, 0.2 );
	--self.circleSpearCnt:setFillColor( 0, 0.5, 0 );
	--self.sceneGroup:insert(self.circleSpearCnt);

	-- display transparent score under the spear.
	self.txtInvSpearCnt = display.newText( ""..self.nSpearsCnt, self.nSpearX, self.nSpearY, native.systemFont, 150 );
	self.sceneGroup:insert(self.txtInvSpearCnt);
	self.txtInvSpearCnt:setFillColor( 0, 0, 1, 0.2 );

	-- spear count left
	--self.txtSpearCnt = display.newEmbossedText( ""..self.nSpearsCnt, 
	--					xOffset, yOffset, 
	--					native.systemFontBold, txtHeight );

	-- anchor to top right
	--self.txtSpearCnt:setFillColor( 0, 0, 0 );
	--self.txtSpearCnt:setEmbossColor(colorEmbossed);
	--self.sceneGroup:insert(self.txtSpearCnt);	
	--self.txtSpearCnt:setEmbossColor( color )
	---------------------------------------------------------------------------------------------

end

----------------------------------------------------------------------------------------
-- Updates score text
----------------------------------------------------------------------------------------
function level:updateScore()

	-- update level information
	if ( self.txtLevel ~= nil  ) then 
		self.txtLevel.text = "Level: ".. self.nCurrentLevel;
	end

	-- update score
	if ( self.txtScore ~= nil ) then
		self.txtScore.text = ""..self.nScore;
	end

	-- update spears left score
	if ( self.txtInvSpearCnt ~= nil ) then
		self.txtInvSpearCnt.text = ""..self.nSpearsCnt;
	end

	-- if outer rectangle created
	if ( self.outerRect ~= nil ) then 
		
		-- calculate the progress with
		local innerWid = self.outerRect.width * ( self.nScore / self.nTargetScore );

		-- clamp the calculated width between zero and width of the outer rectangle 
		if ( innerWid > self.outerRect.width ) then 
			innerWid = self.outerRect.width;
		elseif ( innerWid < 0 ) then 
			innerWid = 0;
		end

		-- if there is some progress
		if ( innerWid > 0 ) then 

			-- if progress rect is not created yet
			if ( self.innerRect == nil ) then 
				
				-- create progress rect
				self.innerRect = display.newRoundedRect(self.outerRect.x, self.outerRect.y,
												 innerWid, self.outerRect.height-5, 15 );

				self.innerRect:setFillColor(1, 1, 0, 0.7) ;
				self.innerRect.anchorX = 0;
				self.innerRect.anchorY = 0.5;
    			self.sceneGroup:insert(self.innerRect);
			else
				-- set the progress width
				self.innerRect.width = innerWid;
			end

			-- fill the progress bar with green, 
			-- if reached required score 
			if ( self.nScore >= self.nTargetScore ) then
				self.innerRect:setFillColor(0, 1, 0, 0.7) ;
			end

		-- if progress gets zero
		elseif (innerWid <= 0 ) then
			-- delete the inner rectangle 
			if ( self.innerRect ~= nil ) then 
				self.innerRect:removeSelf( );
				self.innerRect = nil;
			end
		end

	end	

end

----------------------------------------------------------------------------------------
-- createSpearBase
-- o   	This creates a circle that holds the spear in the middle.
-- o   	Circle listens the touch event and rotate the spear in the angle of 
-- 		center point and touch point.
-- o 	Draws a imaginary line between base center and touch point
-- o  	Releasing the touch applies force on the spear in its direction 
----------------------------------------------------------------------------------------
function level:createSpearBase()

	---------------------------------------------------------------------------------
	-- spearBase Touch Listener
	-- to update the spear object and to shoot spear.
	---------------------------------------------------------------------------------
	local function spearBaseTouchListener(event)

		if ( self.activeSpearImg == nil ) then
			return;
		end

		-- On the begin phase, set the spearbase as focus object
		if event.phase == "began" then

			-- set the circle as focus object, so that even the touch point leaves the 
			-- circle object, event keep fires until user lift the touch from screen 
			display.getCurrentStage():setFocus( event.target );
			event.target.isFocus = true

		-- circle object is the focus object
		elseif event.target.isFocus then

			-- while moving the touch
			if event.phase == "moved" then	 	

				-- remove the previous line object
				if ( lineForce ) then
					lineForce.parent:remove( lineForce );
					lineForce = nil;
				end

				-- get angle of base center point and the touch point
				local angle = angleOfLine(event.target, event);

				-- rotate the spear object
				self.activeSpearImg.rotation = angle;

				-- draw an imaginary line from center to touch point
				lineForce = display.newLine( event.target.x, event.target.y, event.x, event.y )
	        	lineForce.strokeWidth = 15
	        	lineForce:setStrokeColor( 1, 1, 1, 0.8 );

	        -- when the touch event ended
			elseif event.phase == "ended" then

				-- clear the focus object
				display.getCurrentStage():setFocus( nil )
				event.target.isFocus = false

				-- remove the imaginary line object
				if ( lineForce ) then
					lineForce.parent:remove( lineForce );
					lineForce = nil;
				end

				-- if the touch movement is nothing, ignore the event
				local dist = distance({x=event.x, y=event.y}, {x=event.xStart, y=event.yStart});

				if ( dist < 1 ) then 
					return;
				end

				-- get the current angle of the imaginary line from the sprear center
				local angle = angleOfLine(event.target, event);

				-- rotate the spear object
				self.activeSpearImg.rotation = angle;

				-- locate spear boundary to add into the physics. 
				-- This boundary created only to the front part of the spear.
				local spearShape = { -60, 0, 0,7, 0, -7, -60, 0 }
				physics.addBody (self.activeSpearImg, "dynamaic", {shape = spearShape} );

				-- set sensor and bullet properties to spear
				-- to capture all collisions and continus collisions
				self.activeSpearImg.isSensor = true;
				self.activeSpearImg.isBullet = true;
				self.activeSpearImg:applyForce( (self.activeSpearImg.x - event.x)/10, 
											(self.activeSpearImg.y - event.y)/10, 
											self.activeSpearImg.x, self.activeSpearImg.y );

				-- set obj to null
				self.activeSpearImg = nil;

			end

		end

	end


	-- Create circle to put spear
	local spearBase = display.newCircle( self.nSpearX, self.nSpearY, self.nSpearBaseRadius/2 );
	spearBase:setFillColor( 0, 1, 0, 0.2 );
	spearBase.strokeWidth = 20
	spearBase:setStrokeColor( 0, 0, 1, 0.1 );

	-- add to scene group
	self.sceneGroup:insert(spearBase);

	-- add touch event handler
	--spearBase:addEventListener( "touch", spearBaseTouchListener );

end

--------------------------------------------------------------------------
-- level:goToStart
-- to call start scene
--------------------------------------------------------------------------
function level:goToStart()

	--- stop all animations
	timer.cancel( self.timer1 );
	timer.cancel( self.timer2 );
	timer.cancel( self.timer3 );
	transition.cancel();

	-- pause the water flow sound
	audio.pause( self.waterFlowChannel );

	-- create options and params for next scene
	local options = 
	{
		effect = "slideRight",
		time = 400,
		params = 
	    {  
	    }
	}

	-- goto start scene
	composer.removeScene("startScene");
	composer.gotoScene("startScene", options);

end

--------------------------------------------------------------------------
-- level:resumeGame
-- to resume the game from pause mode
--------------------------------------------------------------------------
function level:resumeGame()

	-- resume the animations and physics
	timer.resume( self.timer1 );
	timer.resume( self.timer2 );
	timer.resume( self.timer3 );

	transition.resume();

	physics.start();

	self.pauseBtn.isVisible = true;

	-- play water flow sound
	local i = math.random(8,10)
	self.waterFlowChannel = audio.play( audioTable[i], {loops = -1} );

end

--------------------------------------------------------------------------
-- level:reloadLevel
-- to relad the same level from begining
--------------------------------------------------------------------------
function level:reloadLevel()

	--- stop all animations
	timer.cancel( self.timer1 );
	timer.cancel( self.timer2 );
	timer.cancel( self.timer3 );
	transition.cancel();

	-- pause the water flow sound
	audio.pause( self.waterFlowChannel );

	-- load the intermediate level to load back the same level
	local options = 
	{
		effect = "fade",
		time = 0,
		params = 
	    {  
	    	effect = "fade",
	    	nSpearsCnt = self._nSpearsCnt,
	    	nTargetScore = self.nTargetScore,
	    	nCurrentLevel = self.nCurrentLevel,
	    	nNextLevel = self.nNextLevel,
	    	strBackGround = self.strBackGround,
	    }
	}

	composer.removeScene("reloading");
	composer.gotoScene("reloading", options);

end

--------------------------------------------------------------------------
-- level:nextLevel
-- set up next vel score and spears and load the level
--------------------------------------------------------------------------
function level:nextLevel()

	--- stop all animations
	timer.cancel( self.timer1 );
	timer.cancel( self.timer2 );
	timer.cancel( self.timer3 );
	transition.cancel();

	-- pause the water flow sound
	audio.pause( self.waterFlowChannel );
	
	-- increment the spear count and score for the next level
	self.params.nSpearsCnt = self._nSpearsCnt + 3;

	self.params.nTargetScore = self.nTargetScore + 5000;
	self.params.nCurrentLevel = self.nCurrentLevel + 1;
	self.params.nNextLevel = self.nNextLevel + 1;

	-- goto intermediate level to come to back with new parameters
	local options = 
	{
		effect = "fade",
		time = 0,
		params = 
	    {  
	    	effect = "slideLeft",
	    	nSpearsCnt = self._nSpearsCnt + 3,
	    	nTargetScore = self.nTargetScore + 5000,
	    	nCurrentLevel = self.nCurrentLevel + 1,
	    	nNextLevel = self.nNextLevel + 1,
	    	strBackGround = self.strBackGround,
	    }
	}

	composer.removeScene("reloading");
	composer.gotoScene("reloading", options);

end

--------------------------------------------------------------------------
-- level:showeOverlay
-- display overlay scene
--------------------------------------------------------------------------
function level:showeOverlay( params )

	-- pause the water flow sound
	audio.pause( self.waterFlowChannel );

	-- hide the pause button
	self.pauseBtn.isVisible = false;

	-- show the level information on the pause scene
	params.nScore = self.nScore;
	params.nTargetScore = self.nTargetScore;
	params.nCurrentLevel = self.nCurrentLevel;
	local options = 
	{
		time = 400,
		effect = "fade",
		isModal = true,
		params = params,
	}

	-- call the pause sceen to overlay the level scene	
	composer.removeScene("pauseOverlay");
	composer.showOverlay("pauseOverlay", options)

end

----------------------------------------------------------------------------------------
-- create pause button
----------------------------------------------------------------------------------------
function level:createPauseButton()

	-- on pause button handler
	local function pauseTapListener ()
		-- pause timers, transitions, and physics engine
		timer.pause(self.timer1);
		timer.pause(self.timer2);
		timer.pause(self.timer3);

		transition.pause();
		
		physics.pause();

		-- call the overlay scene with required buttons and message
		local params = 
		{ 
			msg = "Game paused, select your option to continue",
			restartBtn = 1,
			resumeBtn = 1,
			homeBtn = 1,
			nextBtn = 0,
		};

		level:showeOverlay ( params );

	end

	-- Create pause button
	self.pauseBtn = widget.newButton
	{
		x = display.contentWidth - 80,
		y = display.contentHeight - 100,
	    sheet = self.spriteSheetButtons,
	    defaultFrame = 5,
	    overFrame = 6,
	    onRelease = pauseTapListener,
	}

	-- add pause button to scene group
	self.sceneGroup:insert(self.pauseBtn);

end

----------------------------------------------------------------------------------------
-- createScene
-- create boarder, spear, score etc
----------------------------------------------------------------------------------------
function level:createScene()

	-- create walls
	self:createPond();

	-- create a base to spear
	self:createSpearBase();

	-- create spear
	level:createSpear();

	-- create score text
	level:createScore();

	-- create pause button
	level:createPauseButton();

end
 
-------------------------------------------------------------------------------------
-- random swimming
-------------------------------------------------------------------------------------
function level:swim(x, y)

	local function onCompleteMethod(obj)
		if ( obj ~= nil ) then
			obj:removeSelf( );
		end
	end

	-- get a random index to load the fish image from sprite sheet 
    local i = math.random(1,18)

    -- load the image and set the initial location
    local fishImage = display.newImage(self.spriteSheet, i);
    fishImage.x = x;
    fishImage.y = y;

    -- add score and name to the fish
    fishImage.score = spriteImgData[i].score;
    fishImage.tag = spriteImgData[i].tag;
    fishImage.audio = spriteImgData[i].audio;

    -- add to physics to collide with spear
    physics.addBody( fishImage, "kinematic" );

    self.sceneGroup:insert(fishImage);

    -- animate fish object from left to right in the screen for a random time.
    transition.to(	fishImage, 
			    	{	time=math.random(3000,6000), 
			    		x=scrWidth,
			    		onComplete = onCompleteMethod 
			    	}
			    );

end

--------------------------------------------------------------------------------------
-- createSpear
--------------------------------------------------------------------------------------
function level:createSpear()

	-------------------------------------------------------------------------------------
	-- animateScore
	-- when the spear collides with fish, show score with an animation
	-------------------------------------------------------------------------------------
	local function animateScore(x, y, score)

		-- create a score text at the given location
		txt = display.newText( "".. score, x, y, native.systemFont, 30 );
		txt:setFillColor( 1, 0, 0 );

		self.sceneGroup:insert(txt);

		-- scale the score and remove it
		transition.scaleTo(txt, { xScale=3.0, yScale=3.0, time=1000,
						 onComplete=function(obj) obj:removeSelf();  end});

	end

	--------------------------------------------------------------------------------------
	-- spearImgCollisionListener
	--------------------------------------------------------------------------------------
	local function spearImgCollisionListener (event)

		-- get spear object
		local spear = event.target;

		if ( event.phase == "began" ) then

			if ( event.other.tag ~= nil ) then

				-- colliding with fish, remove fish and spear
				if ( event.other.tag == "fish" ) or 
					( event.other.tag == "shark" ) then

					-- cancel fish animation and remove
					transition.cancel(event.other);
					event.other:removeSelf( );

					-- display score at the fish and do some animation
					animateScore(event.other.x, event.other.y, event.other.score);

					-- set score from fish object
					self.nScore = self.nScore + event.other.score;

				elseif ( event.other.tag == "submarine" ) then 
					
					-- submarine don't care the spear, just display 0 (whatever) score

					-- display score at the fish and do some animation
					animateScore(event.other.x, event.other.y, event.other.score);

					-- set score from fish object
					self.nScore = self.nScore + event.other.score;

				elseif ( event.other.tag == "bomb" ) then

					-- cancel bomb animation and remove
					transition.cancel(event.other);

					-- get exploded bomb image and display at bomb location
					local explodeImage = display.newImage(self.spriteSheet, 19);
				    explodeImage.x = event.other.x;
				    explodeImage.y = event.other.y;
					self.sceneGroup:insert(explodeImage);

				    -- remove the old bomb
					event.other:removeSelf( );

					-- scale the score and remove it
					transition.scaleTo(explodeImage, { xScale=5.0, yScale=5.0, time=200,
									 onComplete=function(obj) obj:removeSelf();  end});					

					-- display score at the bomb and do some animation
					animateScore(event.other.x, event.other.y, event.other.score);

					-- set score from object
					self.nScore = self.nScore + event.other.score;
				end

				-- play applause sound
				audio.play( audioTable[event.other.audio] );

				-- remove spear object
				spear:removeEventListener( "collision", spearImgCollisionListener )
				spear:removeSelf( );
				self.nSpearsCnt = self.nSpearsCnt - 1;

				-- display score
				level:updateScore();

			end

			-- all spears completed and reached the target score
			if ( self.nScore >= self.nTargetScore) then

				timer.cancel( self.timer1 );
				timer.cancel( self.timer2 );
				timer.cancel( self.timer3 );
				transition.cancel();

				-- play applause sound
				audio.play( audioTable[1] );

				-- if all levels completed, show overlay with appropriate buttons
				if ( self.nCurrentLevel == self.nTotalLevels ) then

					local params = 
					{ 
						msg = "Successfully completed all levels.",
						restartBtn = 0,
						resumeBtn = 0,
						homeBtn = 1,
						nextBtn = 0,
					};

					-- show only home button
					level:showeOverlay ( params );

				-- else goto next level, show overlay with appropriate buttons
				else

					local params = 
					{ 
						msg = "Level "..self.nCurrentLevel.. " Completed go to Next Level",
						restartBtn = 0,
						resumeBtn = 0,
						homeBtn = 1,
						nextBtn = 1,
					};
					
					level:showeOverlay ( params );
				end

			-- no spears left and didn't get the target score
			-- level failed
			elseif ( self.nSpearsCnt == 0 ) then

				timer.cancel( self.timer1 );
				timer.cancel( self.timer2 );
				timer.cancel( self.timer3 );
				transition.cancel();

				local params = 
				{ 
					msg = "Level Failed. Play Again",
					restartBtn = 1,
					resumeBtn = 0,
					homeBtn = 1,
					nextBtn = 0,
				};

				level:showeOverlay ( params );

			-- Still have spears to shoot
			elseif ( self.nSpearsCnt > 0 ) then
				level:createSpear();
			end

		end
	end

	-- check if any spears left
	if ( self.nSpearsCnt > 0 ) then

		-- create spear
		self.activeSpearImg = display.newImage( "spear.png", self.nSpearX, self.nSpearY );
		self.activeSpearImg.rotation = 90;
		self.activeSpearImg:addEventListener( "collision", spearImgCollisionListener );

		self.sceneGroup:insert(self.activeSpearImg);
	end
end


-----------------------------------------------------------------------
-- new level object
-----------------------------------------------------------------------

function level:new(o)
	o = o or {};
	setmetatable( o, self );
	self.__index = self;
	return o;
end

-----------------------------------------------------------------------
-- inital scene create event
-----------------------------------------------------------------------
function level:create (event, composerScene)
	self.event = event;
	self.params = event.params;
	self.composerScene = composerScene;
	level:createLevel(self.event, self.composerScene, self.params);
end

function level:createLevel( event, composerScene, params )

	physics.start();

	-- set the variables from params
	self.nScore = 0;
	self.nSpearsCnt = params.nSpearsCnt;
	self.nTargetScore = params.nTargetScore;
	self.nCurrentLevel = params.nCurrentLevel;
	self.nNextLevel = params.nNextLevel;
	
	-- switch the back ground images between levels
	if ( self.nCurrentLevel%2 == 1 ) then
		self.strBackGround =  backgroundImgeTable[1];
	else
		self.strBackGround =  backgroundImgeTable[2];
	end

	self._nSpearsCnt = params.nSpearsCnt;

	-- Load sprite sheets
	self.spriteSheet = graphics.newImageSheet("fish_sprite.png", spriteSheetOptionsImages);
	self.spriteSheetButtons = graphics.newImageSheet("button_sprite.png", spriteSheetOptionsButtons);

	-- scene group
	self.sceneGroup = composerScene.view;
		
	-- Create the complete scene.
	level:createScene();

end

-----------------------------------------------------------------
-- scene:show event
-----------------------------------------------------------------
function level:show( event, composerScene )
	if (event.phase == "will") then
		level:showLevel();
	end
end

function level:showLevel( )

	-- generate random fishes and swims
	self.timer1 = timer.performWithDelay(math.random(2000, 3000), function() level:swim(100, 200) end , 0);
	self.timer2 = timer.performWithDelay(math.random(2000, 3000), function() level:swim(100, 450) end , 0);
	self.timer3 = timer.performWithDelay(math.random(2000, 3000), function() level:swim(100, 650) end , 0);

	local i = math.random(8,10)
	self.waterFlowChannel = audio.play( audioTable[i], {loops = -1} );

	ads.show( "banner", {x=0, y=0, appId=bannerAppID});
	
end

-----------------------------------------------------------------
function level:destroy( event, self )
	print("destroy");

	--transition.cancel();
	--timer.cancel( self.timer1 );
	--timer.cancel( self.timer2 );
	--timer.cancel( self.timer3 );

	if ( self.waterFlowChannel ~= nil ) then 
		audio.pause( self.waterFlowChannel );
	end

end

-------------------------------------------------------------------
function OnScreenTouchEvent(event)

	if ( level.activeSpearImg == nil ) then
		return;
	end

	local centerPt = { x = level.activeSpearImg.x; y = level.activeSpearImg.y };

	-- On the begin phase, set the spearbase as focus object
	if event.phase == "began" then


	-- while moving the touch
	elseif event.phase == "moved" then	 	

		-- remove the previous line object
		if ( lineForce ) then
			lineForce.parent:remove( lineForce );
			lineForce = nil;
		end

		-- get angle of base center point and the touch point
		local angle = angleOfLine(event, centerPt);

		-- rotate the spear object
		level.activeSpearImg.rotation = angle;

		local dirVect = { x = event.x - centerPt.x, y = event.y - centerPt.y};
		dirVect.x = dirVect.x * 10;
		dirVect.y = dirVect.y * 10;
		local endPt = { x = centerPt.x + dirVect.x, y = centerPt.y + dirVect.y};

		-- draw an imaginary line from center to touch point
		lineForce = display.newLine( centerPt.x, centerPt.y, endPt.x, endPt.y);
    	lineForce.strokeWidth = 5
    	lineForce:setStrokeColor( 1, 1, 1, 0.4 );

    -- when the touch event ended
	elseif event.phase == "ended" then

		-- remove the imaginary line object
		if ( lineForce ) then
			lineForce.parent:remove( lineForce );
			lineForce = nil;
		end

		-- if the touch movement is nothing, ignore the event
		local dist = distance({x=event.x, y=event.y}, {x=event.xStart, y=event.yStart});

		if ( dist < 1 ) then 
			return;
		end

		-- get the current angle of the imaginary line from the sprear center
		local angle = angleOfLine(event, centerPt);

		-- rotate the spear object
		level.activeSpearImg.rotation = angle;

		-- locate spear boundary to add into the physics. 
		-- This boundary created only to the front part of the spear.
		local spearShape = { -60, 0, 0,7, 0, -7, -60, 0 }
		physics.addBody (level.activeSpearImg, "dynamaic", {shape = spearShape} );

		-- set sensor and bullet properties to spear
		-- to capture all collisions and continus collisions
		level.activeSpearImg.isSensor = true;
		level.activeSpearImg.isBullet = true;
		level.activeSpearImg:applyForce( (event.x - level.activeSpearImg.x )/10, 
									(event.y - level.activeSpearImg.y )/10, 
									level.activeSpearImg.x, level.activeSpearImg.y );

		-- set obj to null
		level.activeSpearImg = nil;

	end

end

Runtime:addEventListener( "touch", OnScreenTouchEvent );

-- Return scene object.
return level;