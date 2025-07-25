CycleEffect = GameObject:extend()

function CycleEffect:new(area, x, y, opts)
    CycleEffect.super.new(self, area, x, y, opts)
    self.depth = 75

    self.w, self.h = 48, 32
    self.y_offset = 0
    self.timer:tween(0.13, self, {h = 0, y_offset = 32}, 'in-out-cubic', function() self.dead = true end)
end

function CycleEffect:update(dt)
    CycleEffect.super.update(self, dt)
    if self.parent then self.x, self.y = self.parent.x, self.parent.y - self.y_offset end
end

function CycleEffect:draw()
    love.graphics.setColor(default_color)
    love.graphics.rectangle('fill', self.x - self.w / 2, self.y, self.w, self.h)
    love.graphics.setColor(1, 1, 1)
end

function CycleEffect:destroy()
    CycleEffect.super.destroy(self)
end