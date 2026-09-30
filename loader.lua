--[[
    ===================================================================
    🏎️ DREAM CAR COLLECTION HUB - LOADER V1.0
    Game: [💭] Bộ sưu tập xe mơ ước (Dream Car Collection)
    Developer Group: F Students = Inventors
    Repository: https://github.com/khahuynh963/cars.git
    Author: khahuynh963
    Tương thích 100%: Delta Executor (Android & PC), Codex, Wave, Hydrogen, Fluxus, Solara.
    ===================================================================
--]]

pcall(function()
    local container = (gethui and gethui()) or game:GetService("CoreGui")
    if container then
        if container:FindFirstChild("DreamCarCollectionHubGui") then
            container.DreamCarCollectionHubGui:Destroy()
        end
        if container:FindFirstChild("DreamCarHubGui") then
            container.DreamCarHubGui:Destroy()
        end
    end
    local pl = game:GetService("Players").LocalPlayer
    if pl and pl:FindFirstChild("PlayerGui") then
        if pl.PlayerGui:FindFirstChild("DreamCarCollectionHubGui") then
            pl.PlayerGui.DreamCarCollectionHubGui:Destroy()
        end
        if pl.PlayerGui:FindFirstChild("DreamCarHubGui") then
            pl.PlayerGui.DreamCarHubGui:Destroy()
        end
    end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/khahuynh963/cars/main/script.lua?v=" .. tostring(os.time()) .. "_" .. tostring(math.random(10000, 99999))))()
