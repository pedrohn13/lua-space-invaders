require('Object')
require('Chronometer')
require('topBar')
require "commandBar"
cmdBar = CommandBar:new(_,RESET,_,_,2,false,SHOT)

function dispose()
    invader1_img = nil
    invader2_img = nil
    invader3_img = nil
    invader4_img = nil
    invader_bullet_img = nil
    invader_bullet_img2 = nil
    cannon_bullet_img = nil
    cannon_bullet_img2 = nil
    cannon_bullet_img3 = nil
    cannon_superbullet_img = nil
    cannon_superbullet_img2 = nil
    ufo_bullet_img = nil
    ufo_bullet_img2 = nil
    background = nil
    bgStartGame = nil
    bgGameOver = nil
    bgWin = nil
    iconGame = nil
    bgBestTime = nil

    states = nil
    cannon = nil
    cannon_bullet = nil
    invaders = nil
    invaders_bullets = nil
    invaders_direction = nil
    invaders_region = nil
    ufo = nil
    ufo_bullet = nil
    cannon_bullet = nil
    explosion = nil
end
--- reset all variables
function reset()
        IMAGE_PATH ="../res/elements/"
     stars ={
            off = canvas:new(IMAGE_PATH.."star0.png"),
            on = canvas:new(IMAGE_PATH.."star1.png")
    }   
    invader1_img = canvas:new(IMAGE_PATH.."invasor_1_1.png")
    invader2_img = canvas:new(IMAGE_PATH.."invasor_2_1.png")
    invader3_img = canvas:new(IMAGE_PATH.."invasor_3_1.png")
    invader4_img = canvas:new(IMAGE_PATH.."invasor_4_1.png")
    invader_bullet_img = canvas:new(IMAGE_PATH.."shot_b1.png")
    invader_bullet_img_off = canvas:new(IMAGE_PATH.."shot_b1_off.png")
    invader_bullet_img2 = canvas:new(IMAGE_PATH.."shot_b2.png")
    invaders = {}
    invaders_bullets = {}
    invaders_direction = "R"
    invaders_region = nil
    
    cannon_bullet_img = canvas:new(IMAGE_PATH.."shot_a1.png")
    cannon_bullet_img2 = canvas:new(IMAGE_PATH.."shot_a2.png")
    cannon_bullet_img3 = canvas:new(IMAGE_PATH.."shot_a3.png")
    cannon_superbullet_img = canvas:new(IMAGE_PATH.."powershot_a1.png")
    cannon_superbullet_img2 = canvas:new(IMAGE_PATH.."powershot_a3.png")
    cannon = nil
    cannon_bullet = nil

    ufo_bullet_img = canvas:new(IMAGE_PATH.."bomb_a1.png")
    ufo_bullet_img2 = canvas:new(IMAGE_PATH.."bomb_a2.png")
    ufo = nil
    ufo_bullet = nil
    
    background = canvas:new(IMAGE_PATH.."bg-new.png")
    bgStartGame = canvas:new(IMAGE_PATH.."bg_start_game.png")
    bgGameOver = canvas:new(IMAGE_PATH.."bg_you_lose.png")
    bgWin = canvas:new(IMAGE_PATH.."bg_you_win.png")
    bgBestTime = canvas:new(IMAGE_PATH.."bg_best_time.png")
    iconGame = canvas:new(IMAGE_PATH.."image.png")
     
    states = {}
    states.records = {}
    states.init = true
    states.Settings = {}
    states.back_first = false
    states.exit = false
    states.freeze = false
    states.y_starts = {150,200,250,300,350}
    states.x_cannon,states.y_cannon = 0,615
    states.level = 1
    states.level_played = 1
    states.score = 0
    states.score_level = 0
    states.lifes = 3
    states.sequence_hits = 0
    states.thisTime = 0
    states.time = nil
    states.time_total = 0
    states.time_freeze = nil
    states.inv_w, states.inv_h = invader1_img:attrSize()
    states.bul_w, states.bul_h = cannon_bullet_img:attrSize()
    states.dist_x = 15
    states.dist_y = 15
    states.x_starts = 130
    states.speed = 15
    states.shot = false
    states.super_shot = false
    states.numSuperShot =0
    states.lines = 4
    states.columns = 6
    states.ufo = false
    states.isRunning = true
    
    explosion = nil

end
--- create a chronometer
function createTime()
    states.time = Chronometer:new()
end

--- Draw 3 stars in the screen
--@params numStars number of stars on
function drawStars(numStars)

    local wbg, hbg = background:attrSize()
    local star1 = {x = wbg/2 - 2*stars.on:attrSize()/2 -5 , y =360 }
    local star2 = {x = star1.x +stars.on:attrSize()+5, y = 360}
    local star3 = {x = star2.x +stars.on:attrSize()+5, y = 360}
    if numStars == "1" then
        canvas:compose(star1.x, star1.y, stars.on)
        canvas:compose(star2.x, star2.y, stars.off)
        canvas:compose(star3.x, star3.y, stars.off)
        
    elseif numStars == "2" then 
        canvas:compose(star1.x, star1.y, stars.on)
        canvas:compose(star2.x, star2.y, stars.on)
        canvas:compose(star3.x, star3.y, stars.off)
    elseif numStars == "3" then
        canvas:compose(star1.x, star1.y, stars.on)
        canvas:compose(star2.x, star2.y, stars.on)
        canvas:compose(star3.x, star3.y, stars.on)
    else
        canvas:compose(star1.x, star1.y, stars.off)
        canvas:compose(star2.x, star2.y, stars.off)
        canvas:compose(star3.x, star3.y, stars.off)
    end
    
        
end

---Draw the best time in screen
function drawBestTime()
    
    local newTime = states.records[states.level]
    local seconds = newTime%60
    local minutes = math.modf(newTime/60)
    if seconds < 10 then 
        seconds = "0"..seconds
    end
    
    if minutes < 10 then
        minutes = "0"..minutes
    end
    
    canvas:attrFont ('Alien Encounters', 16)
    local fTime = minutes..":"..seconds
    local fText = BEST_TIME..fTime
    local x = 1270 - canvas:measureText(fText)
    canvas:compose(0,643, bgBestTime)
    canvas:drawText(x,647, fText)
    --canvas:flush()
end

---Calculate the nunber of star who the gamer win
function calculeteNumStars()
    local numStars = 0
    if states.thisTime < (117 -(states.level*11)) then
        numStars = 3
    elseif states.thisTime < (128 -(states.level*11)) then 
        numStars = 2
    else
        numStars = 1
    end
    return numStars
end

--- create the region where the invaders are
function creatInvadersRegion(tab)
    local w = invader1_img:attrSize()
    invaders_region = Region:new(tab[1]:getRegion():getX()-(w/4), 
                                tab[1]:getRegion():getY(),
                                (tab[#tab]:getRegion():getLastX() - tab[1]:getRegion():getX())+(w/2),
                                tab[#tab]:getRegion():getLastY() - tab[1]:getRegion():getY())
    
end

--- create the Cannon Defensor
function createCannon()
    local cannon1_img = canvas:new(IMAGE_PATH.."defensor_1.png")
    local cannon2_img = canvas:new(IMAGE_PATH.."defensor_2.png")
    local cannon3_img = canvas:new(IMAGE_PATH.."defensor_3.png")
    local cannon4_img = canvas:new(IMAGE_PATH.."defensor_4.png")
    local cannon_off_img = canvas:new(IMAGE_PATH.."defensor_1_off.png")
    cannon = Object:new(states.x_cannon,states.y_cannon,{cannon4_img, cannon3_img, cannon2_img, cannon1_img,cannon_off_img},4,false)
end

--- create the Invaders UFO
function createUFO()
    local u_img = canvas:new(IMAGE_PATH.."nave_1.png")
    local uf_img = canvas:new(IMAGE_PATH.."nave_2.png")
    local ufo_img = canvas:new(IMAGE_PATH.."nave_3.png")
    local ufoo_img = canvas:new(IMAGE_PATH.."nave_4.png")
    local ufoff_img = canvas:new(IMAGE_PATH.."nave_1_off.png")
    ufo = Object:new(-120,90,{ufoo_img, ufo_img, uf_img, u_img,ufoff_img},4,false)
end

--- create the Invaders
function createInvaders()
    
    invader1_img = canvas:new(IMAGE_PATH.."invasor_1_"..states.level..".png")
    invader2_img = canvas:new(IMAGE_PATH.."invasor_2_"..states.level..".png")
    invader3_img = canvas:new(IMAGE_PATH.."invasor_3_"..states.level..".png")
    invader4_img = canvas:new(IMAGE_PATH.."invasor_4_"..states.level..".png")
    invaderoff_img = canvas:new(IMAGE_PATH.."invasor_1_off_"..states.level..".png")
    
    
    invaders = {}
    
    for i = 0, (states.columns - 1) do
        for j = 0, (states.lines - 1) do            
            table.insert(invaders, Object:new(states.x_starts + (i * (states.inv_w + states.dist_x)),
                                            states.y_starts[states.level] + (j * (states.inv_h + states.dist_y)),
                                            {invader4_img,invader3_img,invader2_img,invader1_img,invaderoff_img},4,false))
        end
    end
    
end

--- create an Explosion
function createExplosion()

    local explosion1 = canvas:new(IMAGE_PATH.."bomb_b1.png")
    local explosion2 = canvas:new(IMAGE_PATH.."bomb_b2.png")
    
    explosion = Object:new(ufo_bullet:getRegion():getX(),ufo_bullet:getRegion():getY(),{explosion2,explosion2,explosion1,explosion1},4,true)
    
end

--- draws Status on bar
function drawStatus()

    updateLevel(states.level)
    updateNumLifes(states.lifes)
    drawPowerShot(states.sequence_hits)
    updateNumSuperShot(states.numSuperShot)
    if states.freeze then
        if states.time_freeze:getTime()%2 == 0 then
            updateTime(states.thisTime)
        else
            updateTime(states.thisTime,0,255,0)
        end 
    else
         updateTime(states.thisTime)
    end
end

--- draws Cannon Defensor
function drawCannon()
    if (cannon:getDead()) then  
        cannon:setLife(cannon:getLife() - 1)
        if (cannon:getLife() < 0) then
            states.lifes = states.lifes - 1                 
            createCannon()
        end 
        clearRegion(cannon:getRegion())
    end

    if (cannon:getLife() > 0) then
        cannon:drawObject()
    end
end

--- draws Invaders
function drawInvaders()
    for i = 1, #invaders do
        if (invaders[i] ~= nil) then
            if (invaders[i]:getLife() > 0) then
                invaders[i]:drawObject()
            end
        end
    end   
end

--- draws Explosion
function drawExplosion()
    clearRegion(explosion:getRegion())
    if (explosion:getDead()) then   
        explosion:setLife(explosion:getLife() - 1)
        if (explosion:getLife() == 0) then
            explosion = nil
            return      
        end 
    end
    
    if (explosion:getLife() > 0) then
        explosion:drawObject()
    end

end

---Draw off objects
function drawOff()

    if (cannon ~= nil) then
        clearRegion(cannon:getRegion())
        cannon:draw_off()
    end
    if (states.ufo) then
        clearRegion(ufo:getRegion()) 
        ufo:draw_off()
    end
    for i = 1, #invaders do
        if (invaders[i] ~= nil) then
            if (invaders[i]:getLife() > 0) then
                invaders[i]:draw_off()
                
            end
        end
    end
    for i = 1, #invaders_bullets do
        if invaders_bullets[i] ~= nil then
            invaders_bullets[i]:draw_off()
        end
    end
    
    canvas:attrColor(0,0,0,60)
    canvas:drawRect("fill", 0,0,1280,643)
   --canvas:flush()
end

--- draws Game Over Screen
function drawGameOver()
    drawOff()
    canvas:compose(0,221,bgGameOver)

    canvas:attrFont ('Alien Encounters', 82)
    canvas:attrColor(204,204,204,255)
    canvas:drawText(background:attrSize()/2 - canvas:measureText(YOU_LOSE)/2, 285,YOU_LOSE)
    
    canvas:attrFont ('Alien Encounters', 32)
    canvas:drawText(background:attrSize()/2 - canvas:measureText(TRY_AGAIN)/2, 397,TRY_AGAIN)

    cmdBar:att(_,_,_,_,_,false,START_GAME)
    cmdBar:show()


    --canvas:flush()
end

--- draws Victory Screen
function drawWin()

    drawOff()
    states.time:stop()   

    
    canvas:compose(0,221,bgWin)
    
    if (states.records[states.level] > states.thisTime) then        
        
        states.records[states.level] = states.thisTime
        saveRecord()
        canvas:attrFont ('Alien Encounters', 82)
        canvas:attrColor(204,204,204,255)
        canvas:drawText(background:attrSize()/2 - canvas:measureText(YOU_WIN)/2, 240,YOU_WIN)
        
        canvas:attrFont('Alien Encounters', 32)
       
        local newTime = states.records[states.level]
        local seconds = states.records[states.level]%60
        local minutes = math.modf(states.records[states.level]/60)
        if seconds < 10 then 
            seconds = "0"..seconds
        end
    
        if minutes < 10 then
            minutes = "0"..minutes
        end
        
        newTime = minutes..":"..seconds
        
        x = background:attrSize()/2 - canvas:measureText(NEW_RECORD..":  "..newTime)/2
        canvas:drawText(x, 397,NEW_RECORD..":  "..newTime)

    else
        canvas:attrFont ('Alien Encounters', 82)
        canvas:attrColor(204,204,204,255)
        canvas:drawText(background:attrSize()/2 - canvas:measureText(YOU_WIN)/2, 240,YOU_WIN)
    end
    drawStars(""..calculeteNumStars())
    cmdBar:att(_,_,_,_,_,false,NEXT_L)
    cmdBar:show()
    
    --canvas:flush()
end


--- draws Victory Screen
function drawCongratulation()
    canvas:clear()
    canvas:compose(0,0,background)
    canvas:compose(0,221,bgWin)
    
    if (states.time_total < states.records[6] and states.level_played == 5) then
        states.records[6] = states.time_total
        --canvas:drawText(820,681,"NEW RECORD!!")
        saveRecord()
        canvas:attrFont ('Alien Encounters', 82)
        canvas:attrColor(204,204,204,255)
        canvas:drawText(background:attrSize()/2 - canvas:measureText(CONGRATULATIONS)/2, 285,CONGRATULATIONS)
        
        canvas:attrFont('Alien Encounters', 32)
        
        local newTime = states.time_total
        local seconds = states.time_total%60
        local minutes = math.modf(states.time_total/60)
        if seconds < 10 then 
            seconds = "0"..seconds
        end
    
        if minutes < 10 then
            minutes = "0"..minutes
        end
        
        newTime = minutes..":"..seconds
        
        x = background:attrSize()/2 - canvas:measureText(NEW_RECORD..":  "..newTime)/2
        canvas:drawText(x, 397,NEW_RECORD..":  "..newTime)

    else
        canvas:attrFont ('Alien Encounters', 82)
        canvas:attrColor(204,204,204,255)
        canvas:drawText(background:attrSize()/2 - canvas:measureText(CONGRATULATIONS)/2, 297,CONGRATULATIONS)
    end

    cmdBar:att(_,_,_,_,_,false,START_GAME)
    cmdBar:show()
end

--- checks if the Explosion hits something
function checkExplosion()

    local temp = {}


    for i = 1, #invaders do
        if (invaders[i] ~= nil) then
            if (collision(explosion, invaders[i])) then
                
              --  clearRegion(invaders[i]:getRegion())
                invaders[i] = nil           
            else
                
                table.insert(temp,invaders[i])
                
            end
        end
    end

    invaders = temp
    
    if (collision(explosion, cannon)) then
    
        cannon:setDead(true)
        
    end
    
    if (collision(explosion, ufo)) then
    
        states.sequence_hits = states.sequence_hits + 1
        states.freeze = true
        states.time_freeze = Chronometer:new()
        states.time_freeze:start()
        ufo:setDead(true)
                
    end
    
    
end

--- checks if the cannon bullet hit something
function checkCannonBullet()

    local img
    
    if (states.super_shot) then
        img = cannon_superbullet_img2
    else
        img = cannon_bullet_img2
    end

    if (cannon_bullet:getRegion():getY()-20 < 45) then
            
            states.sequence_hits = 0
            states.shot = false
            clearRegion(cannon_bullet:getRegion())
            canvas:compose(cannon_bullet:getRegion():getX()-16, 45,cannon_bullet_img3)
            drawCannon()
            canvas:flush()
            canvas:compose(cannon_bullet:getRegion():getX() - 16, 45,background, cannon_bullet:getRegion():getX() - 16,45, 36, 36)       
            cannon_bullet = nil
            if (states.super_shot) then
                states.super_shot = false
            end
        
        elseif (collision(cannon_bullet, ufo_bullet)) then      
            
            clearRegion(cannon_bullet:getRegion())
            canvas:compose(cannon_bullet:getRegion():getX() - 16, cannon_bullet:getRegion():getY() - 16,img)
            drawCannon()
            canvas:flush()
            canvas:compose(cannon_bullet:getRegion():getX() - 16, cannon_bullet:getRegion():getY() - 16,background, cannon_bullet:getRegion():getX() - 16, cannon_bullet:getRegion():getY() - 16, 36, 36)
            clearRegion(ufo_bullet:getRegion())          
            createExplosion()
            checkExplosion()
            if (not states.super_shot) then   
                cannon_bullet = nil
                states.shot = false
                states.sequence_hits = states.sequence_hits + 1
            end
            ufo_bullet = nil
            
           
        
        elseif (collision(cannon_bullet, ufo)) then
            
            clearRegion(cannon_bullet:getRegion()) 
            canvas:compose(cannon_bullet:getRegion():getX() - 16, cannon_bullet:getRegion():getY() - 16,img)
            drawCannon()
            canvas:flush()
            canvas:compose(cannon_bullet:getRegion():getX() - 16, cannon_bullet:getRegion():getY() - 16,background, cannon_bullet:getRegion():getX() - 16, cannon_bullet:getRegion():getY() - 16, 36, 36)    
            if (not states.super_shot) then   
                          
                cannon_bullet = nil
                states.shot = false
                states.sequence_hits = states.sequence_hits + 1         
                        
            end
            states.freeze = true
            states.time_freeze = Chronometer:new()
            states.time_freeze:start()
            ufo:setDead(true)
            
        else
            for i = 1, #invaders do
                if (invaders[i] ~= nil) then
                    if (collision(cannon_bullet, invaders[i])) then             
                        invaders[i]:setDead(true)
                        clearRegion(cannon_bullet:getRegion())
                        canvas:compose(cannon_bullet:getRegion():getX() - 16, cannon_bullet:getRegion():getY() - 16,img)
                        drawCannon()
                        canvas:flush()
                        canvas:compose(cannon_bullet:getRegion():getX() - 16, cannon_bullet:getRegion():getY() - 16,background, cannon_bullet:getRegion():getX() - 16, cannon_bullet:getRegion():getY() - 16, 36, 36)      
                                        
                        if (not states.super_shot) then                 
                            cannon_bullet = nil
                            states.shot = false
                            states.sequence_hits = states.sequence_hits + 1                      
                        end
                    
                        if (#invaders > 0) then
                            creatInvadersRegion(invaders)
                        end
                    
                        
                    
                        break                                           
                    end         
                end
            end
        end
        
        if (states.sequence_hits==3) then
            states.numSuperShot = states.numSuperShot +1
            states.sequence_hits=0
        end
        
end

--- clear some region
--@param Region
function clearRegion(region)
    canvas:compose(region:getX(), region:getY(),background, region:getX(), region:getY(), region:getW(), region:getH() )
end

--- cannon shot
function shot()

    local img
    local x
    
    if (states.super_shot) then
        img = cannon_superbullet_img
        x = cannon:getRegion():getX() + 32
    else
        img = cannon_bullet_img
        x = cannon:getRegion():getX() + 36
    end

    cannon_bullet = Object:new(x, cannon:getRegion():getY() - states.bul_w,
                                {img},1,false)
    states.shot = true

end

--- invaders shot
function shotInv()
    
    local invader = math.random(#invaders)
    
    table.insert(invaders_bullets, Object:new(invaders[invader]:getRegion():getX() + (states.inv_w / 2),
                                invaders[invader]:getRegion():getLastY(),
                                {invader_bullet_img,invader_bullet_img_off},1,false))
        
end

--- ufo shot
function shotUFO()
    
    ufo_bullet = Object:new(ufo:getRegion():getX() + (states.inv_w / 2),
                                ufo:getRegion():getY(),
                                {ufo_bullet_img},1,false)

end

--- change the level of the game
function changeLevel()
    states.Settings[states.level] = "false|"..states.level.."|"..calculeteNumStars().."|"..states.records[states.level]
    saveSettings()
    
    states.time_total = states.time_total + states.thisTime
    states.level = states.level + 1
    if states.level < 6 then
        states.Settings[states.level] = "false|"..states.level.."|0|"..states.records[states.level]
        saveSettings()
    end
    local lLife = states.lifes
    local lNumSuperShot = states.numSuperShot
    
    if (states.level == 6) then
        drawCongratulation()
        states.backToMenu = true
    else
        states.level_played = states.level_played + 1
        states.ufo = false
        start(states.level)
        states.lifes = lLife
        states.numSuperShot = lNumSuperShot
    end
    states.score_level = 0
    states.sequence_hits = 0
    states.thisTime = 0
   -- states.lastNumSuperShot = states.numSuperShot
    invaders_direction = "R"
    invaders_bullets = {}
    cannon_bullet = nil
    ufo_bullet = nil
    states.shot = false
    states.super_shot = false
    states.freeze = false
   
    drawStatus()
end

--- restart the current level of the game
function restartLevel()
    states.freeze = false  
    states.sequence_hits = 0
    states.time_freeze = nil
    states.shot = false
    states.super_shot = false
    states.numSuperShot = states.lastNumSuperShot
    states.ufo = false
    cannon = nil
    cannon_bullet = nil
    invaders = {}
    invaders_bullets = {}
    invaders_direction = "R"
    invaders_region = nil
    ufo = nil
    ufo_bullet = nil
    cannon_bullet = nil
    explosion = nil  
    states.time:stop()     
    start(states.level)

end

--- return to the first level of the game
function backToFirstLevel()
    dispose()
    reset()
    start(1)
end

--- clear the memory and quits the game
function exitGame()
   unregister()
   dispose()
   canvas:attrColor(0,0,0,255)
   canvas:clear()
   canvas:flush()
end

--- checks colision between two objects
function collision(obj1, obj2)
    
    if ((obj1 ~= nil) and (obj2 ~= nil)) then
        return obj1:getRegion():intersection(obj2:getRegion()) or obj2:getRegion():intersection(obj1:getRegion())
    end
    
    return false

end

--- saves the record in a file
function saveRecord()

    local records_file = io.open("../res/records.txt","w")
    
    records_file:write(states.records[1])
    for i=2, #states.records do
        records_file:write("\n"..states.records[i])
    end
    records_file:close()
    
end

---Save settings
function saveSettings()
    local SettingsFile = io.open("init.conf","w")
    
    SettingsFile:write(states.Settings[1])
    for i=2, #states.Settings do
       SettingsFile:write("\n"..states.Settings[i])
    end
   SettingsFile:close()
end

--- loads the records from a file
function loadRecord()
    for line in io.lines("../res/records.txt") do
        table.insert(states.records, tonumber(line))
    end

end

---load de file of settings
function loadSettings()
    local i = 1
    for line in io.lines("init.conf") do
        table.insert(states.Settings, line)
    end
end

--- move the invaders to left or right direction
function moveInvaders()

    if (invaders_direction == "R") then
        invaders_region:setX(invaders_region:getX() + states.speed)
        if (invaders_region:getLastX() >= 1280) then
            invaders_direction = "L"
            moveInvadersDown()
        end
        
    elseif (invaders_direction == "L") then
        invaders_region:setX(invaders_region:getX() - states.speed)
        if (invaders_region:getX() <= 0) then
            invaders_direction = "R"
            moveInvadersDown()
        end
        
    end
    
    
    local deaded = {}
    
    for i = 1, #invaders do
        if (invaders[i] ~= nil) then
        
            if (invaders[i]:getDead()) then
                invaders[i]:setLife(invaders[i]:getLife() - 1)
                if (invaders[i]:getLife() == 0) then
                    
                    table.insert(deaded,i)
                    
                end
            end
            
            clearRegion(invaders[i]:getRegion())
            if (invaders_direction == "R") then
                    invaders[i]:getRegion():setX(invaders[i]:getRegion():getX() + states.speed)
                elseif (invaders_direction == "L") then
                    invaders[i]:getRegion():setX(invaders[i]:getRegion():getX() - states.speed)
            end
                        
            if (invaders[i]:getLife() > 0) then
                invaders[i]:drawObject()
            end 
                                
        end
    end 
    
    for k=1, #deaded do
        table.remove(invaders,deaded[k])
    end
     
    
    if (#invaders > 0) then
        creatInvadersRegion(invaders)
    end
    
end

--- move the invaders down when they collides with wall
function moveInvadersDown()
    clearRegion(invaders_region)
    for i = 1, #invaders do
        if (invaders[i] ~= nil) then
            clearRegion(invaders[i]:getRegion())
            invaders[i]:getRegion():setY(invaders[i]:getRegion():getY() + 30)
            if (invaders[i]:getLife() > 0) then
                invaders[i]:drawObject()                
            end
        end
    end
    invaders_region:setY(invaders_region:getY() + 30)
end

--- move Cannon Defensor to right
function moveCannonRight()
    clearRegion(cannon:getRegion())
    local temp = cannon:getRegion():getLastX() + 30
    if (temp <= 1280) then

        cannon:getRegion():setX(cannon:getRegion():getX() + 30)
    end
end

--- move Cannon Defensor to left
function moveCannonLeft()
    local temp1 = Region:new(cannon:getRegion():getX(),cannon:getRegion():getY(),cannon:getRegion():getW(), cannon:getRegion():getH())
    
    local temp = cannon:getRegion():getX() - 30

    if (temp >= 0) then
        cannon:getRegion():setX(temp)
    end
    clearRegion(temp1)
end

--- move UFO through the screen
function moveUFO()

    clearRegion(ufo:getRegion())  
      
    if (ufo:getDead()) then
        ufo:setLife(ufo:getLife() - 1)
        if (ufo:getLife() == 0) then
            createUFO()
            states.ufo = false
        end
    end

    if (states.ufo) then
        local temp = ufo:getRegion():getX() + 15
    
        if (temp >= 1280) then
            createUFO()         
            states.ufo = false
        else
            ufo:getRegion():setX(temp)
        end
    end
    
    
    if (ufo:getLife() > 0) then
        ufo:drawObject()
    end 
        
end

--- move some bullet up
function moveBulletUp(obj)

    clearRegion(obj:getRegion())
    obj:getRegion():setY(obj:getRegion():getY() - 35)   
    obj:drawObject()    
    
end

--- move some bullet down
function moveBulletDown(obj)

    clearRegion(obj:getRegion())
    obj:getRegion():setY(obj:getRegion():getY() + 15)
    obj:drawObject()
                
end

--- Runs the game
function run()
    local shotProb = 99 - ((states.level - 1)*2)
    
    if (states.exit) then
        exitGame()
        return
    end
    
    if (states.back_first) then
         backToFirstLevel()
         return
    end
    
    if (states.restart_level) then
         restartLevel()
         return
    end
    
    if (states.freeze) then
        states.time:stop()
        if (states.time_freeze:getTime() == 7) then
            states.time._delay = 7
            states.time:getTime()
            states.freeze = false
            states.time_freeze:stop()
            states.time.isStarted = true
        end
        
    end 
    
    

    if ((math.random(250) == 250) and (not states.ufo)) then
        states.ufo = true
    end
        
    if (states.ufo) then    
    
        if ((math.random(100) >= shotProb) and (ufo_bullet == nil)) then
            if (ufo:getRegion():getX() > 0 and ufo:getRegion():getLastX() < 1280) then
                shotUFO()
            end
        end
        
    end     

    if (math.random(100) > shotProb and (#invaders > 0) and (not states.freeze)) then
        shotInv()
    end
    
    for i = 1, #invaders_bullets do
        if invaders_bullets[i] ~= nil and invaders_bullets[i]:getRegion():getLastY()+15 < 643  then
        
            moveBulletDown(invaders_bullets[i])
            
        else
            clearRegion(invaders_bullets[i]:getRegion())
            canvas:compose(invaders_bullets[i]:getRegion():getX() - 16, 623,invader_bullet_img2)
            drawCannon()
            canvas:flush()
            canvas:compose(invaders_bullets[i]:getRegion():getX() - 16, 623,background, invaders_bullets[i]:getRegion():getX() - 16,623, 36, 20)
            table.remove(invaders_bullets, i)
           break
        end
    end 
    
    for i = 1, #invaders_bullets do
        if invaders_bullets[i] ~= nil and (collision(invaders_bullets[i], cannon)) then
            cannon:setDead(true)        
            clearRegion(invaders_bullets[i]:getRegion())
            table.remove(invaders_bullets, i)
            break
            
        end
    end
    
    if (cannon_bullet ~= nil) then
        checkCannonBullet()
    end
    
    if (ufo_bullet ~= nil) then
        if ufo_bullet ~= nil and ufo_bullet:getRegion():getLastY()+15 <620 then
            moveBulletDown(ufo_bullet)
        elseif ufo_bullet ~= nil then
            clearRegion(ufo_bullet:getRegion())
            canvas:compose(ufo_bullet:getRegion():getX() - 5, ufo_bullet:getRegion():getY()+30,ufo_bullet_img2)
            drawCannon()
            canvas:flush()
            canvas:compose(ufo_bullet:getRegion():getX() - 5,  ufo_bullet:getRegion():getY()+30,background, ufo_bullet:getRegion():getX() - 16, 631, 72, 38)       
            ufo_bullet = nil
        end
        
        if ufo_bullet ~= nil and (ufo_bullet:getRegion():getY() >= 700) then
        
            ufo_bullet = nil
            
        elseif (collision(ufo_bullet, cannon)) then
                        
            cannon:setDead(true)        
            
            clearRegion(ufo_bullet:getRegion())
            
            ufo_bullet = nil
                
        end
    end
    
    if (#invaders > 0) then
        if (invaders[#invaders]:getRegion():getLastY()+15 >  cannon:getRegion():getY()) then
            states.init = true
            drawGameOver()
            return
        end
    end
    
    if (explosion ~= nil) then
        drawExplosion()
    end 
    
    
    if (#invaders > 0) then
        moveInvaders()
    else        
        drawWin()
        states.change_level = true      
        return
    end
    
    if (states.ufo) then
        moveUFO()
    end 
    
    if (states.shot) then
        moveBulletUp(cannon_bullet)
    end

    drawCannon()

    if (states.lifes <= 0) then
        drawGameOver()
        return
    end 
    
    
    
    if states.isRunning then
        event.timer(50, run)
    end

    states.thisTime = states.time:getTime()
    drawStatus()    
    canvas:flush()
    drawCannon()
end

--- starts the application
function start(level)
    
    reset()
    loadSettings()
    loadRecord()
    states.level =  level 
    canvas:compose(0,0,background)
    cmdBar:att(_,RESET,RESET_LEVEL,MENU,2,false,SHOT,3)
    cmdBar:show()
    drawBestTime()
    createInvaders()
    creatInvadersRegion(invaders)
    createCannon()
    createUFO()
    drawTopBar(background)
    drawInvaders()
    createTime()
    states.time:start()
    states.init = false
    states.restart_level = false
    run()
    drawCannon()
end

---The handler of main screen
local function key_handler(evt)
    if (evt.class == 'key' and evt.type == 'press') then
        if evt.key == 'CURSOR_LEFT' then
            moveCannonLeft()
            
        elseif evt.key == 'CURSOR_RIGHT' then
            moveCannonRight()
            
        elseif evt.key == 'CURSOR_UP' then
            if states.numSuperShot > 0 and states.super_shot == false and states.shot == false then
                states.super_shot = true
                states.numSuperShot = states.numSuperShot -1
                shot()
            end
                    
        elseif evt.key == 'ENTER' and states.init then
            states.init = false
            
            start(states.level)
        elseif evt.key == 'ENTER' and  states.backToMenu then
           require ("newInitScreen")
            states.isRunning = false
            event.timer(200,initScreen)
            --initScreen()
            unregister()
            dispose()
        elseif evt.key == 'ENTER' and states.lifes <= 0 then
            start(states.level)
            
        elseif evt.key == 'ENTER' and states.change_level then
            states.change_level = false
            changeLevel()
                
        elseif evt.key == 'ENTER' and (not states.shot) then
            shot()    
            
        elseif evt.key == 'GREEN' then
            states.back_first = true
            
        elseif evt.key == 'YELLOW' then
             states.restart_level = true
        elseif evt.key == 'BLUE' then
            require ("newInitScreen")
            states.isRunning = false
            event.timer(200,initScreen)
            --initScreen()
            unregister()
            dispose()
        elseif evt.key == 'EXIT' then
           -- exitGame()
            states.exit = true
        end
  end
end

function register()
    event.register(key_handler)
end
function unregister()
    event.unregister(key_handler)
end

