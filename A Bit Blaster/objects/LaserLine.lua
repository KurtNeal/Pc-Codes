LaserLine = GameObject:extend()

function LaserLine:new(area, x, y, opts)
    LaserLine.super.new(self, area, x, y, opts)

    self.color = opts.color or hp_color
    self.r = opts.r or 0
    self.v = opts.v or 200
    self.x, self.y = current_room.player.x + 1.5*math.cos(self.r), current_room.player.y + 1.5*math.sin(self.r)
    self.w, self.h = 48*current_room.player.area_multiplier, 48*current_room.player.area_multiplier
    self.y_offset = 1
    self.timer:tween(0.30, self, {h = 0, w = 0}, 'in-out-elastic', function() self.dead = true end)
    
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Projectile')
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

    self.damage = 100
end

function LaserLine:update(dt)
    LaserLine.super.update(self, dt)

    if self.collider:enter('Enemy') then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()

        if object then
            object:hit(self.damage)
        end
    end
end

function LaserLine:draw()
    pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angle())

    love.graphics.setColor(default_color)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1)
    love.graphics.pop()
end

function LaserLine:destroy()
    LaserLine.super.destroy(self)
end