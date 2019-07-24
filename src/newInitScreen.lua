require "commandBar"
require('topBar')
--require('mainGame')

local IMAGE_PATH ="../res/elements/"
local background = canvas:new(IMAGE_PATH.."bg-new.png")
local iconGame = canvas:new(IMAGE_PATH.."logo-initial64.png")
local bgStartGame = canvas:new(IMAGE_PATH.."bg_start_game.png")
local selector = 1
local informations = {}


function ldispose()
    IMAGE_PATH =nil
    background = nil
    iconGame = nil
    bgStartGame = nil
    selector = nil
    informations = nil
end

---Read the informations about the level
function  readLevelInformation()
   local file = io.open("init.conf","r")
    local line = file:read("*l")
    local lines = {}
    while line do 
      table.insert(lines, split(line, "|"))
      line = file:read("*l")
    end
    
    file:close()
    return lines
end


--- Splits the given string using a given separator. If no separator is used,
--  " " (a blank space) will be used.
--
--@param str The string to split.
--@param _separator pattern to be used on the splitting.
--@return a table with the split string.
function split(str, _separator) -- if no separator is used, " " is used
  words = {}
  separator = _separator or " "
  new_str = str
  while true do
    _index = string.find(new_str, separator) -- index of the separator
    workaround = true -- workaround to use continue statement

    if _index == nil then -- end of string or no separator
      table.insert(words, string.sub(new_str, 1))
      return words;
    end

    if _index == 1 then -- separator begins the string
      table.insert(words, "")
      new_str = string.sub(new_str, 2)
      workaround = false
    end

    if workaround then -- if separator is not on the beginning of the string
        -- the program enters this
      table.insert(words, string.sub(new_str, 1, _index -1))
      new_str = string.sub(new_str, _index + 1)
    end

  end
  return words
end

local frames = {
    default = canvas:new(IMAGE_PATH.."frame_default.png"),
    selected = canvas:new(IMAGE_PATH.."frame_select.png"),
    ic_1 = canvas:new(IMAGE_PATH.."frame_ic_1.png"),
    ic_2 = canvas:new(IMAGE_PATH.."frame_ic_2.png"),
    ic_3 = canvas:new(IMAGE_PATH.."frame_ic_3.png"),
    ic_4 = canvas:new(IMAGE_PATH.."frame_ic_4.png"),
    ic_5 = canvas:new(IMAGE_PATH.."frame_ic_5.png"),
    ic_lock = canvas:new(IMAGE_PATH.."frame_ic_lock.png")
    
}

local stars ={
        off = canvas:new(IMAGE_PATH.."star0.png"),
        on = canvas:new(IMAGE_PATH.."star1.png")
}

---Draw the name "LEVEL"
function drawNameLevel(x,y,level,lock)
    if not lock then
        canvas:compose(x,y, frames["ic_"..level])
    end
    local fLevel = "LEVEL "..level
    local y = y +187
    x = x + (frames["default"]:attrSize()/2 - canvas:measureText(fLevel)/2)
    canvas:drawText(x,y,fLevel)
end

--- Draw 3 stars in the screen
--@params x is the position x of the frame
--@params y is the position y of the frame
--@params numStars number of stars on
function drawStar(x,y, numStar)
    local star1 = {x = x+53, y = y+110}
    local star2 = {x = x+83, y = y+110}
    local star3 = {x = x+113, y = y+110}
    
    if numStar == "1" then
        canvas:compose(star1.x, star1.y, stars.on)
        canvas:compose(star2.x, star2.y, stars.off)
        canvas:compose(star3.x, star3.y, stars.off)
        
        
    elseif numStar == "2" then 
        canvas:compose(star1.x, star1.y, stars.on)
        canvas:compose(star2.x, star2.y, stars.on)
        canvas:compose(star3.x, star3.y, stars.off)
    elseif numStar == "3" then
        canvas:compose(star1.x, star1.y, stars.on)
        canvas:compose(star2.x, star2.y, stars.on)
        canvas:compose(star3.x, star3.y, stars.on)
    else
        canvas:compose(star1.x, star1.y, stars.off)
        canvas:compose(star2.x, star2.y, stars.off)
        canvas:compose(star3.x, star3.y, stars.off)
    end
    
        
end

---Draw the formated time
--@params x is the position x of the frame
--@params y is the position y of the frame
--@params seconds the best time in the current level(in seconds) 
function drawTime(x,y, seconds)
   local newTime = seconds or 0
    local seconds = newTime%60
    
    local minutes = math.modf(newTime/60)
    if seconds < 10 then 
        seconds = "0"..seconds
    end
    
    if minutes < 10 then
        minutes = "0"..minutes
    end
    
    local fTime = _
    local x,y = x,y+151
    
    canvas:attrColor(179,179,179,255)
    canvas:attrFont('Alien Encounters', 16)
    
    fTime = minutes..":"..seconds
    
    x = x + (frames.default:attrSize()/2 - canvas:measureText(fTime)/2)
    
    canvas:drawText(x,y,fTime)
end

---Draw the frame
--@params x is the position x of the frame
--@params y is the position y of the frame
--@params locked indicate if the level is locked or not
--@params selected indicates if the frame is selected or not
--@params level indicates the level
--@params numStar indicates the number of star on have the frame
--@params seconds the best time in the current level(in seconds) 
function drawFrame(x,y, locked, selected, level, numStar, seconds)
   
    canvas:compose(x,y, background, x, y, frames.default:attrSize())
    canvas:compose(x,y, bgStartGame, x, y-108, frames.default:attrSize())
    canvas:compose(x,y, frames.default)
   if not locked then
     drawNameLevel(x,y,level)
     drawStar(x,y, numStar)
     drawTime(x,y, seconds)
   else
        drawStar(x,y, 0)
        drawNameLevel(x,y,level,locked)
        drawTime(x,y, 0)
        canvas:compose(x,y, frames.ic_lock)
   end
    
    if selected then
        canvas:compose(x,y, frames.selected)
    end
end

---Calculate the X position of the frame
--@params the selecto number
function calculaX(selector)
    local initialX = 173
    return initialX+(selector*189)
end

---Select the information about the level
--@params indice  the number indicates what leve you are
function preparingDrawFrame(indice)
        local info =  informations[indice]
        local locked,level, numStar, seconds = info[1],info[2],info[3],info[4]
        if locked == "true" then 
                locked = true
        else
            locked = false
        end
        return info,locked,level, numStar, seconds
end

---Manage the Draw frame
function controlDrawFrame()
    local x = calculaX(0)
    local info,locked,level, numStar, seconds = preparingDrawFrame(1)
    
    drawFrame(x,296, false, true, level, numStar, seconds)
    for i=2, #informations do
        local x = calculaX(i-1)
        local info,locked,level, numStar, seconds = preparingDrawFrame(i)
        drawFrame(x,296, locked, selected, level, numStar, seconds)
    end
end

---Move Selector to left
function moveSelectorLeft()
    if selector >1 then
        local info,locked,level, numStar, seconds = preparingDrawFrame(selector)
        local x = calculaX(selector-1)
        drawFrame(x,296, locked, false, level, numStar, seconds)
        selector = selector-1
        info,locked,level, numStar, seconds = preparingDrawFrame(selector)
        x = calculaX(selector-1)
        drawFrame(x,296, locked, true, level, numStar, seconds)
        canvas:flush()
    end
end

---Move Selector to right
function moveSelectorRight()
    local info,locked,level, numStar, seconds = preparingDrawFrame(selector)
    local x = calculaX(selector-1)
    drawFrame(x,296, locked, false, level, numStar, seconds)
    if selector <5 then
        selector = selector + 1
    end
    local info,locked,level, numStar, seconds = preparingDrawFrame(selector)
    x = calculaX(selector-1)
    drawFrame(x,296, locked, true, level, numStar, seconds)
    canvas:flush()
end

---The handler
function initHandler(evt)
   local _,locked = preparingDrawFrame(selector)
   if (evt.class == 'key' and evt.type == 'press') then
    if evt.key == 'CURSOR_LEFT' then
        moveSelectorLeft()
    elseif evt.key == 'CURSOR_RIGHT' then
        moveSelectorRight()
    elseif evt.key == 'ENTER' then
        
        if not locked then
            function kinit()
            local i18n = require("i18n")
           require ("mainGame")
            local sel = selector
            selector = 1
            event.unregister(initHandler)
           register()
           -- event.register(key_handler)
            start(sel)
            canvas:flush()
        end

        local res, msg = pcall(kinit)
            
if (not res) then
    print(msg)
end
        end
     end
     end
end

---Draw all elements in the screen
function initScreen()
    informations = readLevelInformation()

    cmdBar = CommandBar:new(_,RESET,_,_,2,false,SHOT)
    canvas:compose(0,0,background)
    canvas:attrFont ('Alien Encounters', 16)
    canvas:attrColor(204,204,204,255)

    canvas:compose(background:attrSize()/2 - iconGame:attrSize()/2, 143, iconGame)
    canvas:compose(0,118,bgStartGame)

    canvas:attrFont ('Alien Encounters', 32)
    canvas:drawText(background:attrSize()/2 - canvas:measureText("SPACE DEFENDER")/2, 221,"SPACE DEFENDER")

    cmdBar:att(_,_,_,_,_,false,START_GAME)
    cmdBar:show()
    controlDrawFrame()

    canvas:flush()

    
    event.register(initHandler, 'key', 'press')
end

