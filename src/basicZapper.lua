Channel = {
    id = 0,
    number = 0,
    name = nil
}
---This simule the Zapper
function Channel:new(number,id, name)
    local instance = {}
    setmetatable(instance,self)
    self.__index = Channel

    instance.id = id
    instance.number = number
    instance.name = name
    
    return instance
end

control = {
    channelsTable = {},
    currentChannel = 1
}

table.insert(control.channelsTable,Channel:new(1,1430,"Rede Globo"))
table.insert(control.channelsTable,Channel:new(2,980,"Esporte Interativo"))
table.insert(control.channelsTable,Channel:new(3,1340,"Band"))
table.insert(control.channelsTable,Channel:new(4,1260,"Rede Vida"))
table.insert(control.channelsTable,Channel:new(5,1415,"SBT"))
table.insert(control.channelsTable,Channel:new(6,1370,"Rede TV"))
table.insert(control.channelsTable,Channel:new(7,1295,"Record"))
table.insert(control.channelsTable,Channel:new(8,1000,"Record News"))
table.insert(control.channelsTable,Channel:new(9,1040,"Shop Time"))
table.insert(control.channelsTable,Channel:new(10,1030,"TV Gazeta")) 



control.getCurrentChannel = function()
    return control.channelsTable[control.currentChannel]
end

control.setCurrentChannel = function(channelNumber)
    if(channelNumber >= 1 and channelNumber <= 10) then
        control.currentChannel = channelNumber
    end
end

control.getSystemPreference = function(key)
    if (key == "currentLanguage") then
        return "pt"
    --  return settings.system.language
    end
end

return control
