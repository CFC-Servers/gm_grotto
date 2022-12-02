local PANEL = {}

function PANEL:Init()
    local sheet = vgui.Create( "DPropertySheet", self )
    sheet:Dock( FILL )
    self.Sheet = sheet
end

function PANEL:AddTab( name, content )
    if not name then
        PANEL.UnnamedTabs = ( PANEL.UnnamedTabs or 0 ) + 1
        name = "New tab " .. PANEL.UnnamedTabs
    end

    local editor = vgui.Create( "grutto_editor", self.sheet )
    self.Sheet:AddSheet( name, editor, "icon16/brick.png" )
    editor:Dock( FILL )

    editor:SetCode( content or "" )
end

vgui.Register( "grutto_editor_tabs", PANEL, "DPanel" )
