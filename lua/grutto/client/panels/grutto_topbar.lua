local PANEL = {}

function PANEL:Init()
    local newTab = vgui.Create( "DButton", self )
    newTab:SetText( "Add tab" )
    newTab:SetIcon( "icon16/page_add.png" )
    newTab:SetWide( 90 )
    newTab:DockMargin( 1, 3, 2, 4 )
    newTab:Dock( LEFT )
    function newTab:DoClick()
        GRUTTO.AddTab()
    end

    local runCL = vgui.Create( "DButton", self )
    runCL:SetText( "Run on self" )
    runCL:SetIcon( "icon16/user_go.png" )
    runCL:SetWide( 110 )
    runCL:DockMargin( 1, 3, 2, 4 )
    runCL:Dock( LEFT )
    function runCL:DoClick()
        GRUTTO.RunCodeCL( GRUTTO.GetActiveEditorCode() )
    end

    local runSV = vgui.Create( "DButton", self )
    runSV:SetText( "Run on server" )
    runSV:SetIcon( "icon16/server_go.png" )
    runSV:SetWide( 110 )
    runSV:DockMargin( 1, 3, 2, 4 )
    runSV:Dock( LEFT )
    function runSV:DoClick()
        GRUTTO.RunCodeSV( GRUTTO.GetActiveEditorCode() )
    end
end

vgui.Register( "grutto_topbar", PANEL, "DPanel" )
