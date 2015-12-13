local SplitterGun = {}

local MAX_STREAMS = 10
local STREAM_SPACE = 10

local function create_split_bullet(gun, bullet_constructor)
    return function(start_x, start_y, start_dx, start_dy)

        local start_stream_y = start_y + gun.stream_splits*(STREAM_SPACE + gun.base_bullet_height)/2
        for i=1,gun.stream_splits do
            bullet_constructor(start_x, start_stream_y - (STREAM_SPACE + gun.base_bullet_height) * (i - 1), start_dx, start_dy)

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