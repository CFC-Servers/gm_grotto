GRUTTO = {}

if SERVER then
    include( "grutto/server/init.lua" )
    AddCSLuaFile( "grutto/client/init.lua" )
else
    include( "grutto/client/init.lua" )
end

include( "grutto/shared/init.lua" )
