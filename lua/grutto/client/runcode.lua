function GRUTTO.RunCodeCL( code )
    if not LocalPlayer():IsSuperAdmin() then
        GRUTTO.AddConsoleText( "You don't have permission to run code!", GRUTTO.Colors.ERROR )
        return
    end

    if not code then return end
    local func = CompileString( code, "GRUTTO" .. tostring( LocalPlayer() )  .. LocalPlayer():SteamID(), false )

    GRUTTO.SetRunEnv( LocalPlayer(), func )

    if not func then
        GRUTTO.AddConsoleText( func, GRUTTO.Colors.ERROR )
        return
    end

    local ran, result = pcall( func )
    if not ran and result then
        GRUTTO.AddConsoleText( result, GRUTTO.Colors.ERROR )
        return
    end

    if result then
        GRUTTO.AddConsoleText( tostring( result ) )
    end
end

function GRUTTO.RunCodeSV( code )
    if not LocalPlayer():IsSuperAdmin() then
        GRUTTO.AddConsoleText( "You don't have permission to run code on the server!", GRUTTO.Colors.ERROR )
        return
    end

    if not code then return end
    local compressed = util.Compress( code )
    local bytes = #compressed

    net.Start( "grutto_runcodesv" )
        net.WriteUInt( bytes, 16 )
        net.WriteData( compressed, bytes )
    net.SendToServer()
end

net.Receive( "grutto_runcodesv_result", function()
    local ran = net.ReadBool()
    local result = net.ReadString()

    local color = ( not ran and GRUTTO.Colors.ERROR ) or GRUTTO.Colors.CONSOLE_SERVER
    GRUTTO.AddConsoleText( result, color )
end )
