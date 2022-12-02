local extensionToMode = {
    txt = "text",
}

local PANEL = {}

function PANEL:Init()
    self.JSQueue = {}
    self:SetupDHTML()
end

function PANEL:SetupDHTML()
    local dhtml = vgui.Create( "DHTML", self )
    self.DHTML = dhtml
    dhtml:Dock( FILL )
    dhtml:AddFunction( "grutto", "GetEditorContents", function( str )
        self.Contents = str
    end )

    function dhtml.OnDocumentReady()
        self.Ready = true

        for _, v in ipairs( self.JSQueue ) do
            self:RunJSFunction( v[1], v[2] )
        end
    end

    dhtml:OpenURL( "http://redox-gmod.com:50/grutto_ace.html" ) -- temp local url
end

function PANEL:RunJSFunction( command, arg )
    local js = command .. "('" .. string.JavascriptSafe( arg ) .. "')"
    self.DHTML:RunJavascript( js )
end

function PANEL:QueueJSCommand( command, arg )
    if self.Ready then
        self:RunJSFunction( command, arg )
    else
        table.insert( self.JSQueue, { command, arg } )
    end
end

function PANEL:OnFinishLoadingDocument()
    self.Ready = true

    for _, v in pairs( self.JSQueue ) do
        self:RunJSFunction( v[1], v[2] )
    end
end

function PANEL:GetCode()
    return self.Contents
end

function PANEL:SetCode( str )
    self:QueueJSCommand( "SetCode", str )
end

function PANEL:SetTheme( theme )
    self:QueueJSCommand( "SetTheme", theme )
end

function PANEL:SetLanguage( lang )
    local mode = extensionToMode[lang]
    self:QueueJSCommand( "SetMode", mode or lang )
end

function PANEL:Paint()
    return true
end

vgui.Register( "grutto_editor", PANEL, "DPanel" )
