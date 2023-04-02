util.AddNetworkString( "grutto_runcodesv" )
util.AddNetworkString( "grutto_runcodesv_result" )

local function sendResult( ply, str, ok )
    net.Start( "grutto_runcodesv_result" )
        net.WriteBool( ok )
        net.WriteString( str )
    net.Send( ply )
end

net.Receive( "grutto_runcodesv", function( _, ply )
    if not ply:IsSuperAdmin() then
        ErrorNoHalt( "[GRUTTO] " .. ply:GetNick() .. "<" .. ply:SteamID() .. "> is trying to run code on the server without access!\n" )
        print( "[GRUTTO] " .. ply:GetNick() .. "<" .. ply:SteamID() .. "> is trying to run code on the server without access!\n" )
        return
    end

    local bytes = net.ReadUInt( 16 )
    local compressed = net.ReadData( bytes )
    local code = util.Decompress( compressed )

    local func = CompileString( code, "[GRUTTO][" .. ply:GetName() .. "][" .. ply:SteamID() .. "]", false )

    if isstring( func ) then
        sendResult( ply, func, false )
        return
    end

    GRUTTO.SetRunEnv( ply, func )

    local ok, result = pcall( func )

    if not ok then
        sendResult( ply, result, false )
        return
    end

    if result then
        sendResult( ply, tostring( result ), true )
    end
end )
