---@class

Region = {

_x = 0,
_y = 0,
_w = 0,
_h = 0,
last_x = 0,
last_y = 0

}

--constructor
function Region:new(x,y,w,h)
    
    local table = {
        
        _x = x or 0,
        _y = y or 0,
        _w = w or 0,
        _h = h or 0,
        last_x = x + w,
        last_y = y + h
            
    }
    
    setmetatable(table, self)
    self.__index = self
    return table

end

--- checks intersection in this region with another
--@param another Region
--@return boolean true or false
function Region:intersection(region)
    
    local in_x = ((region:getX() > self._x) and (region:getX() < self.last_x)) or ((region:getLastX() > self._x) and (region:getLastX() < self.last_x))
    local in_y = ((region:getY() > self._y) and (region:getY() < self.last_y)) or ((region:getLastY() > self._y) and (region:getLastY() < self.last_y))
    
    return (in_x and in_y)
        
end

--- get the X coordinate of the region
--@return number of the X coordinate
function Region:getX()
    return self._x
end

--- get the Y coordinate of the region
--@return number of the Y coordinate
function Region:getY()
    return self._y
end

--- get the Width of the region
--@return number of the Width
function Region:getW()
    return self._w
end

--- get the Height of the region
--@return number of the Height
function Region:getH()
    return self._h
end

--- get the coordinate of the last X in the region
--@return number of the last X coordinate
function Region:getLastX()
    return self.last_x
end

--- get the coordinate of the last Y in the region
--@return number of the last Y coordinate
function Region:getLastY()
    return self.last_y
end

--- set the X coordinate of the region
--@param number of the new X coordinate
function Region:setX(x)
    self._x = x
    self.last_x = x + self._w
end

--- set the Y coordinate of the region
--@param number of the new Y coordinate
function Region:setY(y)
    self._y = y
    self.last_y = y + self._h
end

