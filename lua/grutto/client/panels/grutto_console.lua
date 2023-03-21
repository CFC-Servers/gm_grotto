local PANEL = {}
local CONSOLE_TEXT = GRUTTO.Colors.CONSOLE_TEXT

function PANEL:AddConsoleText( str, color )
    if color then
        self:InsertColorChange( color.r, color.g, color.b, color.a )
    end
    self:AppendText( str .. "\n" )
    if color then
        self:InsertColorChange( CONSOLE_TEXT.r, CONSOLE_TEXT.g, CONSOLE_TEXT.b, CONSOLE_TEXT.a )
    end
end

function PANEL:ClearConsoleText()
    self:SetText( "" )
end

function PANEL:PerformLayout()
    self:SetPaintBackgroundEnabled( true )
    self:SetBGColor( Color( 77, 80, 82 ) )
end

vgui.Register( "grutto_console", PANEL, "RichText" )
