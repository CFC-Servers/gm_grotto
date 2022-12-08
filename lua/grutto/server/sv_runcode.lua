util.AddNetworkString( "grutto_runcodesv" )
util.AddNetworkString( "grutto_runcodesv_result" )

local prefix = [[
local me = Player( %s );
local eyetrace = me:GetEyeTrace();
local this = eyetrace.Entity;
local here = eyetrace.HitPos;
]]

-- Turn prefix into a single prefixable line
do
    local prefixSplit = string.Explode( "\n", prefix )
    prefix = ""
    for _, line in ipairs( prefixSplit ) do
        prefix = prefix .. line
    end
end

net.Receive( "grutto_runcodesv", function( _, ply )
    if not ply:IsSuperAdmin() then
        ErrorNoHalt( "[GRUTTO] " .. ply:GetNick() .. "<" .. ply:SteamID() .. "> is trying to run code on the server without access!\n" )
        return
    end

    local bytes = net.ReadUInt( 16 )
    local compressed = net.ReadData( bytes )
    local code = util.Decompress( compressed )
    code = prefix .. code
    code = string.format( code, ply:UserID() )

    local func = CompileString( code, "GRUTTO" .. tostring( ply ), false )
    if isstring( func ) then
        net.Start( "grutto_runcodesv_result" )
            net.WriteBool( false )
            net.WriteString( func )
        net.Send( ply )
        return
    end

    local ok, result = pcall( func )

    if not ok then
        net.Start( "grutto_runcodesv_result" )
        net.WriteBool( false )
            net.WriteString( result )
        net.Send( ply )
        return
    end

    net.Start( "grutto_runcodesv_result" )
        net.WriteBool( true )
        net.WriteString( tostring( result ) )
    net.Send( ply )
end )
