GRUTTO = {}

local function loadGrutto()
    if SERVER then
        include( "grutto/server/init.lua" )
        AddCSLuaFile( "grutto/client/init.lua" )
    else
        include( "grutto/client/init.lua" )
    end

    include( "grutto/shared/init.lua" )
end

loadGrutto()

concommand.Add ( "grutto_reload", function()
    GRUTTO = {}
    loadGrutto()
end )
