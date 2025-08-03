ExplodeEffect = GameObject:extend()

function ExplodeEffect:new(area, x, y, opts)
    ExplodeEffect.super.new(self, area, x, y, opts)

    self.color = opts.color or default_color
    self.s = opts.s or 5.5
    self.w, self.h = 48, 48
    self.y_offset = 0
    self.timer:tween(0.30, self, {h = 0, w = 0}, 'in-out-elastic', function() self.dead = true end)
    
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, 2.5*self.w, 2.5*self.h)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Projectile')

    self.damage = 100
end

function ExplodeEffect:update(dt)
    ExplodeEffect.super.update(self, dt)
    if self.parent then self.x, self.y = self.parent.x, self.parent.y - self.y_offset end

    if self.collider:enter('Enemy') then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()

        if object then
            object:hit(self.damage)
        end
    end
end

function ExplodeEffect:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x - self.w / 2, self.y - self.h / 2, self.w, self.h)
    love.graphics.setColor(1, 1, 1)
end

function ExplodeEffect:destroy()
    ExplodeEffect.super.destroy(self)
end