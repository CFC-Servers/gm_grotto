local mainFrame
local function createFrame()
    mainFrame = vgui.Create( "DFrame" )
    mainFrame:SetSize( ScrW() * 2 / 3, ScrH() * 2 / 3 )
    mainFrame:SetPos( ScrW() * 1 / 6, ScrH() * 1 / 6 )
    mainFrame:SetTitle( "Name window" )
    mainFrame:SetVisible( true )
    mainFrame:ShowCloseButton( true )
    mainFrame:SetDeleteOnClose( false )

    local editor = vgui.Create( "lua_editor_tabs", mainFrame )
    editor:Dock( FILL )
end

concommand.Add( "lua_editor", function()
    if not mainFrame then
        createFrame()
    end

    mainFrame:SetVisible( true )
    mainFrame:MakePopup()
end )
