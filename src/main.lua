--[[=========================================================================
	Authors: Krishna Matta, Brandon Fields
	Date: Oct 18, 2014

	CS 596 - Final Project [ Happy Fising ]
	UAH - Huntsville

	Summary:
		This file is the main entry point for the program
		Calls the startScene.

	References:
		Buttons downloaded from the below website and created onstate buttons
			http://findicons.com/about

		sound files downloaded from below site, scaled according to the requirement
			http://soundbible.com/

		fish images downloaded from:
			https://openclipart.org/search/?query=fish&page=1
============================================================================]]
	
local composer = require( "composer");

local options = 
{
    effect = "fade",
    time = 800,
    params = 
    {  
    }
}

-------------------------------------------------------------------------------
composer.gotoScene("startScene", options );
-------------------------------------------------------------------------------

