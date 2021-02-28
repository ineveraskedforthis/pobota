function love.load()

    magic_ball_speed = 100
    magic_ball_damage = 10
    magic_ball_bounce = 0
    magic_ball_cast_speed = 0.2
    magic_ball_manacost = 5

    char = {
        damage = stat(10, 0, 0),
        speed = stat(100, 0, 0),
        mana_regen = stat(10, 0, 0),
        mana_max = stat(100, 0, 0),
        cast_speed = stat(1, 0, 0),
        damage = stat(1, 0, 0),
        x = 200,
        y = 200,
    }

    char.spell = init_magic_ball()
    print(char.spell.speed)
    print(char.spell.damage)
    print(char.spell.bounce)
    print(char.spell.cast_speed)

    restore_characer(char)

    points = 0

    reset_proj_and_enemies()    

    stage = 0
    start_stage(0)

    restart = false


end

function stat(base, inc, more)
    local stat = {}
    stat.base = base
    stat.inc = inc
    stat.more = more
    return stat;    
end

function init_magic_ball()
    local spell = {}
    spell.on_cast = magic_ball_on_cast
    spell.on_hit = magic_ball_on_hit

    spell.speed = magic_ball_speed
    spell.damage = magic_ball_damage
    spell.bounce = magic_ball_bounce
    spell.cast_speed = magic_ball_cast_speed
    spell.manacost = magic_ball_manacost
    return spell
end

function magic_ball_on_cast(char, x, y)
    if char.mana > 10 then
        change_char_mana(char, -char.spell.manacost) 
        char.cooldown = magic_ball_cast_speed / get_stat(char, 'cast_speed')
        spawn_projectile(char.x, char.y, x, y, magic_ball_bounce, magic_ball_speed, 100, nil, 0)
    end    
end

function magic_ball_on_hit(char, proj, enemy)
    if proj > last_projectile then
        return
    end
    local flag = projectiles_hostile[proj]
    if (enemy == projectiles_origin[proj]) or (flag == 1) then
        return
    end
    change_enemy_hp(enemy, -10 * get_stat(char, 'damage'))
    projectile_is_alive[proj] = false
    if projectiles_bounce[proj] > 0 then
        local x = enemies_x[enemy]
        local y = enemies_y[enemy]
        local t = math.random() * 2
        spawn_projectile(x, y, x + math.sin(t * 3.14), y + math.cos(t * 3.14), projectiles_bounce[proj] - 1, cproj_speed, 100, enemy, 0)
        local t = math.random() * 2
        spawn_projectile(x, y, x + math.sin(t * 3.14), y + math.cos(t * 3.14), projectiles_bounce[proj] - 1, cproj_speed, 100, enemy, 0)
    end
end

function cast(char, x, y)
    if char.cooldown > 0 then
        return
    end
    char.spell.on_cast(char, x, y)
end

function get_stat(char, tag)
    return char[tag].base * (1 + char[tag].inc)
end

function restore_characer(char)
    char.cooldown = 0;
    char.hp = 50;
    char.mana = get_stat(char, 'mana_max')
end

function reset_proj_and_enemies()
    last_projectile = 0;

    projectiles_x = {}
    projectiles_y = {}
    projectiles_speed_x = {}
    projectiles_speed_y = {}
    projectiles_time_left = {}
    projectile_is_alive = {}
    projectiles_bounce = {}
    projectiles_origin = {}
    projectiles_hostile = {}
    projectiles_damage = {}

    last_enemy = 0

    enemies_x = {}
    enemies_y = {}
    enemies_hp = {}
    enemies_speed = {}
    enemies_cooldown = {};
    enemies_cast_speed = {}
    enemy_is_alive = {}

    enemies_left = 0
end

function start_stage(stage)
    restore_characer(char)
    spawn_dummy_cluster(400, 400)
end

function char_update(dt) 
    char.mana = char.mana + get_stat(char, 'mana_regen') * dt
    local mana_max = get_stat(char, 'mana_max')
    if char.mana > mana_max then
        char.mana = mana_max
    end
    if char.mana < 0 then
        char.mana = 0
    end

    if char.cooldown > 0 then
        char.cooldown = char.cooldown - dt
    end
    if char.cooldown < 0 then
        char.cooldown = 0
    end
end

function spawn_projectile(sx, sy, x, y, bounce, proj_speed, time_left, origin, hostile)
    projectiles_x[last_projectile] = sx 
    projectiles_y[last_projectile] = sy
    local norm = math.sqrt((sx-x) * (sx-x) + (sy-y) * (sy - y))
    projectiles_speed_x[last_projectile] = -(sx - x) / norm * proj_speed
    projectiles_speed_y[last_projectile] = -(sy - y) / norm * proj_speed
    projectiles_time_left[last_projectile] = time_left
    projectile_is_alive[last_projectile] = true
    projectiles_origin[last_projectile] = origin
    projectiles_bounce[last_projectile] = bounce
    projectiles_damage[last_projectile] = 10
    projectiles_hostile[last_projectile] = hostile -- 0 - damage enemy, 1 - damage palyer, 2 - damage all
    last_projectile = last_projectile + 1
end

function enemy_send_projectile(i, tx, ty)
    spawn_projectile(enemies_x[i], enemies_y[i], tx, ty, 0, 100, 100, nil, 1)
end

function hit_enemy(proj, enemy)
    magic_ball_on_hit(char, proj, enemy)    
end

function hit_player(proj)
    if proj > last_projectile then
        return
    end
    local flag = projectiles_hostile[proj]
    if flag == 0 or projectiles_origin[proj] == -1 then
        return
    end
    change_player_hp(-projectiles_damage[proj])
    projectile_is_alive[proj] = false
    if projectiles_bounce[proj] > 0 then
        local x = char.x
        local y = char.y
        local t = math.random() * 2
        spawn_projectile(x, y, x + math.sin(t * 3.14), y + math.cos(t * 3.14), projectiles_bounce[proj] - 1, cproj_speed, 100, -1, 0)
        local t = math.random() * 2
        spawn_projectile(x, y, x + math.sin(t * 3.14), y + math.cos(t * 3.14), projectiles_bounce[proj] - 1, cproj_speed, 100, -1, 0)
    end
end

function spawn_dummy(x, y)
    enemies_x[last_enemy] = x
    enemies_y[last_enemy] = y
    enemies_speed[last_enemy] = 20
    enemies_hp[last_enemy] = 20
    enemy_is_alive[last_enemy] = true
    enemies_cooldown[last_enemy] = 0;
    enemies_cast_speed[last_enemy] = 1
    
    last_enemy = last_enemy + 1

    enemies_left = enemies_left + 1
end

function move_to_player(i, dt)
    local x = enemies_x[i]
    local y = enemies_y[i]
    local norm = math.sqrt((char.x-x) * (char.x-x) + (char.y-y) * (char.y - y)) 
    if norm > 30 then
        enemies_x[i] = x + (char.x - x) / norm * enemies_speed[i] * dt
        enemies_y[i] = y + (char.y - y) / norm * enemies_speed[i] * dt
    end
end



function enemy_shoot(i, dt)
    if enemies_cooldown[i] <= 0 then
        enemy_send_projectile(i, char.x, char.y)
        enemies_cooldown[i] = enemies_cast_speed[i]
    else 
        enemies_cooldown[i] = enemies_cooldown[i] - dt
    end
end

function update_enemy(i, dt)
    if enemy_is_alive[i] then
        move_to_player(i, dt)
        enemy_shoot(i, dt)
    end
end

function spawn_dummy_cluster(x, y)
    for i = -1, 1 do
        for j = -1, 1 do
            spawn_dummy(x + i * 40, y + j * 40)
        end
    end
end

function change_enemy_hp(i, dh)
    enemies_hp[i] = enemies_hp[i] + dh
    if enemies_hp[i] <= 0 then
        enemy_is_alive[i] = false
        enemies_left = enemies_left - 1
    end
end

function change_player_hp(dh)
    char.hp = char.hp + dh
    if char.hp <= 0 then
        restart = true
    end
end

function change_char_mana(char, dm)
    char.mana = char.mana + dm
    if char.mana <= 0 then
        char.mana = 0
    end
    local mana_max = get_stat(char, 'mana_max')
    if char.mana > mana_max then
        char.mana = mana_max
    end
    
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', char.x, char.y, 5)
    
    love.graphics.setColor(1, 0, 0)
    for i = 0, last_projectile - 1 do
        if projectile_is_alive[i] and projectiles_hostile[i] == 0 then
            love.graphics.circle('fill', projectiles_x[i], projectiles_y[i], 5)
        end         
    end
    love.graphics.setColor(0.5, 0, 0)
    for i = 0, last_projectile - 1 do
        if projectile_is_alive[i] and projectiles_hostile[i] == 1 then
            love.graphics.circle('fill', projectiles_x[i], projectiles_y[i], 5)
        end         
    end

    love.graphics.setColor(1, 1, 0)
    for i = 0, last_enemy - 1 do
        if enemy_is_alive[i] then
            love.graphics.circle('fill', enemies_x[i], enemies_y[i], 5)
        end         
    end

    love.graphics.print('enemies left  ' .. tostring(enemies_left), 600, 20)


    love.graphics.print('hp  ' .. tostring(char.hp), 600, 100)
    love.graphics.print('mana  ' .. tostring(math.floor(char.mana)), 600, 110)
    love.graphics.print('projectile speed  ' .. tostring(char.spell.speed), 600, 140)
    love.graphics.print('bounce amount  ' .. tostring(char.spell.bounce), 600, 155)
    love.graphics.print('attacks per second  ' .. tostring(1 / char.spell.cast_speed * get_stat(char, 'cast_speed')), 600, 170)
    love.graphics.print('mana regen  ' .. tostring(get_stat(char, 'mana_regen')), 600, 185)
    love.graphics.print('damage  ' .. tostring(char.spell.damage * get_stat(char, 'damage')), 600, 200)
    love.graphics.print('speed  ' .. tostring(get_stat(char, 'speed')), 600, 215)

    love.graphics.print('inc cast speed  press [1]', 600, 300)
    love.graphics.print('inc damage  press [2]', 600, 320)
    love.graphics.print('inc mana regen  press [3]', 600, 340)
end

function love.update(dt)

    if love.keyboard.isDown('1') then
        char.cast_speed.inc = char.cast_speed.inc + 0.5
    end
    if love.keyboard.isDown('3') then
        char.mana_regen.inc = char.mana_regen.inc + 0.5
    end
    if love.keyboard.isDown('2') then
        char.damage.inc = char.mana_regen.inc + 0.5
    end

    if restart then
        love.load()
    end

    if enemies_left == 0 then
        reset_proj_and_enemies()
        stage = stage + 1
        start_stage(stage)
    end

    char_update(dt)

    for i = 0, last_projectile - 1 do
        if projectile_is_alive[i] then
            for j = 0, last_enemy do
                if enemy_is_alive[j] and projectile_is_alive[i] then
                    local dx = (enemies_x[j] - projectiles_x[i])
                    local dy = (enemies_y[j] - projectiles_y[i])
                    if dx*dx + dy * dy < 100 then
                        hit_enemy(i, j)
                    end
                end;
            end
            local dx = (char.x - projectiles_x[i])
            local dy = (char.y - projectiles_y[i])
            if dx*dx + dy * dy < 100 then
                hit_player(i)
            end 
        end         
    end

    for i = 0, last_projectile - 1 do
        if projectile_is_alive[i] then
            projectiles_time_left[i] = projectiles_time_left[i] - 1
            if projectiles_time_left[i] <= 0 then
                projectile_is_alive[i] = false
            else
                projectiles_x[i] = projectiles_x[i] + projectiles_speed_x[i] * dt
                projectiles_y[i] = projectiles_y[i] + projectiles_speed_y[i] * dt
            end
        end         
    end

    for i = 0, last_enemy - 1 do
        update_enemy(i, dt)
    end


    if love.mouse.isDown(1) then
        x, y = love.mouse.getPosition( )
        cast(char, x, y)
    end

    local speed = get_stat(char, 'speed')

    if love.keyboard.isDown('w') then
        char.y = char.y - speed * dt
    end
    if love.keyboard.isDown('s') then
        char.y = char.y + speed * dt
    end
    if love.keyboard.isDown('a') then
        char.x = char.x - speed * dt
    end
    if love.keyboard.isDown('d') then
        char.x = char.x + speed * dt
    end

    
end

function love.mousepressed(x, y, button, istouch)
    if (button == 1) then
        cast(char, x, y)
    end
end
