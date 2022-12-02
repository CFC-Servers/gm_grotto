local PANEL = {}

function PANEL:Paint()
    return true
end

vgui.Register( "grutto_topbar", PANEL, "DPanel" )
