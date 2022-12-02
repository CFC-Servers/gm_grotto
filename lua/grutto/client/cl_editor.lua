--local mainFrame
function GRUTTO.GetActiveEditor()
    return GRUTTO.ActiveEditor
end

function GRUTTO.GetActiveEditorCode()
    return GRUTTO.ActiveEditor:GetCode()
end

local function createFrame()
    local mainFrame = vgui.Create( "DFrame" )
    mainFrame:SetSize( ScrW() * 2 / 3, ScrH() * 2 / 3 )
    mainFrame:SetPos( ScrW() * 1 / 6, ScrH() * 1 / 6 )
    mainFrame:SetTitle( "Grutto" )
    mainFrame:SetVisible( true )
    mainFrame:ShowCloseButton( true )
    mainFrame:SetDeleteOnClose( true )
    mainFrame:SetIcon( "icon16/application_xp_terminal.png" )

    local leftPanel = vgui.Create( "DPanel", mainFrame )
    local rightPanel = vgui.Create( "DPanel", mainFrame )
    local divider = vgui.Create( "DHorizontalDivider", mainFrame )
    divider:Dock( FILL )
    divider:SetLeft( leftPanel )
    divider:SetRight( rightPanel )
    divider:SetDividerWidth( 4 )
    divider:SetLeftMin( 0 )
    divider:SetRightMin( 200 )
    divider:SetLeftWidth( 150 )

    local sidebar = vgui.Create( "grutto_sidebar", leftPanel )
    sidebar:Dock( FILL )

    local topbar = vgui.Create( "grutto_topbar", rightPanel )
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

    local tabs = vgui.Create( "grutto_editor_tabs", rightPanel )
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
