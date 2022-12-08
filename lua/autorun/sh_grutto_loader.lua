GRUTTO = {}

if SERVER then
    include( "grutto/server/sv_init.lua" )
    AddCSLuaFile( "grutto/client/cl_init.lua" )
else
    include( "grutto/client/cl_init.lua" )
end

include( "grutto/shared/sh_init.lua" )
