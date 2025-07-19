Projectile = GameObject:extend()

function Projectile:new(area, x, y, opts)
    Projectile.super.new(self, area, x, y, opts)

    self.s = opts.s or 2.5
    self.v = opts.v or 200
    self.color = attacks[self.attack].color

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Projectile')
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

    self.damage = 100

    if self.attack == 'Homing' then
        self.timer:every(0.02, function()
            local r = Vector(self.collider:getLinearVelocity()):angle()
            self.area:addGameObject('TrailParticle', self.x - 1.0*self.s*math.cos(r), self.y - 1.0*self.s*math.sin(r), 
            {parent = self, r = random(1, 3), d = random(0.1, 0.15), color = skill_point_color}) 
        end)
    end
end

function Projectile:update(dt)
    Projectile.super.update(self, dt)

    -- Homing
    if self.attack == 'Homing' then
        -- Acquire new target
        if not self.target then
            local targets = self.area:getAllGameObjectsThat(function(e)
                for _, enemy in ipairs(enemies) do
                    if e:is(_G[enemy]) and (distance(e.x, e.y, self.x, self.y) < 400) then
                        return true
                    end
                end
            end)
            self.target = table.remove(targets, love.math.random(1, #targets))
        end
        if self.target and self.target.dead then self.target = nil end

        -- Move towards target
        if self.target then
            local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
            local angle = math.atan2(self.target.y - self.y, self.target.x - self.x)
            local to_target_heading = Vector(math.cos(angle), math.sin(angle)):normalized()
            local final_heading = (projectile_heading + 0.1*to_target_heading):normalized()
            self.collider:setLinearVelocity(self.v*final_heading.x, self.v*final_heading.y)
        end

    -- Normal movement
    else self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r)) end

    if self.collider:enter('Enemy') then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()

        if object then
            object:hit(self.damage)
            self:die()
        end
    end

    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end

end

function Projectile:draw()
    pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angleTo())
    if self.attack == 'Homing' then
        love.graphics.setColor(self.color)
        love.graphics.polygon('fill', self.x - 2*self.s, self.y, self.x, self.y - 1.5*self.s, self.x, self.y + 1.5*self.s)
        love.graphics.setColor(default_color)
        love.graphics.polygon('fill', self.x, self.y - 1.5*self.s, self.x, self.y + 1.5*self.s, self.x + 1.5*self.s, self.y)
    else
        love.graphics.setLineWidth(self.s - self.s/4)
        love.graphics.setColor(self.color)
        if self.attack == 'Spread' then love.graphics.setColor(table.random(all_colors)) end
        love.graphics.line(self.x - 2*self.s, self.y, self.x, self.y)
        love.graphics.setColor(default_color)
        love.graphics.line(self.x, self.y, self.x + 2*self.s, self.y)
        love.graphics.setLineWidth(1)
    end
    love.graphics.pop()
end

function Projectile:destroy()
    Projectile.super.destroy(self)
end

function Projectile:die()
    self.dead = true
    if self.attack == 'Spread' then self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, {color = table.random(all_colors), w = 3*self.s})
    else self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, {color = self.color or default_color, w = 3*self.s}) end
end

