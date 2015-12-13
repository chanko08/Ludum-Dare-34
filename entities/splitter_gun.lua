local SplitterGun = {}

local MAX_STREAMS = 50
local STREAM_SPACE = 10

local function create_split_bullet(gun, bullet_constructor)
    return function(start_x, start_y, start_dx, start_dy)

        local start_stream_y = start_y + gun.stream_splits*(STREAM_SPACE + gun.base_bullet_height)/2

        local dir = Vector(start_dx, start_dy)
        local angle_offset = 2*math.pi / gun.stream_splits
        bullet_constructor(start_x, start_y, start_dx, start_dy)
        local directions = {Vector(start_dx, start_dy)}
        local side = 1
        for i=2,gun.stream_splits do
            local bullet_dir = dir:rotated(angle_offset * side * math.floor(i/2))
            directions[i] = bullet_dir
            bullet_constructor(start_x, start_y, bullet_dir.x, bullet_dir.y)
            side = -1 * side
        end
        
    end
end

function SplitterGun.new(gun)
    if not gun.stream_splits then
        gun.stream_splits = 2 
        local create_bullet = gun.create_bullet
        gun.create_bullet = create_split_bullet(gun, create_bullet)    
    else
        gun.stream_splits = math.min(gun.stream_splits + 1, MAX_STREAMS)
    end

    return gun
end

return SplitterGun