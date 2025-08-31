BigRock = GameObject:extend()

function BigRock:new(area, x, y, opts)
    BigRock.super.new(self, area, x, y, opts)

    local direction = table.random({-1, 1})
    self.x = gw / 2 + direction*(gw / 2 + 48)
    self.y = random(16, gh - 16)

    self.w, self.h = 16, 16
    self.collider = self.area.world:newPolygonCollider(createIrregularPolygon(16))
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)
    self.v = -direction*random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(random(-100, 100))

    self.hp = 300
end

function BigRock:update(dt)
    BigRock.super.update(self, dt)

    self.collider:setLinearVelocity(self.v, 0)
end

function BigRock:draw()
    love.graphics.setColor(rock_color)
    if self.hit_flash then love.graphics.setColor(default_color) end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(default_color)
end

function BigRock:destroy()
    BigRock.super.destroy(self)
end

function BigRock:hit(damage)
    self.hp = self.hp - (damage or 100)
    if self.hp <= 0 then
        self.dead = true
        current_room.score = current_room.score + 100
        self.area:addGameObject('EnemyDeathEffect', self.x, self.y, {color = BigRock_color, w = 3*self.w})
        if current_room.player.no_ammo_drop == false then
            if current_room.player.double_ammo_drop then
                self.area:addGameObject('Ammo', self.x, self.y)
                self.area:addGameObject('Ammo', self.x, self.y)
            else
                self.area:addGameObject('Ammo', self.x, self.y)
            end
        end
        for i = 1, 4 do
            self.area:addGameObject('Rock', self.x, self.y, {x = self.x, y = self.y, v = self.v})
        end
    else
        self.hit_flash = true
        self.timer:after('hit_flash', 0.2, function() self.hit_flash = false end)
    end
end