local prefix = [[
local me = LocalPlayer();
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

function GRUTTO.RunCodeCL( code )
    if not LocalPlayer():IsSuperAdmin() then
        GRUTTO.AddConsoleText( "You don't have permission to run code!", GRUTTO.Colors.ERROR )
        return
    end

    if not code then return end
    code = prefix .. code
    local func = CompileString( code, "GRUTTO" .. tostring( LocalPlayer() ), false )

    if not func then
        GRUTTO.AddConsoleText( func, GRUTTO.Colors.ERROR )
        return
    end

    local ran, result = pcall( func )
    if not ran and result then
        GRUTTO.AddConsoleText( result, GRUTTO.Colors.ERROR )
        return
    end

    GRUTTO.AddConsoleText( tostring( result ) )
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

    local color = not ran and GRUTTO.Colors.ERROR
    GRUTTO.AddConsoleText( result, color )
end )
