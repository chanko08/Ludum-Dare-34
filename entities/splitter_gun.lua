local SplitterGun = {}

local MAX_STREAMS = 50
local STREAM_SPACE = 10
local SPLITTER_ADJECTIVES = {
    'splitting',
    'halving',
    'tridented',
    'clefting',
    'slashing',
    'slitting',
    'ripping',
    'dividing',
    'tearing',
    'bisecting',
    'cleaving',
    'forking',
    'cutting',
    'furcating',
    'pronged',
    'dichotic',
    'branched',
    'angled',
    'bifid',
    'divaricating',
    'seperating',
    'dimidiating',
    'bifurcating',
    'crossed',
    'hemisecting',
    'dichotimizing',
    'tined',
    'zigzaggin',
    'brain clefting',
    'world cutting',
    'planet tearing',
    'universe forking',
    'sun splitting',
    'sea dividing',
    'omega ripper',
    'gamedev slitting',
    'trifisting',
    'storm brewing',
    'tornado rending',
    'baby tears slashing',
    'right angled',
    'universe fractal producer',
    'multiverse extacter',
    'destiny cutting',
    'furry animal bifurcating',
    'beach ball hemisecting',
    'EXPLOSION OF FUR AND CLAWS',
    'INFINITY PRODUCER',
    'INFINITY MULTIVERSE EXPLOSIONATOR',
    'TIME CLEFT INFINITY TRIFISTER'
}
local function create_splitter_name( gun, name_constructor )
    return function()
        --print('here')
        return SPLITTER_ADJECTIVES[gun.stream_splits] .. " " .. name_constructor()
    end
end

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

        local create_name = gun.create_name
        gun.create_name = create_splitter_name(gun, create_name)    
    else
        gun.stream_splits = math.min(gun.stream_splits + 1, MAX_STREAMS)
    end

    return gun
end

return SplitterGun