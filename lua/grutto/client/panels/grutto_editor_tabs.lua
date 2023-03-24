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

    for _, tab in pairs( self.Sheet.Items ) do
        if tab.Tab:GetText() == name then
            self.Sheet:SetActiveTab( tab.Tab )
            return
        end
    end

    local editor = vgui.Create( "grutto_editor", self.sheet )
    local sheet = self.Sheet:AddSheet( name, editor, "icon16/brick.png" )
    editor:Dock( FILL )
    editor:SetCode( content or "" )
    if extension then
        editor:SetLanguage( extension )
    end

    sheet.Menu = DermaMenu()
    sheet.Menu:SetDeleteSelf( false )
    sheet.Menu:Hide()
    sheet.Menu:SetParent( self )

    local saveOption = sheet.Menu:AddOption( "Save" )
    saveOption:SetIcon( "icon16/disk.png" )
    saveOption.DoClick = function()
        editor:Save( name .. os.time() )
    end

    local saveAsOption = sheet.Menu:AddOption( "Save as..." )
    saveAsOption:SetIcon( "icon16/disk_multiple.png" )
    saveAsOption.DoClick = function()
        Derma_StringRequest( "Save as...", "Enter the name of the file", "", function( text )
            editor:Save( text )
        end )
    end

    local closeOption = sheet.Menu:AddOption( "Close" )
    closeOption:SetIcon( "icon16/cross.png" )
    closeOption.DoClick = function()
        if input.IsShiftDown() then
            if #self.Sheet:GetItems() == 1 then
                self:AddTab()
                self.Sheet:CloseTab( sheet.Tab, true )
            else
                self.Sheet:CloseTab( sheet.Tab, true )
            end
            self.Sheet:CloseTab( sheet.Tab, true )
            return
        end

        Derma_Query(
            "Do you want to save the changes you made to " .. name .. "?",
            "Save changes?", "Yes", function()
                editor:Save( name )
                if #self.Sheet:GetItems() == 1 then
                    self:AddTab()
                end
                self.Sheet:CloseTab( sheet.Tab, true )
            end,
            "No", function()
                if #self.Sheet:GetItems() == 1 then
                    self:AddTab()
                    self.Sheet:CloseTab( sheet.Tab, true )
                else
                    self.Sheet:CloseTab( sheet.Tab, true )
                end
                self.Sheet:CloseTab( sheet.Tab, true )
            end,
            "Cancel", function() end
        )
    end

    function sheet.Tab:DoRightClick( ... )
        sheet.Menu:Open()
        return
    end

    GRUTTO.ActiveEditor = sheet.Tab:GetPanel()
    self.Sheet:SetActiveTab( sheet.Tab )
end

-- function PANEL:Paint( w, h )
--     draw.RoundedBox( 3, 0, 0, w - 1, h, Color( 255, 255, 255 ) )
-- end

vgui.Register( "grutto_editor_tabs", PANEL, "DPanel" )
