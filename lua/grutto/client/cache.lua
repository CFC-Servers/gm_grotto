function GRUTTO.CreateCache()
    file.CreateDir( "grutto/cache" )
    net.Start( "grutto_request_cache" )
    net.SendToServer()

    GRUTTO.GenerateAutoCompletes()
end

net.Receive( "grutto_receive_cache", function( bytes )
    local filename = net.ReadString()
    local contents = GRUTTO.ReadString()

    file.Write( "grutto/cache/" .. filename .. ".dat", contents )
    print( "Grutto successfully fetched " .. filename .. " " .. math.Round( bytes / 1024, 1 ) .. "kb" )
end )

concommand.Add( "grutto_cache_refresh", GRUTTO.CreateCache )
