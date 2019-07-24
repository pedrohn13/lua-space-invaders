local i18n = {}

local control = require("basicZapper")

function i18n.setCurrentLanguageResources()
    language = control.getSystemPreference("currentLanguage"):lower()
    local ret, err = pcall(dofile, "i18n/"..language..".lua")
    if (err) then
        dofile("i18n/en.lua")
    end
end

return i18n
