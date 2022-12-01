mainFrame = nil
local function createFrame()
    mainFrame = vgui.Create( "DFrame" )
    mainFrame:SetSize( ScrW() * 2 / 3, ScrH() * 2 / 3 )
    mainFrame:SetPos( ScrW() * 1 / 6, ScrH() * 1 / 6 )
    mainFrame:SetTitle( "Name window" )
    mainFrame:SetVisible( true )
    mainFrame:ShowCloseButton( true )
    mainFrame:SetDeleteOnClose( true )

    local editor = vgui.Create( "grutto_editor", mainFrame )
    editor:Dock( FILL )
end

concommand.Add( "grutto", function()
    include( "grutto/client/cl_init.lua" )

    GRUTTO.GenerateAutoCompletes()

    if not mainFrame then
        createFrame()
    end

    mainFrame:SetVisible( true )
    mainFrame:MakePopup()
end )
