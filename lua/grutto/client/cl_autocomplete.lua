local metaTables = {
    "Entity",
    "Player",
    "NPC",
    "Vehicle",
    "Weapon",
    "PhysObj",
    "CUserCmd",
    "ConVar",
    "IMesh",
    "VMatrix",
    "Angle",
    "File"
}

local types = {
    constants = {},
    functions = {}
}

local parsedTables = {}
local prefix = "var grutto_"

local function parseTable( tbl, typeOverride )
    for key, val in pairs( tbl ) do
        if type( val ) == "table" then
            if parsedTables[val] then continue end
            parsedTables[tbl] = true
            parseTable( val, typeOverride )
        else
            if type( val ) == "string" and string.upper( val ) == val then
                types.constants[key] = true
            elseif type( val ) == "function" then
                types.functions[key] = true
            end
        end
    end
end

function GRUTTO.GenerateAutoCompletes()
    parseTable( _G )

    for _, metaTable in pairs( metaTables ) do
        parseTable( FindMetaTable( metaTable ), "meta" )
    end

    file.CreateDir( "grutto" )

    for name, parsedTable in pairs( types ) do
        local str = ""
        for key, _ in pairs( parsedTable ) do
            str = str .. "|" .. key
        end

        str = string.sub( str, 2 )
        local safe = string.JavascriptSafe( str )

        local fileName = "grutto/cl_" .. name .. ".dat"
        local contents = prefix .. name .. " = \"" .. safe .. "\";"
        file.Write( fileName, contents  )
    end
end
