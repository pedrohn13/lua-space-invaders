Chronometer = {_ppause = 0,
            _delay = 0}

---
--@usage build a Chronometer object
function Chronometer:new()
    local t = {}
    setmetatable (t, self)
    self.__index = Chronometer
    return t
end

---
--@usage start the counter for this Chronometer
function Chronometer:start()
    if(not self.isStarted)then
        self.initialTime = event.uptime()
        self.isStarted = true
    end
end

function Chronometer:setInitialTime(newTime)
    self.initialTime = newTime
end
---
--@return the time that this Chronometer is running
function Chronometer:getTime()
    local saida = 0
    if(self.isStarted )then
        saida = math.floor((event.uptime() - self.initialTime)/1000) - self._delay
    else
        saida = self._ppause
    end
    
    return saida
end

---
--@usage returns the time that this Chronometer is running and stop this Chronometer
--@return the time that this Chronometer is running
function Chronometer:stop()
    self._ppause = self:getTime()
    self.isStarted = false
    return math.floor((event.uptime() - self.initialTime)/1000)
end
