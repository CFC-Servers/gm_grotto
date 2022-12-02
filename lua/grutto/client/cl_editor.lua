local mainFrame
local function createFrame()
    mainFrame = vgui.Create( "DFrame" )
    mainFrame:SetSize( ScrW() * 2 / 3, ScrH() * 2 / 3 )
    mainFrame:SetPos( ScrW() * 1 / 6, ScrH() * 1 / 6 )
    mainFrame:SetTitle( "Grutto" )
    mainFrame:SetVisible( true )
    mainFrame:ShowCloseButton( true )
    mainFrame:SetDeleteOnClose( true )

    local sidebar = vgui.Create( "grutto_sidebar", mainFrame )
    sidebar:SetWide( 180 )
    sidebar:Dock( LEFT )

    local tabs = vgui.Create( "grutto_editor_tabs", mainFrame )
    tabs:Dock( FILL )

    function GRUTTO.AddTab( name, panel )
        tabs:AddTab( name, panel )
    end

    tabs:AddTab()
end

concommand.Add( "grutto", function()
    include( "grutto/client/cl_init.lua" )

    GRUTTO.GenerateAutoCompletes()

    --if not mainFrame then
        createFrame()
    --end

    mainFrame:SetVisible( true )
    mainFrame:MakePopup()
end )
