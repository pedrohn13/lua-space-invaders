---@class

require('Region')

Object = {

_reg = nil,
_tab = {},
_life = 0,
_dead = false

}

--constructor
function Object:new(x,y,tab,life,dead)
    
    img_w, img_h = tab[1]:attrSize()
    
    local table = {
        
        _reg = Region:new(x, y, img_w, img_h),
        _tab = tab,
        _life = life,
        _dead = dead
            
    }
    
    setmetatable(table, self)
    self.__index = self
    return table

end

--- draws on the screen the image of the object
function Object:drawObject()
        
    canvas:compose(self._reg:getX(), self._reg:getY(), self._tab[self._life])
    
end

--- return the Region of the object
--@return Region
function Object:getRegion()
    return self._reg
end

--- get number of lifes of the object
--@return number of lifes
function Object:getLife()
    return self._life
end

--- set number of lifes of the object
--@param number of new lifes
function Object:setLife(int)
    self._life = int
end

--- get if the object is dead or alive
--@return boolean true or false
function Object:getDead()
    return self._dead
end

--- set if the object is dead or alive
--@param boolean true or false
function Object:setDead(bollean)
    self._dead = bollean
end

function Object:draw_off()
    
    canvas:compose(self._reg:getX(), self._reg:getY(), self._tab[#self._tab])

end
