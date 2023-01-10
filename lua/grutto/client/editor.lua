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
    mainFrame:SetDeleteOnClose( true )
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

    local newTab = vgui.Create( "DButton", topbar )
    newTab:SetText( "Add tab" )
    newTab:SetIcon( "icon16/page_add.png" )
    newTab:SetWide( 90 )
    newTab:DockMargin( 1, 3, 2, 4 )
    newTab:Dock( LEFT )
    function newTab:DoClick()
        GRUTTO.AddTab()
    end

    local runCL = vgui.Create( "DButton", topbar )
    runCL:SetText( "Run on self" )
    runCL:SetIcon( "icon16/user_go.png" )
    runCL:SetWide( 110 )
    runCL:DockMargin( 1, 3, 2, 4 )
    runCL:Dock( LEFT )
    function runCL:DoClick()
        GRUTTO.RunCodeCL( GRUTTO.GetActiveEditorCode() )
    end

    local runSV = vgui.Create( "DButton", topbar )
    runSV:SetText( "Run on server" )
    runSV:SetIcon( "icon16/server_go.png" )
    runSV:SetWide( 110 )
    runSV:DockMargin( 1, 3, 2, 4 )
    runSV:Dock( LEFT )
    function runSV:DoClick()
        GRUTTO.RunCodeSV( GRUTTO.GetActiveEditorCode() )
    end

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

    return mainFrame
end

function GRUTTO.OpenEditor()
    if not file.Exists( "grutto/cache/main.dat", "DATA" ) then
        print( "Grutto cache not found, creating new one." )
        GRUTTO.CreateCache()
        return
    end

    local mainFrame = mainPanel()
    mainFrame:SetVisible( true )
    mainFrame:MakePopup()
end

concommand.Add( "grutto", function()
    GRUTTO.OpenEditor()
end )
