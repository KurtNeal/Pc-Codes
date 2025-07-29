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
    self:setAttack('2Split')

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
    self.ammo_gain = 0

    -- Multipliers
    self.hp_multiplier = 1
    self.ammo_multiplier = 1
    self.boost_multiplier = 1
    self.hp_spawn_chance_multiplier = 1
    self.sp_spawn_chance_multiplier = 1
    self.boost_spawn_chance_multiplier = 1
    self.base_aspd_multiplier = 1
    self.aspd_multiplier = Stat(1)
    self.base_mvspd_multiplier = 1
    self.mvspd_multiplier = Stat(1)
    self.base_pspd_multiplier = 1
    self.pspd_multiplier = Stat(1)
    self.cycle_speed_multiplier = Stat(1)
    self.luck_multiplier = 1
    self.enemy_spawn_rate_multiplier = 1
    self.resource_spawn_rate_multiplier = 1
    self.attack_spawn_rate_multiplier = 1
    self.turn_rate_multiplier = 1
    self.boost_effectiveness_multiplier = 1
    self.projectile_size_multiplier = 1
    self.boost_recharge_rate_multiplier = 1
    self.invulnerability_time_multiplier = 1
    self.ammo_consumption_multiplier = 1
    self.size_multiplier = 1
    self.stat_boost_duration_multiplier = 1
    self.angle_change_frequency_multiplier = 1
    self.projectile_acceleration_multiplier = 1
    self.projectile_deceleration_multiplier = 1
    self.projectile_duration_multiplier = 1


    -- Chances
    self.launch_homing_projectile_on_ammo_pickup_chance = 10
    self.launch_homing_projectile_on_cycle_chance = 5
    self.launch_homing_projectile_on_kill_chance = 3
    self.launch_homing_projectile_while_boosting_chance = 3
    self.regain_hp_on_ammo_pickup_chance = 15
    self.regain_hp_on_sp_pickup_chance = 65
    self.regain_hp_on_cycle_chance = 5
    self.regain_ammo_on_kill_chance = 5
    self.regain_full_ammo_on_cycle_chance = 5
    self.regain_boost_on_kill_chance = 10
    self.gain_aspd_boost_on_kill_chance = 3
    self.gain_double_sp_chance = 5
    self.spawn_haste_area_on_hp_pickup_chance = 45
    self.spawn_haste_area_on_sp_pickup_chance = 65
    self.spawn_haste_area_on_cycle_chance = 5
    self.spawn_sp_on_cycle_chance = 3
    self.spawn_hp_on_cycle_chance = 3
    self.spawn_boost_on_kill_chance = 3
    self.spawn_double_hp_chance = 5
    self.spawn_double_sp_chance = 5
    self.barrage_on_kill_chance = 5
    self.barrage_on_cycle_chance = 5
    self.change_attack_on_cycle_chance = 10
    self.mvspd_boost_on_cycle_chance = 5
    self.pspd_boost_on_cycle_chance = 5
    self.pspd_inhibit_on_cycle_chance = 10
    self.increased_cycle_speed_while_boosting_chance = 3
    self.increased_luck_while_boosting_chance = 3
    self.invulnerability_while_boosting_chance = 3
    self.drop_double_ammo_chance = 5
    self.attack_twice_chance = 5
    self.shield_projectile_chance = 10

    -- Booleans
    self.increased_luck_while_boosting = false
    self.projectile_ninety_degree_change = false
    self.projectile_random_degree_change = false
    self.wavy_projectiles = false
    self.fast_slow_projectiles = false
    self.slow_fast_projectiles = false

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
      	    self.chances[k] = chanceList(
            {true, math.ceil(v*self.luck_multiplier)}, {false, 100-math.ceil(v*self.luck_multiplier)})
        end
    end
end

function Player:update(dt)
    Player.super.update(self, dt)

    if self.inside_haste_area then self.aspd_multiplier:increase(100) end
    if self.aspd_boosting then self.aspd_multiplier:increase(100) end
    self.aspd_multiplier:update(dt)

    if self.mvspd_boosting then self.mvspd_multiplier:increase(50) end
    self.mvspd_multiplier:update(dt)

    if self.pspd_boosting then self.pspd_multiplier:increase(100) end
    if self.pspd_inhibit then self.pspd_multiplier:decrease(50) end
    self.pspd_multiplier:update(dt)

    if self.cycle_speeding then self.cycle_speed_multiplier:increase(200) end
    self.cycle_speed_multiplier:update(dt)

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
            if self.gain_double_sp == true then addSp(2) else addSp(1) end
            
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
    if self.cycle_timer > self.cycle_cooldown/self.cycle_speed_multiplier.value then
        self.cycle_timer = 0
        self:cycle()
    end

    -- Boost
    self.boost = math.min(self.boost + 10*dt*self.boost_recharge_rate_multiplier, self.max_boost)
    self.boost_timer = self.boost_timer + dt
    if self.boost_timer > self.boost_cooldown then self.can_boost = true end
    self.max_v = self.base_max_v
    self.boosting = false
    if input:pressed('up') and self.boost > 1 and self.can_boost then self:onBoostStart() end
    if input:released('up') then self:onBoostEnd() end
    if input:down('up') and self.boost > 1 and self.can_boost then 
        self.boosting = true
        self.max_v = 1.5*self.base_max_v 
        self.boost = self.boost - 50*dt*self.boost_effectiveness_multiplier
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
            self:onBoostEnd()
        end
    end
    if input:pressed('down') and self.boost > 1 and self.can_boost then self:onBoostStart() end
    if input:released('down') then self:onBoostEnd() end
    if input:down('down') and self.boost > 1 and self.can_boost then 
        self.boosting = true
        self.max_v = 0.5*self.base_max_v 
        self.boost = self.boost - 50*dt*self.boost_effectiveness_multiplier
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
            self:onBoostEnd()
        end
    end
    self.trail_color = skill_point_color 
    if self.boosting then self.trail_color = boost_color end

    -- Shoot
    self.shoot_timer = self.shoot_timer + dt
    if self.shoot_timer > self.shoot_cooldown/self.aspd_multiplier.value then
        self.shoot_timer = 0
        self:shoot()
        self.timer:after(0.09, function() if self.attack_twice then self:shoot() end end)
    end

    -- Movement
    if input:down('left') then self.r = self.r - self.rv*dt*self.turn_rate_multiplier end
    if input:down('right') then self.r = self.r + self.rv*dt*self.turn_rate_multiplier end
    self.v = math.min(self.v + self.a*dt, self.max_v)*self.mvspd_multiplier.value
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
    self:onCycle()
end

function Player:shoot()
    local d = 1.2*self.w
    self.area:addGameObject('ShootEffect', self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {player = self, d = d})

    local mods = {
        shield = self.chances.shield_projectile_chance:next()
    }
    
    if self.attack == 'Neutral' then
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

    elseif self.attack == 'Double' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi / 12), 
        self.y + 1.5*d*math.sin(self.r + math.pi / 12), table.merge({r = self.r - math.pi / 12, attack = self.attack}, mods))

        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r - math.pi / 12), 
        self.y + 1.5*d*math.sin(self.r - math.pi / 12), table.merge({r = self.r - math.pi / 12, attack = self.attack}, mods))

    elseif self.attack == 'Triple' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi / 12), 
        self.y + 1.5*d*math.sin(self.r + math.pi / 12), table.merge({r = self.r + math.pi / 12, attack = self.attack}, mods))

        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r - math.pi / 12), 
        self.y + 1.5*d*math.sin(self.r - math.pi / 12), table.merge({r = self.r - math.pi / 12, attack = self.attack}, mods))

    elseif self.attack == 'Rapid' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

    elseif self.attack == 'Spread' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), 
        self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r - random(- math.pi / 8,  math.pi / 8), attack = self.attack}, mods))

    elseif self.attack == 'Back' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi / 1), 
        self.y + 1.5*d*math.sin(self.r + math.pi / 1), table.merge({r = self.r + math.pi / 1, attack = self.attack}, mods))

    elseif self.attack == 'Side' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi / 2), 
        self.y + 1.5*d*math.sin(self.r + math.pi / 2), table.merge({r = self.r + math.pi / 2, attack = self.attack}, mods))

        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r - math.pi / 2), 
        self.y + 1.5*d*math.sin(self.r - math.pi / 2), table.merge({r = self.r - math.pi / 2, attack = self.attack}, mods))

    elseif self.attack == 'Homing' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

    elseif self.attack == 'Blast' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        for i = 1, 12 do 
            local random_angle = random(-math.pi / 6, math.pi / 6)
            self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + random_angle), self.y + 1.5*d*math.sin(self.r + random_angle),
            table.merge({r = self.r + random_angle, attack = self.attack, v = random(500, 600)}, mods))
        end
        camera:shake(4, 60, 0.4)

    elseif self.attack == 'Spin' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

    elseif self.attack == 'Flame' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), 
        self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r - random(- math.pi / 20,  math.pi / 20), attack = self.attack}, mods))

    elseif self.attack == 'Bounce' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), 
    	table.merge({r = self.r, attack = self.attack, bounce = 4}, mods))

     elseif self.attack == '2Split' then
        self.ammo = self.ammo - attacks[self.attack].ammo
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), 
    	table.merge({r = self.r, attack = self.attack, bounce = 2}, mods))

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
        self.timer:after('invincibility', 2*self.invulnerability_time_multiplier, function() self.invincible = false end)
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

function Player:onCycle()
    if self.chances.spawn_sp_on_cycle_chance:next() then
        self.area:addGameObject('SkillPoint')
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'SP Spawn!', color = faded_skill_point_color})
    end

    if self.chances.spawn_hp_on_cycle_chance:next() then
        self.area:addGameObject('HP')
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'HP Spawn!', color = faded_hp_color})
    end

    if self.chances.regain_hp_on_cycle_chance:next() then
        self:addHP(25)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'HP Regain!', color = faded_hp_color})
    end

    if self.chances.regain_full_ammo_on_cycle_chance:next() then
        self.ammo = self.max_ammo
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Full Ammo!', color = faded_ammo_color})
    end

    if self.chances.change_attack_on_cycle_chance:next() then 
        random_attack = table.random(change_attack)
        self:setAttack(random_attack)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Attack Changed!', color = faded_skill_point_color})
    end

    if self.chances.spawn_haste_area_on_cycle_chance:next() then
        self.area:addGameObject('HasteArea', self.x, self.y)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Haste Area!', color = faded_ammo_color})
    end

    if self.chances.barrage_on_cycle_chance:next() then
        for i = 1, 8 do
            self.timer:after((i-1)*0.05, function()
                local random_angle = random(-math.pi/8, math.pi/8)
                local d = 2.2*self.w
                self.area:addGameObject('Projectile', 
            	self.x + d*math.cos(self.r + random_angle), 
            	self.y + d*math.sin(self.r + random_angle), {r = self.r + random_angle, attack = self.attack})
            end)
        end
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Barrage!!!'})
    end

    if self.chances.launch_homing_projectile_on_cycle_chance:next() then
        local d = 1.2*self.w
        self.area:addGameObject('Projectile', self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {r = self.r, attack = 'Homing'})
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', color = faded_skill_point_color})
    end

    if self.chances.mvspd_boost_on_cycle_chance:next() then
        self.mvspd_boosting = true
        self.timer:after(4*self.stat_boost_duration_multiplier, function() self.mvspd_boosting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'MVSPD Boost!', color = faded_skill_point_color})
    end

    if self.chances.pspd_boost_on_cycle_chance:next() then
        self.pspd_boosting = true
        self.timer:after(4*self.stat_boost_duration_multiplier, function() self.pspd_boosting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'PSPD Boost!', color = faded_skill_point_color})
    end

    if self.chances.pspd_inhibit_on_cycle_chance:next() then
        self.pspd_inhibit = true
        self.timer:after(4*self.stat_boost_duration_multiplier, function() self.pspd_inhibit = false end)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'PSPD Inhibit!', color = faded_skill_point_color})
    end

end

function Player:onKill()
    if self.chances.barrage_on_kill_chance:next() then
        for i = 1, 8 do
            self.timer:after((i-1)*0.05, function()
                local random_angle = random(-math.pi/8, math.pi/8)
                local d = 2.2*self.w
                self.area:addGameObject('Projectile', 
            	self.x + d*math.cos(self.r + random_angle), 
            	self.y + d*math.sin(self.r + random_angle), {r = self.r + random_angle, attack = self.attack})
            end)
        end
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Barrage!!!'})
    end

    if self.chances.regain_ammo_on_kill_chance:next() then
        self:addAmmo(20)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Ammo Regain!', color = faded_ammo_color})
    end

    if self.chances.launch_homing_projectile_on_kill_chance:next() then
        local d = 1.2*self.w
        self.area:addGameObject('Projectile', self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {r = self.r, attack = 'Homing'})
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', color = faded_skill_point_color})
    end

    if self.chances.regain_boost_on_kill_chance:next() then
        self:addBoost(40)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Boost Regain!', color = faded_boost_color})
    end

    if self.chances.spawn_boost_on_kill_chance:next() then
        self.area:addGameObject('Boost', self.x, self.y)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Boost Spawn!', color = faded_boost_color})
    end

    if self.chances.gain_aspd_boost_on_kill_chance:next() then
        self.aspd_boosting = true
        self.timer:after(4, function() self.aspd_boosting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, 
      	{text = 'ASPD Boost!', color = faded_ammo_color})
    end
end

function Player:onBoostStart()
    self.timer:every('launch_homing_projectile_while_boosting_chance', 0.2, function()
        if self.chances.launch_homing_projectile_while_boosting_chance:next() then
            local d = 1.2*self.w
            self.area:addGameObject('Projectile', 
          	self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), 
                {r = self.r, attack = 'Homing'})
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', color = faded_skill_point_color})
        end
    end)

    self.timer:every('increased_cycle_speed_while_boosting_chance', 0.2, function()
        if self.chances.increased_cycle_speed_while_boosting_chance:next() then
            self.cycle_speeding = true
            self.timer:after(5, function() self.cycle_speeding = false end)
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'Cycle Speed Boost!'})
        end
    end)

    self.timer:every('invulnerability_while_boosting_chance', 0.2, function()
        if self.chances.invulnerability_while_boosting_chance:next() then
            self.invincible = true
            self.timer:after(15*self.invulnerability_time_multiplier*self.stat_boost_duration_multiplier, function() self.invincible = false end)
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'Invulnerability!'})
        end
    end)

    self.timer:after('increased_luck_while_boosting_chance', 0.2, function()
        if self.chances.increased_luck_while_boosting_chance:next() then
            self.increased_luck_while_boosting = true
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'Luck Boost!'})
        end
    end)

    if self.increased_luck_while_boosting then 
        self.luck_boosting = true
        self.luck_multiplier = self.luck_multiplier*2
        self:generateChances()
    end
end

function Player:onBoostEnd()
    self.timer:cancel('launch_homing_projectile_while_boosting_chance')
    self.timer:cancel('increased_cycle_speed_while_boosting_chance')
    self.timer:cancel('invulnerability_while_boosting_chance')
    self.timer:cancel('increased_luck_while_boosting_chance')

    if self.increased_luck_while_boosting and self.luck_boosting then
        self.timer:after(5*self.stat_boost_duration_multiplier, function() self.increased_luck_while_boosting = false end)
    	self.luck_boosting = false
    	self.luck_multiplier = self.luck_multiplier/2
    	self:generateChances()
    end
end