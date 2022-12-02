--local mainFrame
local function createFrame()
    local mainFrame = vgui.Create( "DFrame" )
    mainFrame:SetSize( ScrW() * 2 / 3, ScrH() * 2 / 3 )
    mainFrame:SetPos( ScrW() * 1 / 6, ScrH() * 1 / 6 )
    mainFrame:SetTitle( "Grutto" )
    mainFrame:SetVisible( true )
    mainFrame:ShowCloseButton( true )
    mainFrame:SetDeleteOnClose( true )

    local sidebar = vgui.Create( "grutto_sidebar", mainFrame )
    sidebar:SetWide( 180 )
    sidebar:Dock( LEFT )

    local topbar = vgui.Create( "grutto_topbar", mainFrame )
    topbar:SetTall( 30 )
    topbar:Dock( TOP )

    local tabs = vgui.Create( "grutto_editor_tabs", mainFrame )
    tabs:Dock( FILL )

    function GRUTTO.AddTab( name, panel, extension )
        tabs:AddTab( name, panel, extension )
    end

    tabs:AddTab()

    return mainFrame
end

concommand.Add( "grutto", function()
    include( "grutto/client/cl_init.lua" )

    --GRUTTO.GenerateAutoCompletes()

    --if not mainFrame then
    local mainFrame = createFrame()
    --end

    mainFrame:SetVisible( true )
    mainFrame:MakePopup()
end )
