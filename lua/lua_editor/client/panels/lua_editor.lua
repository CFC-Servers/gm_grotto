local encode = string.JavascriptSafe
local refresh_autocompletes = function() end
local file = file

local PANEL = {}
PANEL.URL = "http://metastruct.github.io/lua_editor/index.html" -- This is where the JS editor is stored.
PANEL.Modes = {
    "glua", -- glua is a reference to the modified game's lua language.
    "lua",
    "javascript",
    "json",
    "text",
    "plain_text",
    "sql",
    "xml"
}

PANEL.Themes = {
    "ambiance",
    "chaos",
    "chrome",
    "clouds",
    "clouds_midnight",
    "cobalt",
    "crimson_editor",
    "dawn",
    "dreamweaver",
    "eclipse",
    "github",
    "idle_fingers",
    "iplastic",
    "katzenmilch",
    "kr_theme",
    "kuroir",
    "merbivore",
    "merbivore_soft",
    "mono_industrial",
    "monokai",
    "pastel_on_dark",
    "solarized_dark",
    "solarized_light",
    "sqlserver",
    "terminal",
    "textmate",
    "tomorrow",
    "tomorrow_night",
    "tomorrow_night_blue",
    "tomorrow_night_bright",
    "tomorrow_night_eighties",
    "twilight",
    "vibrant_ink",
    "xcode"
}

AccessorFunc( PANEL, "m_iFontSize", "FontSize",			FORCE_NUMBER )
AccessorFunc( PANEL, "m_sTheme", 	"Theme", 			FORCE_STRING )
AccessorFunc( PANEL, "m_sMode", 	"Mode", 			FORCE_STRING )
AccessorFunc( PANEL, "m_sSessName",	"Session",			FORCE_STRING )
AccessorFunc( PANEL, "m_bLoaded",	"HasLoaded",		FORCE_BOOL	 )
AccessorFunc( PANEL, "m_bSaveSnip",	"DoSaveSnippets",	FORCE_BOOL	 )
AccessorFunc( PANEL, "m_bLoadSnip",	"DoLoadSnippets",	FORCE_BOOL	 )


-- TODO:
-- shortcuts: reload panel, run scripts [cl,sv,etc], rebind js-side shortcuts, ...
-- snippets


function PANEL:Init()
    self:SetCookieName( "lua_editor" )
    self:SetDoSaveSnippets( true )
    self:SetDoLoadSnippets( true )

    self.SaveDirectory	= "lua_editor/"
    self.Sessions = {}
    self.Snippets = {}
    self.CTThreshold = 5 -- Compile Time Threshold in ms.

    self.LoadBtn = vgui.Create( "DButton", self )
        self.LoadBtn:SetText( "Loading Editor | If nothing happens for a long time, click me to retry" )
        self.LoadBtn:SizeToContents()
        self.LoadBtn:SetPos( 4, 1 )
        self.LoadBtn:SetSize( self.LoadBtn:GetWide() + 10, self.LoadBtn:GetTall() + 5 )
        self.LoadBtn.DoClick = function() self:LoadURL() end
        self.LoadBtn.Think = function( panel ) panel:SetTextColor( Color( 100 + 100 * math.sin( CurTime() * 10 ), 50, 50, 255 ) ) end

    self.ErrBtn	= vgui.Create( "DButton", self )
        --self.ErrBtn:Dock( BOTTOM )
        self.ErrBtn:SetIcon( "icon16/cancel.png" )
        self.ErrBtn:SetTooltip( "Right click to copy error text" )
        self.ErrBtn:SetVisible( false )
        self.ErrBtn:SetTextColor( color_black )
        self.ErrBtn:SetZPos( 10000 )
        self.ErrBtn:SetContentAlignment( 4 )
        self.ErrBtn.DoRightClick = function( panel ) SetClipboardText( panel:GetText() ) end
        self.ErrBtn.DoClick = function() self:GotoErrorLine() end
        self.ErrBtn.Paint = function( _, w, h )
            draw.RoundedBox( 2, 0, 0, w, h, Color( 150, 50, 50 ) )
            draw.RoundedBox( 2, 2, 2, w - 4, h - 4, Color( 200, 75, 75 ) )
        end

    -- Save snippets on game shutdown
    hook.Add( "ShutDown", self, function()
        if not IsValid( self ) or not self.HTML then return end
        self:SaveSnippets()
    end )
end

function PANEL:RefreshAutocompletes( force )
    if self.written_autocomplete and not force then return end

    self.written_autocomplete = true
    refresh_autocompletes()
end

function PANEL:PerformLayout( w, h )
    local b = self.ErrBtn
    local bh = b:GetTall()
    local bw = w

    b:SetPos( 0, h - bh )
    b:SetSize( bw, bh )
end

function PANEL:LoadURL()
    self:SetHasLoaded( false )
    self.HTML:OpenURL( self.URL )
    self.LoadBtn:SetVisible( true )
end

function PANEL:CreateHTML()
    self.HTML = vgui.Create( "DHTML", self )
    self.HTML:Dock( FILL )
    self.HTML.FCall = function( panel, str, ... )

        local t = { ... }

        for k, v in next, t do

            if isstring( v ) then
                t[k] = '"' .. encode( v ) .. '"'
            else
                t[k] = tostring( v )
            end

        end

        local _ = debug.getinfo( 2 )
        local caller = _.source .. ':' .. ( _.currentline or _.linedefined )
        local wrap = ( str ):format( unpack( t, 1, select( '#', ... ) ) )

        wrap = ( [[
        var _func_src = "%s";
        var src = "%s";
        try {
            var _func_ = new Function(_func_src);

            try {
                _func_();
            }
            catch( e ) {
                console.log( "" + src + ": " + e );
            }

        } catch (e) {
            console.log( "" + src + ": " + e + "\nCODE: " + _func_src );
        }
        ]] ):format( encode( wrap ), encode( caller ) )

        panel:Call( wrap ) -- This will run the wrap string as JS code.
    end

    self.HTML:SetFocusTopLevel( true )
    self.HTML:RequestFocus()
    self.HTML.OnFocusChanged = function( _, gained ) self:OnFocus( gained ) end
    self.LoadBtn:MoveToAfter( self.HTML )
    self.HTML.Paint = function( panel ) panel:IsLoading() end

    function self.HTML.ConsoleMessage( _, msg )
        print( msg == nil and "*js variable?*" or msg )
    end

    local function bind( name ) -- Creates the js->lua callback: gmodinterface.funcname -> PANEL:funcname( ... )
        self.HTML:AddFunction( "gmodinterface", name, function( ... )
            self[name]( self, ... )
        end )
    end

    self.HTML:AddFunction( "console", "info", function( ... ) Msg( "[LuaEditor] " ) print( ... ) end )
    self.HTML:AddFunction( "console", "warn", function( ... ) Msg( "[LuaEditor] " ) print( ... ) end )

    bind( "OnSelection" )
    bind( "OnReady" )
    bind( "OnCode" )
    bind( "OnLog" )
    bind( "OnContextMenu" )
    bind( "onmousedown" )
    bind( "InternalSnippetsUpdate" )

    self:LoadURL()
    self:OnHTMLLoaded( self.HTML )
end

-- delayed loading. PANEL:Paint(..) is only called after the panel is seen (i.e. is in viewport).
function PANEL:Paint()
    if not self.__loaded then

        self.__loaded = true
        self:RefreshAutocompletes()
        self:CreateHTML()
    end
end

function PANEL:Think()
    if not self.HTML or not self:GetHasLoaded() then return end
    if self._want_line and self.has_set_code then
        local l = self._want_line
        self._want_line = false
        self.HTML:FCall( "GotoLine(%s);", tonumber( l or 0 ) )
    end

    if self.mdown then
        local mrx, mry = self.HTML:CursorPos()
        local pw, ph = self.HTML:GetSize()

        if mrx < 0 or mry < 0 or mrx > pw or mry > ph then

            local fx, fy = math.Clamp( mrx, 1, pw - 1 ), math.Clamp( mry, 1, ph - 1 )
            local sx, sy = self.HTML:LocalToScreen( fx, fy )

            input.SetCursorPos( sx, sy ) -- not all the commands go through so we spam this shit
            gui.InternalCursorMoved( sx, sy )

            if not input.IsMouseDown( MOUSE_LEFT ) then

                gui.InternalMouseReleased( MOUSE_LEFT )
                self.HTML:PostMessage( "MouseReleased", "code", MOUSE_LEFT )
                self.mdown = false
            end
        end
    end
end

local function FormatFilepath( str ) -- removes bad characters
    return str:gsub( "[^%/%w%_%. ]", "" )
end

function PANEL:OnSelection( code )
    local cb = self.__sel_callback

    if not cb then
        print( "OnSelection", #code, code )
        return
    end

    self.__sel_callback = nil

    timer.Simple( 0, function()
        local ret = cb( code )

        if ret and isstring( ret ) then
            self:ReplaceSelection( ret )
        end
    end )
end

function PANEL:GetSelection( callback )
    self.__sel_callback = callback
    self.HTML:FCall( "setTimeout(GetSelection,0);" )
end

function PANEL:GotoLine( line )
    self._want_line = line
end

function PANEL:GotoErrorLine()
    self:GotoLine( self.ErrorLine or 0 )
end

local luacheckLevels = {
    ["0"] = "error",
    ["1"] = "warning",
    -- anything else, info
}
local luacheckIgnore = {
    "212", -- Unused argument.
    "213", -- Unused loop variable.
    "611", -- A line consists of nothing but whitespace.
}

local function getLuaCheckMessages( code )
    local t = {}

    local file_report = luacheck.get_report( code )

    local messages = luacheck.filter.filter( { file_report }, {
        ignore = luacheckIgnore,
    } )[1]

    for _, message in ipairs( messages ) do

        local level = tostring( message.code )[1] -- first number of 3 digit code
        local line = message.line and tonumber( message.line ) or false

        t[#t + 1] = {
            type = luacheckLevels[level] or "info",
            row  = line and ( line - 1 ) or 0,
            text = luacheck.get_message( message ) or '?',
        }

    end

    return t
end

function PANEL:ValidateCode( code ) -- Here we make sure the code is valid, meaning doesn't error, before actually running it.
    code = code or self:GetCode()

    if not code or code:len() < 1 or self:GetMode() ~= "glua" then
        self:SetErrorButton( false )
        return
    end

    local messages = {}

    if luacheck then
        messages = getLuaCheckMessages( code )
    end

    local took = os.clock()
    local err  = CompileString( code, "lua_editor", false ) -- CompileString is used to make sure there is no error on the code.
    took = ( os.clock() - took ) * 1000

    if type( err ) == "string" then
        local matchage, txt = err:match( "^lua_editor%:(%d+)%:(.*)" )
        local text = matchage and txt and ( "Line " .. matchage .. ":" .. txt ) or err or ""
        local match = err:match( " at line (%d)%)" ) or matchage

        local line = match and tonumber( match ) or false

        messages[#messages + 1] = {
            type = "error",
            row  = line and ( line - 1 ) or 0,
            text = err,
        }

        self.ErrorLine = line or 1
        self:SetErrorButton( text )
    elseif took > self.CTThreshold then
        self.ErrorLine = 0
        self:SetErrorButton( "Compiling took " .. math.Round( took, 2 ) .. " ms" )
    else
        self.ErrorLine = 0
        self:SetErrorButton( false )
    end

    self:SetErrors( messages )
end

function PANEL:FindFileByName( name )
    return file.Read( name, "GAME" ) or file.Read( self.SaveDirectory .. name .. ".txt", "DATA" )
end

function PANEL:ReloadPage( full )
    if not self:GetHasLoaded() then return end

    self:SaveSnippets()
    self.HTML:FCall( "location.reload(%s);", full and "true" or "" )
end

function PANEL:ShowBinds()
    self.HTML:FCall( "ShowBinds();" )
end

function PANEL:ShowMenu()
    self.HTML:FCall( "ShowMenu();" )
end

-- Events
function PANEL:OnContextMenu()
    local m = DermaMenu() -- This is a virtual, built-in menu.

    m:AddOption( "Copy", function()
        self:GetSelection( function( code )
            SetClipboardText( code )
        end )
    end ):SetImage( "icon16/page_copy.png" )

    m:AddSpacer()
    m:Open()
end

function PANEL:onmousedown()
    self.mdown = true
end

function PANEL:OnRemove()
    self:SaveSnippets()
    hook.Remove( "ShutDown", self )
end

function PANEL:OnLog( ... )
    Msg "Editor: " print( ... )
end

function PANEL:OnReady()
    self.LoadBtn:SetVisible( false )
    self:SetHasLoaded( true )
    self.Sessions = {} -- this fix a location.reload(); bug
    self.Snippets = {}

    self.HTML:FCall ( [[
        TogetherJSConfig_getUserName = function () {return %s;};
    ]], LocalPlayer():Nick() );

    -- Creating the JS functions to allow communications with the lua interface
    self.HTML:FCall [[
        document.body.onmousedown = function( evt ) {
            if (evt.button == 0 || evt.button == 1) {
                gmodinterface.onmousedown();
            };
        }
        window.addEventListener("hashchange", function(event) {
            console.log("HASH CHANGED: "+location.hash);
        }, false);


        document.addEventListener('contextmenu', function(e) {
            gmodinterface.OnContextMenu();
            e.preventDefault();
        }, false);

        var snippets = ace.require("ace/snippets").snippetManager;

        editor.sessions	  = editor.sessions	  || {};
        editor.addSession = editor.addSession || function( sessID, txt, mode ) {
            editor.sessions[ sessID ] = ace.createEditSession( txt, "ace/mode/" + mode );
        }
        editor.updateSnippetsList = editor.updateSnippetsList || function( mode ) {
            gmodinterface.InternalSnippetsUpdate( JSON.stringify( snippets.snippetNameMap[ mode || "glua" ] ) );
        }
        editor.addSnippet = editor.addSnippet || function( name, content, mode ) {
            snippets.register( { content:content, name:name, tabTrigger:name }, mode || "glua" );
            editor.updateSnippetsList();
        }
        editor.removeSnippet = editor.removeSnippet || function( name, mode ){
            snippets.unregister( snippets.snippetNameMap[ mode || "glua" ][ name ] );
            editor.updateSnippetsList();
        }

        editor.updateSnippetsList();
    ]]

    self:LoadConfigs()
    if self:GetDoLoadSnippets() then self:LoadSnippets( util.JSONToTable( self:GetCookie( "Snippets" ) or "" ) or {} ) end

    self:SetSession( "New" )
    self:ValidateCode()
    self:OnLoaded()
end

function PANEL:OnCode( code )
    self.has_set_code = true

    local sessName = self:GetSessionName()

    -- Saving the content after 0.7 seconds (so we don't save every keystrokes). 0.7s is an arbitrary amount.
    timer.Create( "lua_editor_autosave_" .. sessName, 0.7, 1, function()
        if not self then return end

        self:Save( code, sessName )
        self:ValidateCode( code )
    end )

    self.Sessions[sessName] = code
    self:OnCodeChanged( code, sessName )
end

-- Overrides
PANEL.OnFocus			= function() end
PANEL.OnLoaded 			= function() end
PANEL.OnCodeChanged		= function() end
PANEL.OnSessionAdded	= function() end
PANEL.OnSessionRemoved	= function() end
PANEL.OnSessionChanged  = function() end
PANEL.OnHTMLLoaded		= function() end

function PANEL:Save( code, filepath ) -- Saving the files on the system
    if not filepath or filepath:len() < 1 or not code then	return end
    if file.Read( filepath, "GAME" ) then					return end
    if code:len() < 1 then self:DeleteFile( filepath )		return end

    filepath = FormatFilepath( filepath )

    if filepath:match( "(.+)/" ) then
        file.CreateDir( self.SaveDirectory .. filepath:match( "(.+)/" ) )
    end

    file.Write( self.SaveDirectory .. filepath .. ".txt", code )
end

function PANEL:DeleteFile( filepath )
    local path = self.SaveDirectory .. FormatFilepath( filepath ) .. ".txt"

    if file.Exists( path, "DATA" ) then
        file.Delete( path )

        while filepath:match( "(.+)/.*$" ) do
            file.Delete( self.SaveDirectory .. filepath )
            filepath = filepath:match( "(.+)/.*$" )
        end
    end
end

function PANEL:LoadConfigs()
    if ( not self.HTML ) or not self:GetHasLoaded() then return end

    self:SetFontSize( self:GetCookie( "FontSize" ) )
    self:SetTheme( self:GetCookie( "Theme" ) )
    self:SetMode( self:GetCookie( "SyntaxMode" ) )
end

function PANEL:ReplaceSelection( content )
    if not self.HTML or not self:GetHasLoaded() then return end

    self.HTML:FCall( [[ReplaceSelection( %s );]],  content or ""  )
end

function PANEL:SetCode( content, sessionName )
    self.has_set_code = false

    if not self.HTML or not self:GetHasLoaded() then return end
    sessionName = sessionName or self:GetSessionName()

    self:SetSession( sessionName )
    self.HTML:FCall( [[editor.sessions[ %s ].getDocument().setValue( %s );]], sessionName,  content or ""  )
end

function PANEL:GetCode( sessionName )
    return self:GetHasLoaded() and self:GetSession( sessionName ) or ""
end

-- Snippets
function PANEL:InternalSnippetsUpdate( JTable ) -- Todo: support multi modes
    if not JTable then return end
    self.Snippets = {}

    for name, snippet in pairs( util.JSONToTable( JTable ) ) do
        self.Snippets[name] = snippet.content
    end
end

function PANEL:GetSnippets()
    return self.Snippets
end

function PANEL:AddSnippet( name, content, mode )
    if ( not self:GetHasLoaded() ) or ( not name ) or ( not content ) or self.Snippets[name] then return end
    self.HTML:FCall( [[ editor.addSnippet( %s, %s, %s ); ]], name,  content,  mode or "glua" )
end

function PANEL:LoadSnippets( snippets, mode )
    if not self:GetHasLoaded() then return end

    for name, content in pairs( snippets ) do
        self:AddSnippet( name, content, mode )
    end
end

function PANEL:RemoveSnippet( name, mode )
    if ( not self:GetHasLoaded() ) or ( not name ) then return end
    self.HTML:FCall( [[ editor.removeSnippet( %s , %s );]], name, mode or "glua" )
end

function PANEL:SaveSnippets()
    if not self:GetHasLoaded() or not self:GetDoSaveSnippets() then return end
    self:SetCookie( "Snippets", util.TableToJSON( self:GetSnippets() ) )
end

-- Sessions
function PANEL:AddSession( name, content )
    if not self.HTML or not self:GetHasLoaded() then return false end
    if not name or name:len() < 1 or self:GetSession( name ) ~= nil then return false end

    name    = FormatFilepath( name )
    content = content or self:FindFileByName( name ) or ""


    self.Sessions[name] = content
    self.HTML:FCall( [[editor.addSession( %s, %s, %s );]], name, content, self:GetMode() or "glua" )
    self:OnSessionAdded( name, content )
    return true
end

function PANEL:RemoveSession( name )
    if not self.Sessions[name] or not self:GetHasLoaded() then return false end

    self.HTML:FCall( [[delete editor.sessions[ %s ]; ]], name )
    self.Sessions[name] = nil
    self:OnSessionRemoved( name )
    return true
end

function PANEL:LoadSessions( sessions )
    if not self:GetHasLoaded() then return false end

    for name, path in pairs( sessions ) do

        local content = file.Read( path, "GAME" )

        if name ~= "Default"
            and name ~= "New"
            and name ~= "new"
            and ( not content or content:Trim() == "" or not content:find( "[%d%a]" ) ) then continue end

        self:AddSession( name, content )
    end
end

function PANEL:SetSession( name )
    if not self:GetHasLoaded() or not name then return end

    if not self.Sessions[name] then
        self:AddSession( name )
    end

    self.m_sSessName = name

    self.HTML:FCall( [[
        window.location.hash = '#'+encodeURIComponent(%s);
        editor.setSession( editor.sessions[%s] );
        editor.getSession().setUseWrapMode( false );
        editor.getSession().setUseSoftTabs( false );
        ]], name, name )

    self:ValidateCode()
    self:OnSessionChanged( name )
end

function PANEL:GetSessionName()
    return self.m_sSessName
end

function PANEL:GetSession( name )
    return self.Sessions[name or self:GetSessionName()]
end

-- Other
function PANEL:SetTheme( theme )
    self.m_sTheme = table.HasValue( self.Themes, theme ) and theme or "default"
    self:SetCookie( "Theme", self.m_sTheme )

    if self.HTML and self:GetHasLoaded() then
        self.HTML:FCall( [[ SetTheme( %s ); ]], self.m_sTheme )
    end

end

function PANEL:SetFontSize( size )
    self.m_iFontSize = tonumber( size or 12 )
    self:SetCookie( "FontSize", self.m_iFontSize )

    if self.HTML and self:GetHasLoaded() then
        self.HTML:FCall( [[ SetFontSize( %s ); ]],  tonumber( size or 12 ) )
    end

end

function PANEL:SetMode( mode )
    self.m_sMode = table.HasValue( self.Modes, mode ) and mode or "glua"
    self:SetCookie( "SyntaxMode", self.m_sMode )

    if self.HTML and self:GetHasLoaded() then self.HTML:FCall( [[ SetMode( %s ); ]], self.m_sMode ) end
end

function PANEL:SetErrorButton( text )
    if text then
        self.ErrBtn:SetText( text:gsub( "\r", "\\r" ):gsub( "\n", "\\n" ) )
        self.ErrBtn:SetVisible( true )
    else
        self.ErrBtn:SetVisible( false )
        self.ErrBtn:SetText( "" )
    end

    self:InvalidateLayout()
end

function PANEL:SetErrors( messages )
    self.HTML:FCall( "SetErrs(%s)", util.TableToJSON( messages ) )
end


vgui.Register( "lua_editor", PANEL, "EditablePanel" )
