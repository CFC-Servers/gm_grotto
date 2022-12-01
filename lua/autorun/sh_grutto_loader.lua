LUAEDITOR = {}

if SERVER then
    include( "grutto/server/sv_init.lua" )
    AddCSLuaFile( "grutto/client/cl_init.lua" )
else
    include( "grutto/client/cl_init.lua" )
end
