require "basicZapper"
epg_events = {
    id = 0,
    name = nil,
    start = 0,
    duration = 0,
    shortDesc = nil,
    channelId = 0
}
---Create a new epg
function epg_events:new(id,name,start,duration,shortDesc,channelId)
    local instance = {}
        setmetatable(instance,self)
        self.__index = Channel

        instance.id = id
        instance.name = name
    instance.start = start
    instance.duration = duration
    instance.shortDesc = shortDesc
    instance.channelId = channelId

        return instance
end


channels = {
    listOfEPGEvents = {}
}




for k,v in pairs(control.channelsTable) do
    table.insert(channels.listOfEPGEvents,epg_events:new(k,"Program "..k,3600,7200,"A short description of the current event in the "..v.name.." channel.",v.id))
end

channels.getCurrentEventInfo = function(channelId)
    for k,v in pairs(channels.listOfEPGEvents) do
        if v.channelId == channelId then
            return v
        end 
    end
    return nil
end

--[[
    this is a way you can use this functions 
print(channels.getCurrentEventInfo( control.getCurrentChannel().id ).shortDesc)
print(channels.getCurrentEventInfo( control.getCurrentChannel().id ).name)
print(channels.getCurrentEventInfo( control.getCurrentChannel().id ).channelId)
--]]
