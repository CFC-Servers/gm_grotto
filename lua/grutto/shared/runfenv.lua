local SERVER = SERVER
local CLIENT = CLIENT
local runEnv = {
    grutto = {}
}

function runEnv.__send( str, ran )
    if CLIENT then
        GRUTTO.AddConsoleText( str, GRUTTO.Colors.CONSOLE_CLIENT )
    end

    if SERVER then
        net.Start( "grutto_runcodesv_result" )
            net.WriteBool( ran )
            GRUTTO.WriteString( str )
        net.Send( runEnv.__codeOwner )
    end
end

function runEnv.print( ... )
    local args = { ... }
    local str = ""
    for _, arg in ipairs( args ) do
        str = str .. tostring( arg ) .. "\t"
    end
    runEnv.__send( str, true )
end

function runEnv.Msg( ... )
    local args = { ... }
    local str = ""
    for _, arg in ipairs( args ) do
        str = str .. tostring( arg )
    end
    runEnv.__send( str, true )
end

function runEnv.error( str )
    runEnv.__send( str, false )
    error( str )
end

function runEnv.grutto.ClearConsole()
    GRUTTO.ClearConsole()
end

setmetatable( runEnv, {
    __index = _G
} )

function GRUTTO.SetRunEnv( ply, func )
    runEnv.__codeOwner = ply
    runEnv.me = ply
    runEnv.this = ply:GetEyeTrace().Entity
    runEnv.there = ply:GetEyeTrace().HitPos
    runEnv.here = ply:GetPos()

    setfenv( func, runEnv )
    return func
end
