
default_color = {0.87, 0.87, 0.87, 0.87}
hp_color = {1, 0, 0, 1}
background_color = {0.063, 0.063, 0.063}
ammo_color = {0.482, 0.784, 0.643}
boost_color = {0.298, 0.765, 0.851}
skill_point_color = {1, 0.776, 0.365}
rock_color = {0.961, 0.306, 0.106, 1}

-- Faded colors
faded_hp_color = {1, 0, 0, 0.8}
faded_ammo_color = {0.482, 0.784, 0.643, 0.8}
faded_skill_point_color = {1, 0.776, 0.365, 0.8}


default_colors = {default_color, hp_color, background_color, ammo_color, boost_color, skill_point_color}
negative_colors = {
    {255-default_color[1], 255-default_color[2], 255-default_color[3]}, 
    {255-hp_color[1], 255-hp_color[2], 255-hp_color[3]}, 
    {255-ammo_color[1], 255-ammo_color[2], 255-ammo_color[3]}, 
    {255-boost_color[1], 255-boost_color[2], 255-boost_color[3]}, 
    {255-skill_point_color[1], 255-skill_point_color[2], 255-skill_point_color[3]}
}

all_colors = fn.append(default_colors, negative_colors)


attacks = {
    ['Neutral'] = {cooldown = 0.24, ammo = 0, abbreviation = 'N', color = default_color},
    ['Double'] = {cooldown = 0.32, ammo = 2, abbreviation = '2', color = ammo_color},
    ['Triple'] = {cooldown = 0.32, ammo = 3, abbreviation = '3', color = boost_color},
    ['Rapid'] = {cooldown = 0.12, ammo = 1, abbreviation = 'R', color = default_color},
    ['Spread'] = {cooldown = 0.16, ammo = 1, abbreviation = 'RS', color = default_color},
    ['Back'] = {cooldown = 0.32, ammo = 2, abbreviation = 'Ba', color = skill_point_color},
    ['Side'] = {cooldown = 0.32, ammo = 2, abbreviation = 'Si', color = boost_color},
    ['Homing'] = {cooldown = 0.56, ammo = 4, abbreviation = 'H', color = skill_point_color}
}

enemies = {'Rock', 'Shooter'}

skill_points = 0
max_sp = 9999

