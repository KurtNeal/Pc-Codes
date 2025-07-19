Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)

    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Player')

    self.r = -math.pi/2
    self.rv = 1.66*math.pi
    self.v = 0
    self.base_max_v = 100
    self.max_v = self.base_max_v
    self.a = 100

    -- Cycle
    self.cycle_timer = 0
    self.cycle_cooldown = 5

    -- Boost
    self.max_boost = 100
    self.boost = self.max_boost
    self.boosting = false
    self.can_boost = true
    self.boost_timer = 0
    self.boost_cooldown = 2

    -- HP
    self.max_hp = 100
    self.hp = self.max_hp

    -- Ammo
    self.max_ammo = 100
    self.ammo = self.max_ammo

    -- Attack
    self.shoot_timer = 0
    self.shoot_cooldown = 0.24
    self:setAttack('Neutral')

    input:bind('f4', function() self:die() end)

    -- Ship visuals
    self.ship = 'Fighter'
    self.polygons = {}

    if self.ship == 'Fighter' then
        self.polygons[1] = {
            self.w, 0,
            self.w/2, -self.w/2,
            -self.w/2, -self.w/2,
            -self.w, 0,
            -self.w/2, self.w/2,
            self.w/2, self.w/2
        }
        self.polygons[2] = {
            self.w/2, -self.w/2,
            0, -self.w,
            -self.w - self.w/2, -self.w,
            -3*self.w/4, -self.w/4,
            -self.w/2, -self.w/2,
        }
        self.polygons[3] = {
            self.w/2, self.w/2,
            -self.w/2, self.w/2,
            -3*self.w/4, self.w/4,
            -self.w - self.w/2, self.w,
            0, self.w,
        }
    elseif self.ship == 'Striker' then
        self.polygons[1] = {
            self.w, 0,
            self.w/2, -self.w/2,
            -self.w/2, -self.w/2,
            -self.w, 0,
            -self.w/2, self.w/2,
            self.w/2, self.w/2,
        }
        self.polygons[2] = {
            0, self.w/2,
            -self.w/4, self.w,
            0, self.w + self.w/2,
            self.w, self.w,
            0, 2*self.w,
            -self.w/2, self.w + self.w/2,
            -self.w, 0,
            -self.w/2, self.w/2,
        }
        self.polygons[3] = {
            0, -self.w/2,
            -self.w/4, -self.w,
            0, -self.w - self.w/2,
            self.w, -self.w,
            0, -2*self.w,
            -self.w/2, -self.w - self.w/2,
            -self.w, 0,
            -self.w/2, -self.w/2,
        }
    elseif self.ship == 'Squaren' then
        self.polygons[1] = {
            self.w/4, 0,
            self.w/2, -self.w/2,
            -self.w, -self.w/2,
            -self.w/2, 0,
            -self.w, self.w/2,
            self.w/2, self.w/2,
        }
        self.polygons[2] = {
            self.w/2, -self.w/2,
            0, -self.w,
            -self.w, -self.w,
            -self.w/2, -self.w/2,
        }
        self.polygons[3] = {
            self.w/2, self.w/2,
            -self.w/2, self.w/2,
           -self.w, self.w,
            0, self.w,
        }
    elseif self.ship == 'Swift' then
        self.polygons[1] = {
            self.w, 0,
            self.w/4, -self.w/3,
            0, -self.w/2,
            -self.w/2, -self.w/3,
            -self.w/4, 0,
            -self.w/2, self.w/3,
            0, self.w/2,
            self.w/4, self.w/3,
        }
    elseif self.ship == 'Tetron' then
        self.polygons[1] = {
            self.w, self.w/2,
            self.w/2, self.w/2,
            self.w/4, self.w/4,
            -self.w/4, self.w/4,
            -self.w/2, self.w/2,
            -self.w, self.w/2,
            -self.w, -self.w/2,
            -self.w/2, -self.w/2,
            -self.w/4, -self.w/4,
            self.w/4, -self.w/4,
            self.w/2, -self.w/2,
            self.w, -self.w/2,
        }
    elseif self.ship == 'Pavis' then
        self.polygons[1] = {
            0, self.w,
            self.w/4, self.w/4,
            self.w/6, -self.w/2,
            0, -self.w,
            -self.w/6, -self.w/2,
            -self.w/4, self.w/4,
        }
        self.polygons[2] = {
            -self.w/4, self.w/4,
            -self.w * 0.9, 0,
            -self.w/4, -self.w/4,
        }
        self.polygons[3] = {
            self.w/4, self.w/4,
            self.w * 0.9, 0,
            self.w/4, -self.w/4,
        }
    elseif self.ship == 'Verus' then
        self.polygons[1] = {
            self.w, 0,
            self.w/2, -self.w/2,
            -self.w/2, -self.w/2,
            -self.w, 0,
            -self.w/2, self.w/2,
            self.w/2, self.w/2
        }
        self.polygons[2] = {
            self.w, self.w/2,
            self.w/2, self.w * 1.2,
            -self.w/2, self.w * 1.2,
            -self.w, self.w/2,
        }
        self.polygons[3] = {
            self.w, -self.w/2,
            self.w/2, -self.w * 1.2,
            -self.w/2, -self.w * 1.2,
            -self.w, -self.w/2,
        }
    elseif self.ship == 'Interceptron' then
        self.polygons[1] = {
            -self.w, self.w/4,
            0, self.w/2,
            self.w, 0,
            0, -self.w/2,
            -self.w, -self.w/4,
        }
        self.polygons[2] = {
            self.w/2, -self.w/2,
            0, -self.w,
            -self.w, -self.w,
            -self.w/2, -self.w/2,
        }
        self.polygons[3] = {
            self.w/2, self.w/2,
            -self.w/2, self.w/2,
           -self.w, self.w,
            0, self.w,
        }
    elseif self.ship == 'Velioch' then
        self.polygons[1] = {
            self.w * 0.75, self.w / 3,
            self.w * 0.75, -self.w / 3,
            -self.w * 0.75, -self.w / 3,
            -self.w * 0.75, self.w / 3,
        }
        self.polygons[2] = {
            self.w/2, -self.w/2,
            0, -self.w,
            -self.w, -self.w,
            -self.w/2, -self.w/2,
        }
        self.polygons[3] = {
            self.w/2, self.w/2,
            -self.w/2, self.w/2,
           -self.w, self.w,
            0, self.w,
        }
    elseif self.ship == 'Dreadnought' then
        self.polygons[1] = {
            self.w, 0,
            self.w/2, self.w/2,
            0, self.w/3,
            -self.w, self.w/2,
            -self.w/2, 0,
            -self.w, -self.w/2,
            0, -self.w/3,
            self.w/2, -self.w/2,
        }
    elseif self.ship == 'Anthophila' then
        self.polygons[1] = {
            self.w * 1.2, 0,
            self.w/2, self.w/3,
            -self.w/4, self.w/2,
            -self.w, 0,
            -self.w/4, -self.w/2,
            self.w/2, -self.w/3,
        }
        self.polygons[2] = {
            -self.w/4, self.w/2,
            -self.w * 1.1, self.w * 0.6,
            -self.w, self.w/4,
        }
        self.polygons[3] = {
            -self.w/4, -self.w/2,
            -self.w * 1.1, -self.w * 0.6,
            -self.w, -self.w/4,
        }
    end

    -- Boost trail
    self.trail_color = skill_point_color 
    self.timer:every(0.01, function()
        if self.ship == 'Fighter' then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r - math.pi/2),
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r - math.pi/2),
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2),
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2),
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Striker' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1.0*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r - math.pi/2), 
            self.y - 1.0*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
            self.area:addGameObject('TrailParticle', 
            self.x - 1.0*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2), 
            self.y - 1.0*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Squaren' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1*self.w*math.cos(self.r) + 0*self.w*math.cos(self.r + math.pi/2),
            self.y - 1*self.w*math.sin(self.r) + 0*self.w*math.sin(self.r + math.pi/2),  
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Swift' then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.7*self.w*math.cos(self.r) + 0*self.w*math.cos(self.r + math.pi/2),
            self.y - 0.7*self.w*math.sin(self.r) + 0*self.w*math.sin(self.r + math.pi/2),  
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Tetron' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1.3*self.w*math.cos(self.r) + 0.3*self.w*math.cos(self.r - math.pi/2), 
            self.y - 1.3*self.w*math.sin(self.r) + 0.3*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
            self.area:addGameObject('TrailParticle', 
            self.x - 1.3*self.w*math.cos(self.r) + 0.3*self.w*math.cos(self.r + math.pi/2), 
            self.y - 1.3*self.w*math.sin(self.r) + 0.3*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Pavis' then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.5*self.w*math.cos(self.r) + 0.7*self.w*math.cos(self.r - math.pi/2), 
            self.y - 0.5*self.w*math.sin(self.r) + 0.7*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
            self.area:addGameObject('TrailParticle', 
            self.x - 0.5*self.w*math.cos(self.r) + 0.7*self.w*math.cos(self.r + math.pi/2), 
            self.y - 0.5*self.w*math.sin(self.r) + 0.7*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
            
        elseif self.ship == 'Verus' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1*self.w*math.cos(self.r) + 0.9*self.w*math.cos(self.r - math.pi/2), 
            self.y - 1*self.w*math.sin(self.r) + 0.9*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
            self.area:addGameObject('TrailParticle', 
            self.x - 1*self.w*math.cos(self.r) + 0.9*self.w*math.cos(self.r + math.pi/2), 
            self.y - 1*self.w*math.sin(self.r) + 0.9*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
        elseif self.ship == 'Interceptron' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1.2*self.w*math.cos(self.r) + 0*self.w*math.cos(self.r + math.pi/2),
            self.y - 1.2*self.w*math.sin(self.r) + 0*self.w*math.sin(self.r + math.pi/2),  
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Velioch' then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r - math.pi/2), 
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2), 
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
        elseif self.ship == 'Dreadnought' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1*self.w*math.cos(self.r) + 0*self.w*math.cos(self.r + math.pi/2),
            self.y - 1*self.w*math.sin(self.r) + 0*self.w*math.sin(self.r + math.pi/2),  
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Anthophila' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1.3*self.w*math.cos(self.r) + 0.3*self.w*math.cos(self.r - math.pi/2),
            self.y - 1.3*self.w*math.sin(self.r) + 0.3*self.w*math.sin(self.r - math.pi/2),
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
            self.area:addGameObject('TrailParticle', 
            self.x - 1.3*self.w*math.cos(self.r) + 0.3*self.w*math.cos(self.r + math.pi/2),
            self.y - 1.3*self.w*math.sin(self.r) + 0.3*self.w*math.sin(self.r + math.pi/2),
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
        end
    end)

    -- Flats
    self.flat_hp = 0
    self.flat_ammo = 0
    self.flat_boost = 0
    self.ammo_gain = 1

    -- Multipliers
    self.hp_multiplier = 1
    self.ammo_multiplier = 1
    self.boost_multiplier = 1
    self.aspd_multiplier = 1

    -- Chances
    self.launch_homing_projectile_on_ammo_pickup_chance = 10
    self.regain_hp_on_ammo_pickup_chance = 15
    self.regain_hp_on_sp_pickup_chance = 65
    self.spawn_haste_area_on_hp_pickup_chance = 50
    self.spawn_haste_area_on_sp_pickup_chance = 70

    -- treeToPlayer(self)
    self:setStats()
    self:generateChances()
end

function Player:setStats()
    -- HP
    self.max_hp = (self.max_hp + self.flat_hp)*self.hp_multiplier
    self.hp = self.max_hp
end

function Player:generateChances()
    self.chances = {}
    for k, v in pairs(self) do
        if k:find('_chance') and type(v) == 'number' then
      	    self.chances[k] = chanceList({true, math.ceil(v)}, {false, 100-math.ceil(v)})
      	end
    end
end

function Player:update(dt)
    Player.super.update(self, dt)

    -- Collision
    if self.x < 0 or self.x > gw then self:die() end
    if self.y < 0 or self.y > gh then self:die() end

    if self.collider:enter('Collectable') then
        local collision_data = self.collider:getEnterCollisionData('Collectable')
        local object = collision_data.collider:getObject()

        if object:is(Ammo) then
            object:die()
            self:addAmmo(5)
            self:onAmmoPickup()

        elseif object:is(Boost) then
            object:die()
            self:addBoost(25)

        elseif object:is(HP) then
            object:die()
            self:onHPPickup()
            self:addHP(25)

        elseif object:is(SkillPoint) then
            object:die()
            self:onSPPickup()
            current_room.score = current_room.score + 250
            addSp(1)
            
        elseif object:is(Attack) then
            object:die()
            current_room.score = current_room.score + 500
            self:setAttack(object.attack)

        end
    end

    if self.collider:enter('Enemy') then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()

        if object then 
            self:hit(30) 
        end
    end

    -- Cycle
    self.cycle_timer = self.cycle_timer + dt
    if self.cycle_timer > self.cycle_cooldown then
        self.cycle_timer = 0
        self:cycle()
    end

    -- Boost
    self.boost = math.min(self.boost + 10*dt, self.max_boost)
    self.boost_timer = self.boost_timer + dt
    if self.boost_timer > self.boost_cooldown then self.can_boost = true end
    self.max_v = self.base_max_v
    self.boosting = false
    if input:down('up') and self.boost > 1 and self.can_boost then 
        self.boosting = true
        self.max_v = 1.5*self.base_max_v 
        self.boost = self.boost - 50*dt
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
        end
    end
    if input:down('down') and self.boost > 1 and self.can_boost then 
        self.boosting = true
        self.max_v = 0.5*self.base_max_v 
        self.boost = self.boost - 50*dt
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
        end
    end
    self.trail_color = skill_point_color 
    if self.boosting then self.trail_color = boost_color end

    -- Shoot
    self.shoot_timer = self.shoot_timer + dt
    if self.shoot_timer > self.shoot_cooldown*self.aspd_multiplier then
        self.shoot_timer = 0
        self:shoot()
    end

    -- Movement
    if input:down('left') then self.r = self.r - self.rv*dt end
    if input:down('right') then self.r = self.r + self.rv*dt end
    self.v = math.min(self.v + self.a*dt, self.max_v)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
end

function Player:draw()
    pushRotate(self.x, self.y, self.r)
    love.graphics.setColor(default_color)
    for _, polygon in ipairs(self.polygons) do
        local points = fn.map(polygon, function(k, v)
            if k % 2 == 1 then
                return self.x + v + random(-1, 1)
            else
                return self.y + v + random(-1, 1)
            end
        end)
        love.graphics.polygon('line', points)
    end
    love.graphics.pop()
end

function Player:destroy()
    Player.super.destroy(self)
end

function Player:cycle()
    self.area:addGameObject('CycleEffect', self.x, self.y, {parent = self})
end

function Player:shoot()
    local d = 1.2*self.w
    self.area:addGameObject('ShootEffect', self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {player = self, d = d})
    
    if self.attack == 'Neutral' then
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack})

    elseif self.attack == 'Double' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi / 12), 
        self.y + 1.5*d*math.sin(self.r + math.pi / 12), {r = self.r + math.pi / 12, attack = self.attack})

        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r - math.pi / 12), 
        self.y + 1.5*d*math.sin(self.r - math.pi / 12), {r = self.r - math.pi / 12, attack = self.attack})

    elseif self.attack == 'Triple' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack})

        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi / 12), 
        self.y + 1.5*d*math.sin(self.r + math.pi / 12), {r = self.r + math.pi / 12, attack = self.attack})

        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r - math.pi / 12), 
        self.y + 1.5*d*math.sin(self.r - math.pi / 12), {r = self.r - math.pi / 12, attack = self.attack})

    elseif self.attack == 'Rapid' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack})

    elseif self.attack == 'Spread' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), 
        self.y + 1.5*d*math.sin(self.r), {r = self.r - random(- math.pi / 8,  math.pi / 8), attack = self.attack})

    elseif self.attack == 'Back' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack})

        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi / 1), 
        self.y + 1.5*d*math.sin(self.r + math.pi / 1), {r = self.r + math.pi / 1, attack = self.attack})

    elseif self.attack == 'Side' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack})

        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi / 2), 
        self.y + 1.5*d*math.sin(self.r + math.pi / 2), {r = self.r + math.pi / 2, attack = self.attack})

        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r - math.pi / 2), 
        self.y + 1.5*d*math.sin(self.r - math.pi / 2), {r = self.r - math.pi / 2, attack = self.attack})
    elseif self.attack == 'Homing' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack})
    end


    if self.ammo <= 0 then 
        self:setAttack('Neutral')
        self.ammo = self.max_ammo
    end
end

function Player:setAttack(attack)
    self.attack = attack
    self.shoot_cooldown = attacks[attack].cooldown
    self.ammo = self.max_ammo
end

function Player:hit(damage)
    if self.invincible then return end
    damage = damage or 5

    for i = 1, love.math.random(4, 8) do self.area:addGameObject('ExplodeParticle', self.x, self.y) end
    self:removeHP(damage)

    if damage >= 30 then
        self.invincible = true
        self.timer:after('invincibility', 2, function() self.invincible = false end)
        for i = 1, 50 do self.timer:after((i-1)*0.04, function() self.invisible = not self.invisible end) end
        self.timer:after(51*0.04, function() self.invisible = false end)

        camera:shake(6, 60, 0.2)
        flash(3)
        slow(0.25, 0.5)
    else
        camera:shake(3, 60, 0.1)
        flash(2)
        slow(0.75, 0.25)
    end
end

function Player:die()
    self.dead = true 
    flash(4)
    camera:shake(6, 60, 0.4)
    slow(0.15, 1)
    for i = 1, love.math.random(8, 12) do self.area:addGameObject('ExplodeParticle', self.x, self.y) end

    current_room:finish()
end

function Player:addAmmo(amount)
    self.ammo = math.max(math.min(self.ammo + amount*self.ammo_gain, self.max_ammo), 0)
    current_room.score = current_room.score + 50
end

function Player:addBoost(amount)
    self.boost = math.max(math.min(self.boost + amount, self.max_boost), 0)
    current_room.score = current_room.score + 150
end

function Player:addHP(amount)
    self.hp = math.max(math.min(self.hp + amount, self.max_hp), 0)
end

function Player:removeHP(amount)
    self.hp = self.hp - (amount or 5)
    if self.hp <= 0 then
        self.hp = 0
        self:die()
    end
end

function Player:onAmmoPickup()
    if self.chances.launch_homing_projectile_on_ammo_pickup_chance:next() then
        local d = 1.2*self.w
        self.area:addGameObject('Projectile', self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {r = self.r, attack = 'Homing'})
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', color = faded_skill_point_color})
    end

    if self.chances.regain_hp_on_ammo_pickup_chance:next() then
        self:addHP(25)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'HP Regain!', color = faded_hp_color})
    end
end

function Player:onSPPickup()
    if self.chances.regain_hp_on_sp_pickup_chance:next() then
        self:addHP(25)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'HP Regain!', color = faded_hp_color})
    end

    if self.chances.spawn_haste_area_on_sp_pickup_chance:next() then
        self.area:addGameObject('HasteArea', self.x, self.y)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Haste Area!', color = faded_ammo_color})
    end
end

function Player:onHPPickup()
    if self.chances.spawn_haste_area_on_hp_pickup_chance:next() then
        self.area:addGameObject('HasteArea', self.x, self.y)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Haste Area!', color = faded_ammo_color})
    end
end

function Player:enterHasteArea()
    self.inside_haste_area = true
    self.pre_haste_aspd_multiplier = self.aspd_multiplier
    self.aspd_multiplier = self.aspd_multiplier/2
end

function Player:exitHasteArea()
    self.inside_haste_area = false
    self.aspd_multiplier = self.pre_haste_aspd_multiplier
    self.pre_haste_aspd_multiplier = nil
end