local canvas, tonumber,print = canvas, tonumber, print

module("applicationManager")

function getRunningApplication(applicationType)
    local app = {["id"] = 1, ["name"] = "AppName", ["description"] = "AppDescription",
                    ["entrypoint"] = "AppEntryPoint", ["icon"] = "AppIconPath"}
    return app
end

function stopApplication(appId)
    if (tonumber(appId) ~= nil) then
        canvas:clear()
        canvas:flush()
    end
end
