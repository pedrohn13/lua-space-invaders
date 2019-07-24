function init()
local i18n = require("i18n")
    i18n.setCurrentLanguageResources()
    require ('newInitScreen')
    initScreen()
end

local res, msg = pcall(init)

if (not res) then
    print(msg)
end
