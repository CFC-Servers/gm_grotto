function GRUTTO.CanRunSV( ply )
    if ply:IsSuperAdmin() then
        return true
    end
end

function GRUTTO.CanRunCL( ply )
    if ply:IsSuperAdmin() then
        return true
    end
end

function GRUTTO.CanOpen( ply )
    if ply:IsSuperAdmin() then
        return true
    end
end
