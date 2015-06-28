--[[=========================================================================
    Authors: Krishna Matta, Brandon Fields
    Date: Oct 18, 2014

    CS 596 - Final Project [ Happy Fising ]
    UAH - Huntsville

    Summary:
        button image locations and sizes on the sprite sheet
============================================================================]]
local buttonTable =
{
    frames = 
    {
        { x = 8, y = 18, width = 105, height = 105},       		-- Home
        { x = 161, y = 18, width = 105, height = 105},       	-- Home : on state
        { x = 4, y = 144, width = 119, height = 115},     		-- Play
        { x = 156, y = 144, width = 119, height = 115},     	-- Play : on state
        { x = 4, y = 281, width = 119, height = 115},     		-- Pause
        { x = 158, y = 281, width = 119, height = 115},     	-- Pause : on state
        { x = 9, y = 416, width = 110, height = 106},     		-- replay
        { x = 158, y = 416, width = 110, height = 106},     	-- replay : on state
        { x = 7, y = 542, width = 114, height = 115},   		-- next
        { x = 156, y = 542, width = 114, height = 115},   		-- next : on state
    },
}

return buttonTable;

