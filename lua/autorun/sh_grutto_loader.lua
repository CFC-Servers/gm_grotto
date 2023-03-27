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

if CLIENT then
    concommand.Add( "grutto_reload_cl", function()
        GRUTTO = {}
        loadGrutto()
    end )
else
    concommand.Add( "grutto_reload_sv", function()
        GRUTTO = {}
        loadGrutto()
    end )
end
