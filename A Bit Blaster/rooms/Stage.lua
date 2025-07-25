Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile', 'Player'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
    self.area.world:addCollisionClass('EnemyProjectile', {ignores = {'EnemyProjectile', 'Projectile', 'Enemy'}})

    self.font = fonts.m5x7_16
    self.director = Director(self)

    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.player = self.area:addGameObject('Player', gw / 2, gh / 2)

    self.score = 0

    input:bind('p', function() self.area:addGameObject('Ammo', random(0, gw), random(0, gh)) end)
    input:bind('o', function() self.area:addGameObject('Boost', 0, 0) end)
    input:bind('i', function() self.area:addGameObject('HP', 0, 0) end)
    input:bind('l', function() self.area:addGameObject('SkillPoint', 0, 0) end)
    input:bind('k', function() self.area:addGameObject('Attack', 0, 0) end)
    input:bind('0', function() self.area:addGameObject('Rock', 0, 0) end)
    input:bind('9', function() self.area:addGameObject('Shooter', 0, 0) end)
end

function Stage:update(dt)
    self.director:update(dt)

    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw / 2, gh / 2)

    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
        camera:attach(0, 0, gw, gh)
        self.area:draw()
        camera:detach()

        love.graphics.setFont(self.font)

        -- Score
        love.graphics.setColor(default_color)
        love.graphics.print(self.score, gw - 20, 10, 0, 1, 1, math.floor(self.font:getWidth(self.score) / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.setColor(1, 1, 1)

        -- Skill Points
        love.graphics.setColor(skill_point_color)
        love.graphics.print(skill_points .. 'SP', gw - 470, 10, 0, 1, 1, math.floor(self.font:getWidth(skill_points) / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.setColor(1, 1, 1)

        -- HP
        local r, g, b = unpack(hp_color)
        local hp, max_hp = self.player.hp, self.player.max_hp
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw / 2 - 52, gh - 16, 48*(hp/max_hp), 4)
        love.graphics.setColor(r - 0.125, g - 0.125, b - 0.125)
        love.graphics.rectangle('line', gw / 2 - 52, gh - 16, 48, 4)
        love.graphics.print('HP', gw / 2 - 52 + 24, gh - 24, 0, 1, 1, math.floor(self.font:getWidth('HP') / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.print(hp .. '/' .. max_hp, gw / 2 - 52 + 24, gh - 6, 0, 1, 1, math.floor(self.font:getWidth(hp .. '/' .. max_hp) / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.setColor(1, 1, 1, 1)

        -- Ammo
        local r, g, b = unpack(ammo_color)
        local ammo, max_ammo = self.player.ammo, self.player.max_ammo
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw / 2 - 52, gh - 258, 48*(ammo/max_ammo), 4)
        love.graphics.setColor(r - 0.125, g - 0.125, b - 0.125)
        love.graphics.rectangle('line', gw / 2 - 52, gh - 258, 48, 4)
        love.graphics.print('Ammo', gw / 2 - 52 + 16, gh - 249, 0, 1, 1, math.floor(self.font:getWidth('HP') / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.print(ammo .. '/' .. max_ammo, gw / 2 - 52 + 24, gh - 265, 0, 1, 1, math.floor(self.font:getWidth(ammo .. '/' .. max_ammo) / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.setColor(1, 1, 1, 1)

        -- Boost
        local r, g, b = unpack(boost_color)
        local boost, max_boost = self.player.boost, self.player.max_boost
        boost = math.floor(boost)
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw / 2 + 4, gh - 258, 48*(boost/max_boost), 4)
        love.graphics.setColor(r - 0.125, g - 0.125, b - 0.125)
        love.graphics.rectangle('line', gw / 2 + 4, gh - 258, 48, 4)
        love.graphics.print('Boost', gw / 2 + 27, gh - 249, 0, 1, 1, math.floor(self.font:getWidth('Boost') / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.print(boost .. '/' .. max_boost, gw / 2 + 4 + 24, gh - 265, 0, 1, 1, math.floor(self.font:getWidth(boost .. '/' .. max_boost) / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.setColor(1, 1, 1, 1)

        -- Cycle
        local r, g, b = unpack(default_color)
        local cycle_timer, cycle_cooldown = self.player.cycle_timer, self.player.cycle_cooldown
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw / 2 + 4, gh - 16, 48*(cycle_timer/cycle_cooldown), 4)
        love.graphics.setColor(r - 0.125, g - 0.125, b - 0.125)
        love.graphics.rectangle('line', gw / 2 + 4, gh - 16, 48, 4)
        love.graphics.print('Cycle', gw / 2 + 4 + 24, gh - 24, 0, 1, 1, math.floor(self.font:getWidth('Cycle') / 2), math.floor(self.font:getHeight() / 2))
    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
    self.player = nil
end

function Stage:finish()
    timer:after(1, function() gotoRoom('Stage') end)
end
