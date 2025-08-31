Waver = GameObject:extend()

function Waver:new(area, x, y, opts)
    Waver.super.new(self, area, x, y, opts)

    local spawn_direction = table.random({-1, 1})
    self.x = gw / 2 + spawn_direction*(gw / 2 + 48)
    self.y = random(16, gh - 16)

    self.w, self.h = 8, 4
    self.collider = self.area.world:newPolygonCollider({self.w, 0, -self.w/2, self.h, -self.w*2, 0, -self.w/2, -self.h})
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.v = -spawn_direction*random(20, 40)
    self.collider:setFixedRotation(false)
    self.collider:setAngle(spawn_direction == 1 and math.pi or 0)
    self.collider:setFixedRotation(true)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(random(-100, 100))

    self.hp = 70

    self.timer:every(1.5, function() self.area:addGameObject('EnemyProjectile', 
        self.x + 1.4*self.w*math.cos(self.collider:getAngle()),
        self.y + 1.4*self.w*math.sin(self.collider:getAngle()),
        {r = math.atan2(current_room.player.y - self.y, current_room.player.x - self.x), v = random(80, 100), s = 3.5})

    end)

    self.timer:tween(0.25, self, {r = self.r + spawn_direction*math.pi / 8}, 'linear', function()
        self.timer:tween(0.25, self, {r = self.r - spawn_direction*math.pi / 4}, 'linear')
    end)
    self.timer:every(0.75, function()
        self.timer:tween(0.25, self, {r = self.r + spawn_direction*math.pi / 4}, 'linear', function()
            self.timer:tween(0.5, self, {r = self.r - spawn_direction*math.pi / 4}, 'linear')
        end)
    end)
end

function Waver:update(dt)
    Waver.super.update(self, dt)

    self.collider:setLinearVelocity(self.v, 0)
end

function Waver:draw()
    love.graphics.setColor(rock_color)
    if self.hit_flash then love.graphics.setColor(default_color) end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(default_color)
end

function Waver:destroy()
    Waver.super.destroy(self)
end

function Waver:hit(damage)
    self.hp = self.hp - (damage or 100)
    if self.hp <= 0 then
        self.dead = true
        current_room.score = current_room.score + 150
        self.area:addGameObject('EnemyDeathEffect', self.x, self.y, {color = rock_color, w = 3*self.w})
        if current_room.player.no_ammo_drop == false then
            if current_room.player.double_ammo_drop then
                self.area:addGameObject('Ammo', self.x, self.y)
                self.area:addGameObject('Ammo', self.x, self.y)
            else
                self.area:addGameObject('Ammo', self.x, self.y)
            end
        end
    else
        self.hit_flash = true
        self.timer:after('hit_flash', 0.2, function() self.hit_flash = false end)
    end
end