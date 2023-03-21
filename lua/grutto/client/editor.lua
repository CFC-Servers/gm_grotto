--local mainFrame
function GRUTTO.GetActiveEditor()
    return GRUTTO.ActiveEditor
end

function GRUTTO.GetActiveEditorCode()
    return GRUTTO.ActiveEditor:GetCode()
end

local function mainPanel()
    local mainFrame = vgui.Create( "DFrame" )
    local frameW, frameH = ScrW() * 2 / 3, ScrH() * 2 / 3
    mainFrame:SetSize( frameW, frameH )
    mainFrame:Center()
    mainFrame:SetTitle( "Grutto" )
    mainFrame:SetVisible( true )
    mainFrame:ShowCloseButton( true )
    mainFrame:SetDeleteOnClose( false )
    mainFrame:SetIcon( "icon16/application_xp_terminal.png" )

    local horizontalLeftDiv = vgui.Create( "DPanel", mainFrame )
    local horizontalRightDiv = vgui.Create( "DPanel", mainFrame )
    local hDivider = vgui.Create( "DHorizontalDivider", mainFrame )
    hDivider:Dock( FILL )
    hDivider:SetLeft( horizontalLeftDiv )
    hDivider:SetRight( horizontalRightDiv )
    hDivider:SetDividerWidth( 4 )
    hDivider:SetLeftMin( 0 )
    hDivider:SetRightMin( 200 )
    hDivider:SetLeftWidth( 150 )

    local sidebar = vgui.Create( "grutto_sidebar", horizontalLeftDiv )
    sidebar:Dock( FILL )

    local verticalUpDiv = vgui.Create( "DPanel", horizontalRightDiv )
    local verticalDownDiv = vgui.Create( "DPanel", horizontalRightDiv )
    local vDivider = vgui.Create( "DVerticalDivider", horizontalRightDiv )
    vDivider:Dock( FILL )
    vDivider:SetTop( verticalUpDiv )
    vDivider:SetBottom( verticalDownDiv )
    vDivider:SetBottomMin( 0 )
    vDivider:SetTopHeight( frameH * 0.8 )
    vDivider:SetDividerHeight( 4 )
    vDivider:SetPaintBackground( true )
    vDivider:SetBackgroundColor( Color( 108, 111, 114, 255 ) )

    local topbar = vgui.Create( "grutto_topbar", verticalUpDiv )
    topbar:SetTall( 30 )
    topbar:Dock( TOP )

    local tabs = vgui.Create( "grutto_editor_tabs", verticalUpDiv )
    tabs:Dock( FILL )

    function GRUTTO.AddTab( name, panel, extension )
        tabs:AddTab( name, panel, extension )
    end

    tabs:AddTab()

    local console = vgui.Create( "grutto_console", verticalDownDiv )
    console:Dock( FILL )

    function GRUTTO.AddConsoleText( str, col )
        console:AddConsoleText( str, col )
    end

    function GRUTTO.ClearConsole()
        console:ClearConsole()
    end

    return mainFrame
end

function GRUTTO.OpenEditor()
    if not file.Exists( "grutto/cache/main.dat", "DATA" ) then
        print( "Grutto cache not found, creating new one." )
        GRUTTO.CreateCache()
        return
    end

    -- if GRUTTO.MainFrame then
    --     GRUTTO.MainFrame:SetVisible( true )
    --     GRUTTO.MainFrame:MakePopup()
    --     return
    -- end

    local mainFrame = mainPanel()
    mainFrame:SetVisible( true )
    mainFrame:MakePopup()
    GRUTTO.MainFrame = mainFrame
end

concommand.Add( "grutto", function()
    GRUTTO.OpenEditor()
end )
