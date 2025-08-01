local Gamestate = require 'vendor/gamestate'
local window = require 'ui/window'
local Circle = require 'system/drawables/circle'
local Rect = require 'system/drawables/rect'
local VideoSettings = require 'system/video_settings'

local room = Gamestate.new()

function room:init()
    -- Room dimensions
    self.room_width = window.width - 100
    self.room_height = window.height - 100
    self.room_x = 50
    self.room_y = 50
    
    -- Wall thickness
    self.wall_thickness = 10
    self.door_width = 80
    
    -- Create walls with doors
    self:createWalls()
    
    -- Create player in center
    self.player = Circle:new(
        window.width / 2,
        window.height / 2,
        15
    )
    
    -- Player movement
    self.player_speed = 200 -- pixels per second
    
    -- Input state
    self.keys = {}
end

function room:createWalls()
    self.walls = {}
    self.doors = {}
    
    -- Calculate door positions (centered on each wall)
    local door_offset = (self.room_width - self.door_width) / 2
    local door_offset_v = (self.room_height - self.door_width) / 2
    
    -- Top wall (with door)
    table.insert(self.walls, Rect:new(self.room_x, self.room_y, door_offset, self.wall_thickness))
    table.insert(self.walls, Rect:new(self.room_x + door_offset + self.door_width, self.room_y, door_offset, self.wall_thickness))
    self.doors.top = {
        x = self.room_x + door_offset,
        y = self.room_y,
        width = self.door_width,
        height = self.wall_thickness
    }
    
    -- Bottom wall (with door)
    local bottom_y = self.room_y + self.room_height - self.wall_thickness
    table.insert(self.walls, Rect:new(self.room_x, bottom_y, door_offset, self.wall_thickness))
    table.insert(self.walls, Rect:new(self.room_x + door_offset + self.door_width, bottom_y, door_offset, self.wall_thickness))
    self.doors.bottom = {
        x = self.room_x + door_offset,
        y = bottom_y,
        width = self.door_width,
        height = self.wall_thickness
    }
    
    -- Left wall (with door)
    table.insert(self.walls, Rect:new(self.room_x, self.room_y, self.wall_thickness, door_offset_v))
    table.insert(self.walls, Rect:new(self.room_x, self.room_y + door_offset_v + self.door_width, self.wall_thickness, door_offset_v))
    self.doors.left = {
        x = self.room_x,
        y = self.room_y + door_offset_v,
        width = self.wall_thickness,
        height = self.door_width
    }
    
    -- Right wall (with door)
    local right_x = self.room_x + self.room_width - self.wall_thickness
    table.insert(self.walls, Rect:new(right_x, self.room_y, self.wall_thickness, door_offset_v))
    table.insert(self.walls, Rect:new(right_x, self.room_y + door_offset_v + self.door_width, self.wall_thickness, door_offset_v))
    self.doors.right = {
        x = right_x,
        y = self.room_y + door_offset_v,
        width = self.wall_thickness,
        height = self.door_width
    }
end

function room:enter()
    print('Entering room scene')
end

function room:leave()
    print('Leaving room scene')
end

function room:update(dt)
    -- Update shared video settings
    VideoSettings:update(dt)
    
    -- Handle player movement
    self:updatePlayerMovement(dt)
    
    -- Check door interactions
    self:checkDoorInteractions()
end

function room:updatePlayerMovement(dt)
    local dx, dy = 0, 0
    
    -- Check input
    if self.keys['w'] or self.keys['up'] then
        dy = -1
    end
    if self.keys['s'] or self.keys['down'] then
        dy = 1
    end
    if self.keys['a'] or self.keys['left'] then
        dx = -1
    end
    if self.keys['d'] or self.keys['right'] then
        dx = 1
    end
    
    -- Normalize diagonal movement
    if dx ~= 0 and dy ~= 0 then
        dx = dx * 0.707  -- 1/sqrt(2)
        dy = dy * 0.707
    end
    
    -- Apply movement
    local new_x = self.player.x + dx * self.player_speed * dt
    local new_y = self.player.y + dy * self.player_speed * dt
    
    -- Check wall collisions
    if not self:checkWallCollision(new_x, self.player.y) then
        self.player.x = new_x
    end
    if not self:checkWallCollision(self.player.x, new_y) then
        self.player.y = new_y
    end
end

function room:checkWallCollision(x, y)
    local player_radius = self.player.r
    
    for _, wall in ipairs(self.walls) do
        -- Simple AABB vs circle collision
        local closest_x = math.max(wall.x, math.min(x, wall.x + wall.w))
        local closest_y = math.max(wall.y, math.min(y, wall.y + wall.h))
        
        local distance_x = x - closest_x
        local distance_y = y - closest_y
        local distance_squared = distance_x * distance_x + distance_y * distance_y
        
        if distance_squared < (player_radius * player_radius) then
            return true -- Collision detected
        end
    end
    
    return false
end

function room:checkDoorInteractions()
    local player_x, player_y = self.player.x, self.player.y
    local player_radius = self.player.r
    
    -- Check each door
    for door_name, door in pairs(self.doors) do
        local door_center_x = door.x + door.width / 2
        local door_center_y = door.y + door.height / 2
        
        local distance = math.sqrt((player_x - door_center_x)^2 + (player_y - door_center_y)^2)
        
        if distance < player_radius + 20 then -- Close to door
            self:triggerDoor(door_name)
        end
    end
end

function room:triggerDoor(door_name)
    print("Player approached " .. door_name .. " door!")
    -- Reset player position to center
    self.player.x = window.width / 2
    self.player.y = window.height / 2
end

function room:draw()
    VideoSettings:draw()
    
    love.graphics.push()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.2, 1)
    
    -- Draw walls
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    for _, wall in ipairs(self.walls) do
        wall:draw()
    end
    
    -- Draw doors (different color)
    love.graphics.setColor(0.4, 0.7, 0.4, 1)
    for door_name, door in pairs(self.doors) do
        love.graphics.rectangle('fill', door.x, door.y, door.width, door.height)
    end
    
    -- Draw player
    love.graphics.setColor(1, 0.5, 0.2, 1) -- Orange player
    self.player:draw()
    
    -- Draw instructions
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(12))
    love.graphics.print("WASD/Arrow Keys: Move", 10, window.height - 40)
    love.graphics.print("Walk to doors to trigger events", 10, window.height - 20)
    love.graphics.print("ESC: Return to intro", 10, window.height - 60)
    
    love.graphics.pop()
end

function room:keypressed(key)
    self.keys[key] = true
    
    if key == 'escape' then
        Gamestate.switch('scenes/intro_scene')
        return true
    end
end

function room:keyreleased(key)
    self.keys[key] = false
end

return room