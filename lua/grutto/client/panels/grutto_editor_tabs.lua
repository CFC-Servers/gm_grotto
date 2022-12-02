local PANEL = {}

function PANEL:Init()
    local sheet = vgui.Create( "DPropertySheet", self )
    sheet:Dock( FILL )
    function sheet:OnActiveTabChanged( _, new )
        GRUTTO.ActiveEditor = new:GetPanel()
    end
    self.Sheet = sheet
end

function PANEL:AddTab( name, content, extension )
    if not name then
        PANEL.UnnamedTabs = ( PANEL.UnnamedTabs or 0 ) + 1
        name = "New tab " .. PANEL.UnnamedTabs
    end

    local editor = vgui.Create( "grutto_editor", self.sheet )
    self.Sheet:AddSheet( name, editor, "icon16/brick.png" )
    editor:Dock( FILL )

    editor:SetCode( content or "" )
    editor:SetLanguage( extension or "glua" )

    for _, tbl in ipairs( self.Sheet:GetItems() ) do
        if tbl.Name == name then
            if not GRUTTO.ActiveEditor then
                GRUTTO.ActiveEditor = tbl.Tab:GetPanel()
            end
            self.Sheet:SetActiveTab( tbl.Tab )
            break
        end
    end
end

-- function PANEL:Paint( w, h )
--     draw.RoundedBox( 3, 0, 0, w - 1, h, Color( 255, 255, 255 ) )
-- end

vgui.Register( "grutto_editor_tabs", PANEL, "DPanel" )
