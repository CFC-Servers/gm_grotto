local PANEL = {}

function PANEL:Init()
    local dtree = vgui.Create( "DTree", self )
    self.DTree = dtree
    dtree:Dock( FILL )
    dtree:Root():AddFolder( "Lua", "lua", "GAME", true )
    dtree:Root():AddFolder( "Data", "data", "GAME", true )

    function dtree.OnNodeSelected( _, node )
        local name = node:GetFileName()
        if not name then return end
        local contents = file.Read( name, "GAME" )
        local fileName = string.GetFileFromFilename( name )
        local extension = string.GetExtensionFromFilename( name )
        GRUTTO.AddTab( fileName, contents, extension )
    end
end

function PANEL:Paint()
    return true
end

vgui.Register( "grutto_sidebar", PANEL, "DPanel" )
