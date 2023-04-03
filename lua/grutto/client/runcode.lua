function GRUTTO.RunCodeCL( code )
    if not GRUTTO.CanRunCL( LocalPlayer() ) then
        GRUTTO.AddConsoleText( "You don't have permission to run code!", GRUTTO.Colors.ERROR )
        return
    end

    if not code then return end
    local lp = LocalPlayer()
    local func = CompileString( code, "[GRUTTO][" .. lp:GetName() .. "][" .. lp:SteamID() .. "]", false )

    if not func or isstring( func ) then
        GRUTTO.AddConsoleText( func, GRUTTO.Colors.ERROR )
        return
    end

    GRUTTO.SetRunEnv( LocalPlayer(), func )

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
    if not GRUTTO.CanRunSV( LocalPlayer() ) then
        GRUTTO.AddConsoleText( "You don't have permission to run code on the server!", GRUTTO.Colors.ERROR )
        return
    end

    if not code then return end
    net.Start( "grutto_runcodesv" )
        GRUTTO.WriteString( code )
    net.SendToServer()
end

net.Receive( "grutto_runcodesv_result", function()
    local ran = net.ReadBool()
    local result = GRUTTO.ReadString()

    local color = ( not ran and GRUTTO.Colors.ERROR ) or GRUTTO.Colors.CONSOLE_SERVER
    GRUTTO.AddConsoleText( result, color )
end )
