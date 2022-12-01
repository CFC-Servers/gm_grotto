local PANEL = {}

function PANEL:Init()
    self.dhtml = vgui.Create( "DHTML", self )
    self.dhtml:Dock( FILL )
    self.dhtml:AddFunction( "grutto", "GetEditorContents", function( str )
        self.Contents = str
    end )
    self.dhtml:OpenURL( "http://redox-gmod.com:5050/grutto_ace.html" ) -- temp local url
end

function PANEL:GetEditorContents()
    return self.Contents
end

function PANEL:SetEditorContents( str )
    str = string.JavascriptSafe( str )
    self.dhtml:RunJavascript( "SetEditorContents( '" .. str .. "' )" )
end

function PANEL:SetTheme( theme )
    theme = string.JavascriptSafe( theme )
    self.dhtml:RunJavascript( "SetTheme( '" .. theme .. "' )" )
end

function PANEL:SetLanguage( lang )
    lang = string.JavascriptSafe( lang )
    self.dhtml:RunJavascript( "SetMode( '" .. lang .. "' )" )
end

vgui.Register( "grutto_editor", PANEL, "DPanel" )
