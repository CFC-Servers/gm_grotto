local function send( ply, str, ran )
    if CLIENT then
        GRUTTO.AddConsoleText( str )
    end

    if SERVER then
        net.Start( "grutto_runcodesv_result" )
            net.WriteBool( ran )
            net.WriteString( str )
        net.Send( ply )
    end
end

local runEnv = {}
function runEnv.print( ... )
    local args = { ... }
    local str = ""
    for _, arg in ipairs( args ) do
        str = str .. tostring( arg ) .. "\t"
    end
    send( runEnv._runningPlayer, str, true )
end

function runEnv.Msg( ... )
    local args = { ... }
    local str = ""
    for _, arg in ipairs( args ) do
        str = str .. tostring( arg )
    end
    send( runEnv._runningPlayer, str, true )
end

function runEnv.error( str )
    send( runEnv._runningPlayer, str, false )
    error( str )
end

function runEnv.me()
    return runEnv._runningPlayer
end

function runEnv.this()
    return runEnv._runningPlayer:GetEyeTrace().Entity
end

function runEnv.here()
    return runEnv._runningPlayer:GetEyeTrace().HitPos
end

setmetatable( runEnv, {
    __index = _G
} )

function GRUTTO.SetRunEnv( ply, func )
    runEnv._runningPlayer = ply
    setfenv( func, runEnv )
    return func
end
