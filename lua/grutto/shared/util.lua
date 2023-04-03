function GRUTTO.WriteString( str )
    str = tostring( str )

    local compressed = util.Compress( str )
    local bytecount = #compressed

    net.WriteUInt( bytecount, 16 )
    net.WriteData( compressed, bytecount )
end

function GRUTTO.ReadString()
    local bytecount = net.ReadUInt( 16 )
    local compressed = net.ReadData( bytecount )
    local message = util.Decompress( compressed )

    return message
end
