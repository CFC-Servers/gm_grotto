local prefix = [[
local me = LocalPlayer();
local eyetrace = LocalPlayer():GetEyeTrace();
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
    if not code then return end
    code = prefix .. code
    RunString( code, "GRUTTO" )
end

function GRUTTO.RunCodeSV( code )
    if not code then return end
    code = prefix .. code
    print( code )
end
