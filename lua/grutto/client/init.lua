GRUTTO.Colors = {
    ERROR = Color( 255, 0, 0 ),
    CONSOLE_TEXT = Color( 50, 50, 50 ),
    CONSOLE_CLIENT = Color( 231, 219, 116 ),
    CONSOLE_SERVER = Color( 145, 219, 232 ),
    EDITOR_BACKGROUND = Color( 40, 44, 52 ),
    EDITOR_SIDEBAR = Color( 33, 37, 43 )
}

include( "grutto/client/panels/grutto_editor.lua" )
include( "grutto/client/panels/grutto_editor_tabs.lua" )
include( "grutto/client/panels/grutto_console.lua" )
include( "grutto/client/panels/grutto_sidebar.lua" )
include( "grutto/client/panels/grutto_topbar.lua" )
include( "grutto/client/runcode.lua" )
include( "grutto/client/autocomplete.lua" )
include( "grutto/client/cache.lua" )
include( "grutto/client/editor.lua" )
