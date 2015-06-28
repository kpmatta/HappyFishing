--[[=========================================================================
    Authors: Krishna Matta, Brandon Fields
    Date: Oct 18, 2014

    CS 596 - Final Project [ Happy Fising ]
    UAH - Huntsville

    Summary:
        fish images location and sizes on the sprite sheet
============================================================================]]

local fishTable =
{
    --array of tables representing each frame (required)
    frames =
    {
        { x = 0, y = 0, width = 119, height = 88 },      -- light orange
        { x = 0, y = 98, width = 108, height = 64 },     -- yellow, blue fish
        { x = 0, y = 173, width = 119, height = 57 },    -- orange stripe fish
        { x = 0, y = 240, width = 110, height = 70 },    -- black fish
        { x = 0, y = 320, width = 102, height = 64},     -- small blue fish
        { x = 0, y = 393, width = 121, height = 64 },    -- crab
        { x = 0, y = 471, width = 120, height = 48 },    -- green fish
        { x = 0, y = 532, width = 121, height = 101 },   -- light orange baloon fish
        { x = 0, y = 647, width = 80, height = 47 },     -- very small orange fish
        { x = 0, y = 703, width = 148, height = 87 },    -- scarlet, gray cartoon fish
        { x = 0, y = 807, width = 78, height = 63 },     -- very small green fish
        { x = 0, y = 887, width = 121, height = 115 },   -- cyan baloon fish
        { x = 0, y = 1016, width = 105, height = 86 },   -- small rainbow fish
        { x = 0, y = 1121, width = 80, height = 146 },   -- seahorse
        { x = 0, y = 1286, width = 121, height = 92 },   -- yellow stripes fish
        { x = 0, y = 1399, width = 201, height = 137 },  -- shark
        { x = 9, y = 1702, width = 252, height = 158},   -- submarine
        { x = 21, y = 1557, width = 110, height = 109},  -- Bomb
        { x = 161, y = 1552, width = 128, height = 128}, -- Bomb exploded
    },
}

return fishTable;