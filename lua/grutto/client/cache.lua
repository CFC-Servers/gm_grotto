function GRUTTO.CreateCache()
    file.CreateDir( "grutto/cache" )
    net.Start( "grutto_request_cache" )
    net.SendToServer()
end

net.Receive( "grutto_receive_cache", function()
    local filename = net.ReadString()
    local bytes = net.ReadUInt( 16 )
    local compressed = net.ReadData( bytes )
    local contents = util.Decompress( compressed )

    file.Write( "grutto/cache/" .. filename .. ".dat", contents )
    print( "Grutto successfully fetched " .. filename .. " " .. math.Round( bytes / 1024, 1 ) .. "kb" )
end )

concommand.Add( "grutto_cache_refresh", GRUTTO.CreateCache )
