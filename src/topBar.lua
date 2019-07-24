require("Region")
PATH_IMAGE = "../res/elements/"

local ic_life =     PATH_IMAGE.."ic_life.png"
local ic_life_off = PATH_IMAGE.."ic_life_off.png"
local icPowerShot = PATH_IMAGE.."ic_powershot.png"
local icPowerShot ={ powerShot0 = PATH_IMAGE.."ic_powershot0.png",
                    powerShot1 = PATH_IMAGE.."ic_powershot1.png",
                    powerShot2 = PATH_IMAGE.."ic_powershot2.png",
                    powerShot3 = PATH_IMAGE.."ic_powershot3.png",
                    powerShotOff = PATH_IMAGE.."ic_powershot_off.png"
                    }

local icPowerShotOff = PATH_IMAGE.."ic_powershot_off.png"
local topRegion = Region:new(0,0,1024,120)
local bg = nil

---Draw level 
local function drawLevel()
    canvas:attrFont ('Alien Encounters', 22)
    canvas:attrColor(179,179,179,255)
    canvas:drawText(1243-(canvas:measureText(LEVEL)+10),18,LEVEL)
end

---Draw all top bar elements
function drawTopBar(bgimg)
    bg = bgimg
    drawLifes()
    updateNumLifes(numLifes)
    drawPowerShot()
    updateNumSuperShot(numShot)
    drawLevel()
    updateLevel()
    updateTime(0)--newTime)
end

---Draw num of lifes
function drawLifes()
    local lifeImg = canvas:new(ic_life)
    canvas:compose(20,9,lifeImg)
    --canvas:flush()
end

---Update the number of lifes
function updateNumLifes(numLifes)
    local numLifes = numLifes or 3
    canvas:compose(20,24 , bg,20,24,30,30 )
    canvas:attrFont ('Alien Encounters', 16)
    canvas:attrColor(179,179,179,255)
    canvas:drawText(20,24,numLifes.."X")
end

---Draw the icon of Power Shot
function drawPowerShot(sequenceHits)
    sequenceHits = sequenceHits or 0
    
    print(sequenceHits)
    local powerShot = canvas:new(icPowerShot["powerShot"..sequenceHits])
    canvas:compose(65,9, bg,65,9,powerShot:attrSize())
    canvas:compose(65,9,powerShot)
    --canvas:flush()
end

---Update the number of Power Shot
function updateNumSuperShot(numShot)
    local numShot = numShot or 0
    canvas:compose(65,24 , bg,65,24,30,30 )
    canvas:attrFont ('Alien Encounters', 16)
    canvas:attrColor(179,179,179,255)
    canvas:drawText(65,24,numShot.."X")
    --canvas:flush()
end

---Update the level
function updateLevel(newLevel)
    local nLevel = newLevel or 1
    canvas:compose(1240,18, bg,1208,18,30,30)
    canvas:attrFont('Alien Encounters', 22)
    canvas:attrColor(179,179,179,255)
    canvas:drawText(1243,18,nLevel)
end

---Upadate the Time
--@params newTime is the new Time
--@params r is the value red in the rgb format of the color font
--@params g is the value green in the rgb format of the color font
--@params b is the value blue in the rgb format of the color font
--@params a is the value of the transparecy of the color font
function updateTime(newTime,r,g,b,a)
    local r = r or 179
    local g = g or 179
    local b = b or 179 
    local a = a or 255
    local newTime = newTime or 0
    local seconds = newTime%60
    local minutes = math.modf(newTime/60)
    if seconds < 10 then 
        seconds = "0"..seconds
    end
    
    if minutes < 10 then
        minutes = "0"..minutes
    end
    
    canvas:compose(1192,52, bg,1208,52,80,35)
    canvas:attrFont('Alien Encounters', 22)
    canvas:attrColor(r,g,b,a)
    canvas:drawText(1192,52,minutes..":"..seconds)
end
