local PANEL = {}
local CONSOLE_TEXT = GRUTTO.Colors.CONSOLE_TEXT

function PANEL:Init()
    self.Display = vgui.Create( "RichText", self )
    self.Input = vgui.Create( "DTextEntry", self )

    self.Display:Dock( FILL )
    self.Input:Dock( BOTTOM )

    self.Input.OnEnter = function()
        local text = self.Input:GetText()
        if text == "" then return end
        self:SetText( "" )

        self:AddConsoleText( "> " .. text, Color( 23, 136, 0 ) )
        GRUTTO.RunCodeCL( text )
    end

    function self.Display:PerformLayout()
        self:SetPaintBackgroundEnabled( true )
        self:SetBGColor( Color( 77, 80, 82 ) )
    end
end

function PANEL:AddConsoleText( str, color )
    if color then
        self.Display:InsertColorChange( color.r, color.g, color.b, color.a )
    end
    self.Display:AppendText( str .. "\n" )
    if color then
        self.Display:InsertColorChange( CONSOLE_TEXT.r, CONSOLE_TEXT.g, CONSOLE_TEXT.b, CONSOLE_TEXT.a )
    end
end

function PANEL:ClearConsoleText()
    self.Display:SetText( "" )
end

vgui.Register( "grutto_console", PANEL, "DPanel" )
