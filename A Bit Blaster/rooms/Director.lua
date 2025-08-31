Director = Object:extend()

function Director:new(stage)
    self.stage = stage
    self.timer = Timer()

    self.difficulty = 1
    self.round_duration = 22
    self.round_timer = 0
    self.resource_duration = 16
    self.resource_timer = 0
    self.attack_duration = 25
    self.attack_timer = 0

    -- Difficulty meter
    self.difficulty_to_points = {}
    self.difficulty_to_points[1] = 16
    for i = 2, 1024, 4 do
        self.difficulty_to_points[i] = self.difficulty_to_points[i-1] + 8
        self.difficulty_to_points[i+1] = self.difficulty_to_points[i]
        self.difficulty_to_points[i+2] = math.floor(self.difficulty_to_points[i+1] / 1.5)
        self.difficulty_to_points[i+3] = math.floor(self.difficulty_to_points[i+2]*2)
    end

    self.enemy_to_points = {
        ['Rock'] = 1,
        ['Shooter'] = 2,
        ['BigRock'] = 3,
    }

    self.enemy_spawn_chances = {
        [1] = chanceList({'Rock', 1}),
        [2] = chanceList({'Rock', 8}, {'Shooter', 4}),
        [3] = chanceList({'Rock', 8}, {'Shooter', 8}),
        [4] = chanceList({'Rock', 4}, {'Shooter', 8}),
    }

    -- Random probabilities past stage 5
    for i = 5, 1024 do
        self.enemy_spawn_chances[i] = chanceList(
            {'Rock', love.math.random(2, 12)},
            {'Shooter', love.math.random(2, 12)},
            {'BigRock', love.math.random(2, 12)}
        )
    end

    if self.stage.player.only_spawn_boost then
        self.resource_spawn_chances = chanceList(
            {'Boost', 100}
        )
    elseif self.stage.player.only_spawn_attack then
        self.attack_spawn_chances = chanceList(
            {'Attack', attack = 'Double', 6},
            {'Attack', attack = 'Triple', 6},
            {'Attack', attack = 'Rapid', 6},
            {'Attack', attack = 'Spread', 6},
            {'Attack', attack = 'Back', 6},
            {'Attack', attack = 'Side', 6},
            {'Attack', attack = 'Homing', 6},
            {'Attack', attack = 'Blast', 6},
            {'Attack', attack = 'Spin', 6},
            {'Attack', attack = 'Flame', 6},
            {'Attack', attack = 'Bounce', 6},
            {'Attack', attack = '2Split', 6},
            {'Attack', attack = '4Split', 6},
            {'Attack', attack = 'Lightning', 6}, 
            {'Attack', attack = 'Explode', 6}
        )
    else
        self.resource_spawn_chances = chanceList(
            {'Boost', 28*self.stage.player.boost_spawn_chance_multiplier}, 
            {'HP', 14*self.stage.player.hp_spawn_chance_multiplier}, 
            {'SkillPoint', 58*self.stage.player.sp_spawn_chance_multiplier}
        )

        self.attack_spawn_chances = chanceList(
            {'Attack', attack = 'Double', 6},
            {'Attack', attack = 'Triple', 6},
            {'Attack', attack = 'Rapid', 6},
            {'Attack', attack = 'Spread', 6},
            {'Attack', attack = 'Back', 6},
            {'Attack', attack = 'Side', 6},
            {'Attack', attack = 'Homing', 6},
            {'Attack', attack = 'Blast', 6},
            {'Attack', attack = 'Spin', 6},
            {'Attack', attack = 'Flame', 6},
            {'Attack', attack = 'Bounce', 6},
            {'Attack', attack = '2Split', 6},
            {'Attack', attack = '4Split', 6},
            {'Attack', attack = 'Lightning', 6}, 
            {'Attack', attack = 'Explode', 6}
        )
    end


    self:setEnemySpawnsForThisRound()
end

function Director:update(dt)
    self.timer:update(dt)

    -- Difficulty
    self.round_timer = self.round_timer + dt
    if self.round_timer > self.round_duration/self.stage.player.enemy_spawn_rate_multiplier then
        self.round_timer = 0
        self.difficulty = self.difficulty + 1
        self:setEnemySpawnsForThisRound()
    end

    self.resource_timer = self.resource_timer + dt
    if self.resource_timer > self.resource_duration/self.stage.player.resource_spawn_rate_multiplier then
        self.resource_timer = 0
        if self.stage.player.only_spawn_attack then 
            return 
        else
            self.stage.area:addGameObject(self.resource_spawn_chances:next())
        end
    end

    self.attack_timer = self.attack_timer + dt
    if self.attack_timer > self.attack_duration/self.stage.player.attack_spawn_rate_multiplier then
        self.attack_timer = 0
        if self.stage.player.only_spawn_boost then 
            return 
        else
            self.stage.area:addGameObject(self.attack_spawn_chances:next())
        end
    end
end

function Director:setEnemySpawnsForThisRound()
    local points = self.difficulty_to_points[self.difficulty]

    -- Find enemies
    local runs = 0
    local enemy_list = {}
    while points > 0 and runs < 1000 do
        local enemy = self.enemy_spawn_chances[self.difficulty]:next()
        points = points - self.enemy_to_points[enemy]
        table.insert(enemy_list, enemy)
        runs = runs + 1
    end

    -- Find enemies spawn times
    local enemy_spawn_times = {}
    for i = 1, #enemy_list do enemy_spawn_times[i] = random(0, self.round_duration) end
    table.sort(enemy_spawn_times, function(a, b) return a < b end)

    -- Set spawn enemy timer
    for i = 1, #enemy_spawn_times do
        self.timer:after(enemy_spawn_times[i], function()
            self.stage.area:addGameObject(enemy_list[i])
        end)
    end
end
