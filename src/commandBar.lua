require("Label")

CommandBar = {}
local RES_PATH = "../res/"
local icOk = canvas:new(RES_PATH.."footer/ic-ok.png")
local navigate = {}
navigate[1] = canvas:new(RES_PATH.."footer/ic-navigate-1.png")
navigate[2] = canvas:new(RES_PATH.."footer/ic-navigate-2.png")
navigate[3] = canvas:new(RES_PATH.."footer/ic-navigate-4.png")

local styles = {}
styles.normal = {fontSize = 16, fontColor = {r = 255, g = 255, b = 255, a = 255}, backColor = {r = -1, g = -1, b = -1, a = 255}}
local IMAGE_PATH ="../res/elements/"
local background = canvas:new(IMAGE_PATH.."bg.png")
function generateX(name,from)
    canvas:attrFont('Tiresias', 16) -- set the font
    width=0
    if(name ~= nil)then
        width = canvas:measureText(name)
    end
    if(from == nil)then
        from=0
    end
    return from+width
end

function wordSize(name)
    return canvas:measureText(name)
end

function CommandBar:new(red,green,yellow,blue,navigatec,exit,ok, dualNavigatec)
    local instance = {}
    setmetatable(instance, self)
    self.__index = CommandBar
    instance.l1 = Label:new("")
    instance.l2 = Label:new("")
    instance.l3 = Label:new("")
    instance.l4 = Label:new("")
    instance.l1:setStyle(styles.normal)
    instance.l2:setStyle(styles.normal)
    instance.l3:setStyle(styles.normal)
    instance.l4:setStyle(styles.normal)
    instance.ok=ok
    if red then
        instance.red = red
        instance.l1.text = red
    end
    if green then
        instance.green = green
        instance.l2.text = green
    end
    if yellow then
        instance.yellow = yellow
        instance.l3.text = yellow
    end
    if blue then
        instance.blue = blue
        instance.l4.text = blue
    end
    instance.navigatec = navigatec
    instance.dualNavigatec = dualNavigatec
    instance.exit = exit
    
    return instance
end

function CommandBar:att(red,green,yellow,blue,navigatec,exit,ok,dualNavigatec)
    self.red = red
    if(red==nil)then red = "" end
    self.l1.text=red
    self.green = green
    if(green==nil)then green = "" end
    self.l2.text=green
    self.yellow = yellow
    if(yellow==nil)then yellow = "" end
    self.l3.text=yellow
    self.blue = blue
    if(blue==nil)then blue = "" end
    self.l4.text=blue
    self.navigatec = navigatec
    self.dualNavigatec = dualNavigatec
    self.exit = exit
    self.ok=ok
end

function CommandBar:show()
    canvas:compose(0,669,background,0,669,1300,200)
    if self.blue then
        canvas:compose(1154,682,canvas:new(RES_PATH.."footer/ic-blue-s.png"))
        self.l4.x=1186
        self.l4.y=682
        self.l4.w = 200
        self.l4.h = 30
        self.l4:paint()
    end
    if self.yellow then
        canvas:compose(1154-wordSize(self.l3.text)-40,682,canvas:new(RES_PATH.."footer/ic-yellow-s.png"))
        self.l3.x=1154-wordSize(self.l3.text)-40+34
        self.l3.y=682
        
        self.l3:paint()
    end
    if self.green then
        if (not self.blue) then
            canvas:compose(1154,682,canvas:new(RES_PATH.."footer/ic-green-s.png"))
            self.l2.x=1186
        else
            canvas:compose(self.l3.x-34-wordSize(self.l2.text)-40,682,canvas:new(RES_PATH.."footer/ic-green-s.png"))
            self.l2.x=self.l3.x-34-wordSize(self.l2.text)-40+34
        end 
        self.l2.y=682
        self.l2:paint()
    end
    if self.red then
        if (not self.green) and (not self.blue) and (not self.yellow) then
            canvas:compose(1154,682,canvas:new(RES_PATH.."footer/ic-red-s.png"))
            self.l1.x=1186
        else
            canvas:compose(self.l2.x-34-wordSize(self.l1.text)-40,682,canvas:new(RES_PATH.."footer/ic-red-s.png"))
            self.l1.x=self.l2.x-34-wordSize(self.l1.text)-40+34
        end
        self.l1.y=682
        self.l1:paint()
    end --blue yellow green red
    if self.dualNavigatec then
        canvas:compose(16,682,navigate[self.navigatec])
        l5 = Label:new(NAVIGATE_I)
        l5.x = 56
        l5.y = 682
        l5:setStyle(styles.normal)
        l5:paint()
        canvas:compose(generateX(l5.text,l5.x)+15,682,navigate[self.dualNavigatec])
        l7 = Label:new(SUPER_SHOT)
        l7.x = generateX(l5.text,l5.x+55) 
        l7.y = 682
        l7:setStyle(styles.normal)
        l7:paint()
        
        canvas:compose(generateX(l7.text,l7.x)+15,682,canvas:new(RES_PATH.."footer/ic-ok.png"))
        l6 = Label:new(self.ok or SELECT_I)
        l6.x = generateX(l7.text,l7.x)+55
        l6.y = 682
        l6:setStyle(styles.normal)
        l6:paint()
        canvas:flush()
    elseif self.navigatec then 
        canvas:compose(16,682,navigate[self.navigatec])
        l5 = Label:new(NAVIGATE_I)
        l5.x = 56
        l5.y = 682
        l5:setStyle(styles.normal)
        l5:paint()
        canvas:compose(generateX(l5.text,l5.x)+15,682,canvas:new(RES_PATH.."footer/ic-ok.png"))
        l6 = Label:new(self.ok or SELECT_I)
        l6.x = generateX(l5.text,l5.x)+55
        l6.y = 682
        l6:setStyle(styles.normal)
        l6:paint()
    else
        canvas:compose(16,682,canvas:new(RES_PATH.."footer/ic-ok.png"))
        l6 = Label:new(self.ok or SELECT_I)
        l6.x = 16+55
        l6.y = 682
        l6:setStyle(styles.normal)
        l6:paint()
    end
    if self.exit then
        canvas:compose(generateX(l6.text,l6.x)+15,682,canvas:new(RES_PATH.."footer/ic-back.png"))
        l7 = Label:new(BACK_I)
        l7.x = generateX(l6.text,l6.x)+55
        l7.y = 682
        l7:setStyle(styles.normal)
        l7:paint()
        
        canvas:compose(generateX(l7.text,l7.x)+15,682,canvas:new(RES_PATH.."footer/ic-exit.png"))
        l8 = Label:new(EXIT_I)
        l8.x = generateX(l7.text,l7.x)+55
        l8.y = 682
        l8:setStyle(styles.normal)
        l8:paint()
    else
        canvas:compose(generateX(l6.text,l6.x)+15,682,canvas:new(RES_PATH.."footer/ic-exit.png"))
        l8 = Label:new(EXIT_I)
        l8.x = generateX(l6.text,l6.x)+55
        l8.y = 682
        l8:setStyle(styles.normal)
        l8:paint()
    end
end
