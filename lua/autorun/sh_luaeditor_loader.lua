LUAEDITOR = {}

if SERVER then
    include( "lua_editor/server/sv_init.lua" )
    AddCSLuaFile( "lua_editor/client/cl_init.lua" )
else
    include( "lua_editor/client/cl_init.lua" )
end
