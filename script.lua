--[[
    ===================================================================
    🏎️ DREAM CAR COLLECTION HUB - BỘ SƯU TẬP XE MƠ ƯỚC V1.0
    Game: [💭] Bộ sưu tập xe mơ ước (Dream Car Collection)
    Developer Group: F Students = Inventors
    Repository: https://github.com/khahuynh963/cars.git
    Author: khahuynh963
    Tương thích 100%: Delta Executor (Android & PC), Codex, Wave, Hydrogen, Fluxus, Solara.
    
    CÁC TÍNH NĂNG NỔI BẬT:
    1. 📦 AUTO CRATE / HATCH: Tự động mua & mở rương (Lucky Crate, Cosmic Crate), Skip hoạt ảnh, Auto Bán/Xóa xe rác.
    2. 🏎️ AUTO ECONOMY: Tự động hút tiền trong Showroom, Auto Trang Bị Xe Xịn Nhất (Equip Best), Auto Nâng Cấp Garage.
    3. 🔄 AUTO PROGRESSION: Tự động Tái Sinh (Rebirth), Tự Nhận Quà Nhiệm Vụ, Quà Hằng Ngày, Thưởng Mục Lục Xe (Index).
    4. 🚿 AUTO CAR WASH: Tự động đưa xe vào trạm xịt rửa ASMR kiếm tiền & kinh nghiệm.
    5. 🎁 AUTO REDEEM CODES: Tự động nhập tất cả mã Code mới nhất (100XHATCH, RELEASE, LARP, DISCORDWELCOME).
    6. ⚡ TIỆN ÍCH & TỐI ƯU: Chống Disconnect 24/7 (Anti-AFK), Siêu Mượt 60 FPS, Tăng Tốc Chạy (Speed Boost).
    ===================================================================
--]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local VirtualInputManager = nil
pcall(function()
    VirtualInputManager = game:GetService("VirtualInputManager")
end)

local LocalPlayer = Players.LocalPlayer

-- Khai báo trước ScreenGui để các hàm helper không bị lỗi nil IsDescendantOf
local ScreenGui = nil

local function isOurGui(obj)
    if not obj then return false end
    if ScreenGui and obj:IsDescendantOf(ScreenGui) then
        return true
    end
    local name = obj.Name
    if name == "DreamCarCollectionHubGui" or name == "DreamCarHubGui" then
        return true
    end
    if obj:FindFirstAncestor("DreamCarCollectionHubGui") or obj:FindFirstAncestor("DreamCarHubGui") then
        return true
    end
    return false
end

-- ── Safe GUI Container Helper ──
local function getGuiContainer()
    local container = nil
    pcall(function()
        if gethui then
            container = gethui()
        elseif syn and syn.protect_gui then
            local f = Instance.new("Folder")
            syn.protect_gui(f)
            f.Parent = game:GetService("CoreGui")
            container = f
        elseif game:GetService("CoreGui") then
            container = game:GetService("CoreGui")
        end
    end)
    if not container then
        pcall(function()
            container = LocalPlayer:WaitForChild("PlayerGui")
        end)
    end
    return container
end

-- Dọn sạch GUI cũ nếu đã nạp trước đó
pcall(function()
    local c = getGuiContainer()
    if c and c:FindFirstChild("DreamCarCollectionHubGui") then
        c.DreamCarCollectionHubGui:Destroy()
    end
    if game:GetService("CoreGui"):FindFirstChild("DreamCarCollectionHubGui") then
        game:GetService("CoreGui").DreamCarCollectionHubGui:Destroy()
    end
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("DreamCarCollectionHubGui") then
        LocalPlayer.PlayerGui.DreamCarCollectionHubGui:Destroy()
    end
end)

-- ── Xử Lý Chuỗi Tiếng Việt (Bỏ Dấu Để So Khớp 100% Chính Xác) ──
local VIETNAMESE_ACCENTS = {
    {"á", "a"}, {"à", "a"}, {"ả", "a"}, {"ã", "a"}, {"ạ", "a"},
    {"â", "a"}, {"ấ", "a"}, {"ầ", "a"}, {"ẩ", "a"}, {"ẫ", "a"}, {"ậ", "a"},
    {"ă", "a"}, {"ắ", "a"}, {"ằ", "a"}, {"ẳ", "a"}, {"ẵ", "a"}, {"ặ", "a"},
    {"Á", "a"}, {"À", "a"}, {"Ả", "a"}, {"Ã", "a"}, {"Ạ", "a"},
    {"Â", "a"}, {"Ấ", "a"}, {"Ầ", "a"}, {"Ẩ", "a"}, {"Ẫ", "a"}, {"Ậ", "a"},
    {"Ă", "a"}, {"Ắ", "a"}, {"Ằ", "a"}, {"Ẳ", "a"}, {"Ẵ", "a"}, {"Ặ", "a"},
    {"é", "e"}, {"è", "e"}, {"ẻ", "e"}, {"ẽ", "e"}, {"ẹ", "e"},
    {"ê", "e"}, {"ế", "e"}, {"ề", "e"}, {"ể", "e"}, {"ễ", "e"}, {"ệ", "e"},
    {"É", "e"}, {"È", "e"}, {"Ẻ", "e"}, {"Ẽ", "e"}, {"Ẹ", "e"},
    {"Ê", "e"}, {"Ế", "e"}, {"Ề", "e"}, {"Ể", "e"}, {"Ễ", "e"}, {"Ệ", "e"},
    {"í", "i"}, {"ì", "i"}, {"ỉ", "i"}, {"ĩ", "i"}, {"ị", "i"},
    {"Í", "i"}, {"Ì", "i"}, {"Ỉ", "i"}, {"Ĩ", "i"}, {"Ị", "i"},
    {"ó", "o"}, {"ò", "o"}, {"ỏ", "o"}, {"õ", "o"}, {"ọ", "o"},
    {"ô", "o"}, {"ố", "o"}, {"ồ", "o"}, {"ổ", "o"}, {"ỗ", "o"}, {"ộ", "o"},
    {"ơ", "o"}, {"ớ", "o"}, {"ờ", "o"}, {"ở", "o"}, {"ỡ", "o"}, {"ợ", "o"},
    {"Ó", "o"}, {"Ò", "o"}, {"Ỏ", "o"}, {"Õ", "o"}, {"Ọ", "o"},
    {"Ô", "o"}, {"Ố", "o"}, {"Ồ", "o"}, {"Ổ", "o"}, {"Ỗ", "o"}, {"Ộ", "o"},
    {"Ơ", "o"}, {"Ớ", "o"}, {"Ờ", "o"}, {"Ở", "o"}, {"Ỡ", "o"}, {"Ợ", "o"},
    {"ú", "u"}, {"ù", "u"}, {"ủ", "u"}, {"ũ", "u"}, {"ụ", "u"},
    {"ư", "u"}, {"ứ", "u"}, {"ừ", "u"}, {"ử", "u"}, {"ữ", "u"}, {"ự", "u"},
    {"Ú", "u"}, {"Ù", "u"}, {"Ủ", "u"}, {"Ũ", "u"}, {"Ụ", "u"},
    {"Ư", "u"}, {"Ứ", "u"}, {"Ừ", "u"}, {"Ử", "u"}, {"Ữ", "u"}, {"Ự", "u"},
    {"ý", "y"}, {"ỳ", "y"}, {"ỷ", "y"}, {"ỹ", "y"}, {"ỵ", "y"},
    {"Ý", "y"}, {"Ỳ", "y"}, {"Ỷ", "y"}, {"Ỹ", "y"}, {"Ỵ", "y"},
    {"đ", "d"}, {"Đ", "d"}
}

local function stripAccents(str)
    if not str or type(str) ~= "string" then return "" end
    local clean = str:gsub("<[^>]->", "")
    for _, pair in ipairs(VIETNAMESE_ACCENTS) do
        clean = clean:gsub(pair[1], pair[2])
    end
    return clean:lower()
end

-- ── Tìm Nút GuiButton Hợp Lệ Cho Bất Kỳ Object Nào (Hỗ Trợ Sibling, Ancestor, Child) ──
local function resolveClickableButton(obj)
    if not obj then return nil end
    if obj:IsA("GuiButton") then return obj end
    local btn = obj:FindFirstAncestorWhichIsA("GuiButton")
    if btn then return btn end
    if obj.Parent then
        local sibBtn = obj.Parent:FindFirstChildWhichIsA("GuiButton")
        if sibBtn then return sibBtn end
        if obj.Parent.Parent then
            local pSibBtn = obj.Parent.Parent:FindFirstChildWhichIsA("GuiButton")
            if pSibBtn then return pSibBtn end
        end
    end
    local childBtn = obj:FindFirstChildWhichIsA("GuiButton")
    if childBtn then return childBtn end
    return obj
end

-- ── Multi-Input Click Helper (Bắn Sự Kiện + Touch + Mouse Click Chuẩn Xác) ──
local function clickGuiObject(obj)
    if not obj then return false end
    local clicked = false

    local btn = resolveClickableButton(obj)
    local targets = {}
    if btn and btn:IsA("GuiObject") then table.insert(targets, btn) end
    if obj and obj:IsA("GuiObject") and obj ~= btn then table.insert(targets, obj) end

    for _, target in ipairs(targets) do
        if target:IsA("GuiButton") then
            pcall(function()
                if firesignal then
                    firesignal(target.MouseButton1Down)
                    firesignal(target.MouseButton1Click)
                    firesignal(target.Activated)
                    firesignal(target.MouseButton1Up)
                    clicked = true
                end
            end)

            pcall(function()
                if getconnections then
                    for _, conn in ipairs(getconnections(target.Activated)) do
                        pcall(function() conn:Fire() end)
                        clicked = true
                    end
                    for _, conn in ipairs(getconnections(target.MouseButton1Click)) do
                        pcall(function() conn:Fire() end)
                        clicked = true
                    end
                    for _, conn in ipairs(getconnections(target.MouseButton1Down)) do
                        pcall(function() conn:Fire() end)
                        clicked = true
                    end
                    for _, conn in ipairs(getconnections(target.MouseButton1Up)) do
                        pcall(function() conn:Fire() end)
                        clicked = true
                    end
                end
            end)
        end
    end

    local prim = targets[1] or obj
    if prim and prim.AbsolutePosition and prim.AbsoluteSize then
        local x = prim.AbsolutePosition.X + (prim.AbsoluteSize.X / 2)
        local y = prim.AbsolutePosition.Y + (prim.AbsoluteSize.Y / 2)
        if x > 0 and y > 0 then
            pcall(function()
                if VirtualInputManager then
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
                    task.wait(0.03)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
                    clicked = true
                end
            end)
            pcall(function()
                if VirtualInputManager then
                    VirtualInputManager:SendTouchEvent(1, 0, x, y)
                    task.wait(0.03)
                    VirtualInputManager:SendTouchEvent(1, 2, x, y)
                    clicked = true
                end
            end)
            pcall(function()
                if VirtualUser then
                    VirtualUser:ClickButton1(Vector2.new(x, y))
                    VirtualUser:Button1Down(Vector2.new(x, y))
                    task.wait(0.03)
                    VirtualUser:Button1Up(Vector2.new(x, y))
                    clicked = true
                end
            end)
        end
    end

    return clicked
end

-- ── Kích Hoạt ProximityPrompt ──
local function triggerPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    pcall(function()
        prompt.RequiresLineOfSight = false
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = 99999
    end)
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt, 0)
            fireproximityprompt(prompt, 100)
            fireproximityprompt(prompt)
        end
    end)
    pcall(function()
        prompt:InputHoldBegin()
        task.wait(0.02)
        prompt:InputHoldEnd()
    end)
end

-- ── Caching & Tìm Kiếm RemoteEvent / RemoteFunction Thông Minh ──
local CachedRemotes = {}
local function findRemote(keywords)
    local key = table.concat(keywords, "_")
    if CachedRemotes[key] and CachedRemotes[key].Parent then
        return CachedRemotes[key]
    end

    local candidate = nil
    for _, desc in ipairs(ReplicatedStorage:GetDescendants()) do
        if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then
            local n = desc.Name:lower()
            for _, kw in ipairs(keywords) do
                if n:find(kw:lower()) then
                    candidate = desc
                    break
                end
            end
            if candidate then break end
        end
    end

    if not candidate then
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            for _, desc in ipairs(pGui:GetDescendants()) do
                if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then
                    local n = desc.Name:lower()
                    for _, kw in ipairs(keywords) do
                        if n:find(kw:lower()) then
                            candidate = desc
                            break
                        end
                    end
                    if candidate then break end
                end
            end
        end
    end

    if candidate then
        CachedRemotes[key] = candidate
    end
    return candidate
end

-- ── State Management ──
local State = {
    -- 1. Auto Crate / Hatch
    AutoOpenCrates = false,
    SelectedCrateIndex = 1,
    SkipHatchAnimation = true,
    AutoDeleteCars = false,
    DeleteRarities = {
        Common = true,      -- Thường (Bán/Xóa dọn túi)
        Uncommon = true,    -- Không phổ biến (Bán/Xóa)
        Rare = true,        -- Hiếm (Bán/Xóa)
        Epic = false,       -- Huyền tuyệt (Khóa an toàn)
        Legendary = false,  -- Huyền thoại (Khóa an toàn)
        Mythic = false,     -- Mythic (Khóa an toàn)
        Secret = false      -- Bí mật / Exotic (Khóa an toàn)
    },

    -- 2. Auto Economy & Garage
    AutoCollectCash = true,
    AutoEquipBest = false,
    AutoUpgradeGarage = false,

    -- 3. Auto Progression & Rebirth
    AutoRebirth = false,
    RebirthThresholdIndex = 1,
    AutoClaimQuests = true,
    AutoClaimIndex = true,

    -- 4. Car Wash & Minigames
    AutoWashCar = false,

    -- 5. Utilities & Performance
    AntiAFK = true,
    FPSBooster = false,
    CustomSpeed = 16,
    EnableCustomSpeed = false
}

local CratePresets = {
    {Name = "📦 Lucky Crate (Rương May Mắn)", Key = "Lucky Crate", Id = 1},
    {Name = "🌟 Cosmic Crate (Rương Vũ Trụ)", Key = "Cosmic Crate", Id = 2},
    {Name = "💎 Super Crate (Rương Siêu Cấp)", Key = "Super Crate", Id = 3},
    {Name = "⚪ Basic Crate (Rương Cơ Bản)", Key = "Basic Crate", Id = 4}
}

local RebirthThresholds = {
    {Name = "25M Cash", Value = 25000000},
    {Name = "50M Cash", Value = 50000000},
    {Name = "100M Cash", Value = 100000000},
    {Name = "250M Cash", Value = 250000000},
    {Name = "500M Cash", Value = 500000000},
    {Name = "1B Cash", Value = 1000000000}
}

-- ── Thống Kê & Bảng Trạng Thái ──
local TotalHatched = 0
local TotalCashCollected = 0
local TotalRebirths = 0

local updateStatusUI = function(msg) end
local updateStatsUI = function() end

local lastStatusMsg = ""
local function setStatus(msg)
    if msg == lastStatusMsg then return end
    lastStatusMsg = msg
    pcall(function()
        updateStatusUI(msg)
    end)
end

-- ── Lấy Dữ Liệu Tiền (Cash) & Rebirth Của Người Chơi ──
local function getPlayerStats()
    local cash = 0
    local gems = 0
    local rebirths = 0

    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local cVal = leaderstats:FindFirstChild("Cash") or leaderstats:FindFirstChild("Tiền") or leaderstats:FindFirstChild("Money")
        if cVal and cVal:IsA("ValueObject") then cash = tonumber(cVal.Value) or 0 end

        local gVal = leaderstats:FindFirstChild("Gems") or leaderstats:FindFirstChild("Đá quý") or leaderstats:FindFirstChild("Gem")
        if gVal and gVal:IsA("ValueObject") then gems = tonumber(gVal.Value) or 0 end

        local rVal = leaderstats:FindFirstChild("Rebirth") or leaderstats:FindFirstChild("Rebirths") or leaderstats:FindFirstChild("Tái sinh")
        if rVal and rVal:IsA("ValueObject") then rebirths = tonumber(rVal.Value) or 0 end
    end

    -- Tìm qua Player attributes nếu không dùng leaderstats
    if cash == 0 then
        local attrCash = LocalPlayer:GetAttribute("Cash") or LocalPlayer:GetAttribute("Money")
        if attrCash then cash = tonumber(attrCash) or 0 end
    end
    if rebirths == 0 then
        local attrR = LocalPlayer:GetAttribute("Rebirth") or LocalPlayer:GetAttribute("Rebirths")
        if attrR then rebirths = tonumber(attrR) or 0 end
    end

    return cash, gems, rebirths
end

local function formatNumber(n)
    if not n or n == 0 then return "0" end
    if n >= 1e12 then return string.format("%.2fT", n / 1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n / 1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n / 1e6)
    elseif n >= 1e3 then return string.format("%.2fK", n / 1e3)
    else return tostring(math.floor(n)) end
end

-- ── Tìm Khu Vực Showroom / Garage Của Người Chơi Trong Map ──
local function getPlayerBase()
    local possibleContainers = {
        Workspace:FindFirstChild("Plots"),
        Workspace:FindFirstChild("Bases"),
        Workspace:FindFirstChild("Garages"),
        Workspace:FindFirstChild("Showrooms"),
        Workspace:FindFirstChild("Tycoons")
    }

    local pName = LocalPlayer.Name:lower()
    local pUserId = tostring(LocalPlayer.UserId)

    for _, container in ipairs(possibleContainers) do
        if container then
            for _, plot in ipairs(container:GetChildren()) do
                local oVal = plot:FindFirstChild("Owner") or plot:FindFirstChild("Player")
                if oVal and (oVal.Value == LocalPlayer or tostring(oVal.Value):lower() == pName or tostring(oVal.Value) == pUserId) then
                    return plot
                end
                local n = plot.Name:lower()
                if n:find(pName) or n:find(pUserId) then
                    return plot
                end
                local sign = plot:FindFirstChild("Sign") or plot:FindFirstChild("OwnerSign")
                if sign then
                    for _, d in ipairs(sign:GetDescendants()) do
                        if d:IsA("TextLabel") and (d.Text:lower():find(pName)) then
                            return plot
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════
-- 📦 MODULE 1: AUTO CRATE / HATCH SYSTEM
-- ═══════════════════════════════════════════════════════════

local isOpeningCrate = false
local function openSelectedCrate()
    if isOpeningCrate then return end
    isOpeningCrate = true

    local crateInfo = CratePresets[State.SelectedCrateIndex]
    local crateName = crateInfo.Key

    pcall(function()
        -- 1. Bắn Remote Mở Rương nếu có
        local hatchRemote = findRemote({"buycrate", "opencrate", "hatchcrate", "hatch", "open", "buyegg", "spawncrate", "crate"})
        if hatchRemote then
            if hatchRemote:IsA("RemoteEvent") then
                hatchRemote:FireServer(crateName, 1)
                hatchRemote:FireServer(crateInfo.Id, 1)
                hatchRemote:FireServer(crateName)
                hatchRemote:FireServer(1)
            elseif hatchRemote:IsA("RemoteFunction") then
                hatchRemote:InvokeServer(crateName, 1)
                hatchRemote:InvokeServer(crateInfo.Id)
            end
        end

        -- 2. Dự phòng: Tìm Bệ / Pod Mở Rương trong Plot cá nhân hoặc Workspace
        local base = getPlayerBase()
        local searchRoots = {base, Workspace:FindFirstChild("Crates"), Workspace:FindFirstChild("Unboxing"), Workspace}
        for _, root in ipairs(searchRoots) do
            if root then
                for _, prompt in ipairs(root:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        local act = stripAccents(prompt.ActionText or ""):lower()
                        local obj = stripAccents(prompt.ObjectText or ""):lower()
                        if (act:find("open") or act:find("buy") or act:find("hatch") or act:find("mo") or act:find("mua"))
                           and (obj:find("crate") or obj:find("car") or obj:find("ruong") or obj:find("xe") or obj:find("lucky")) then
                            triggerPrompt(prompt)
                            break
                        end
                    end
                end
            end
        end

        -- 3. Bỏ qua hoạt ảnh mở hộp (Skip Animation)
        if State.SkipHatchAnimation then
            local pGui = LocalPlayer:FindFirstChild("PlayerGui")
            if pGui then
                for _, screen in ipairs(pGui:GetChildren()) do
                    if screen:IsA("ScreenGui") and not isOurGui(screen) then
                        for _, f in ipairs(screen:GetChildren()) do
                            local fName = f.Name:lower()
                            if fName:find("hatch") or fName:find("crate") or fName:find("cutscene") or fName:find("unboxing") then
                                pcall(function() f.Visible = false end)
                            end
                        end
                    end
                end
            end
        end

        TotalHatched = TotalHatched + 1
        setStatus("📦 Đã mở rương: " .. crateInfo.Name .. " (Tổng: " .. tostring(TotalHatched) .. ")")
    end)

    task.wait(State.SkipHatchAnimation and 0.15 or 0.75)
    isOpeningCrate = false
end

-- ═══════════════════════════════════════════════════════════
-- 🏎️ MODULE 2: AUTO ECONOMY & GARAGE (HÚT TIỀN & EQUIP BEST)
-- ═══════════════════════════════════════════════════════════

local function collectShowroomCash()
    pcall(function()
        -- 1. Bắn Remote thu tiền
        local collectRemote = findRemote({"collectcash", "claimcash", "claimmoney", "collectmoney", "cashout", "collect", "cash"})
        if collectRemote then
            if collectRemote:IsA("RemoteEvent") then
                collectRemote:FireServer()
                collectRemote:FireServer("All")
                collectRemote:FireServer(true)
            elseif collectRemote:IsA("RemoteFunction") then
                collectRemote:InvokeServer()
            end
        end

        -- 2. Tự động chạm Part / Tiền trong Showroom của người chơi
        local base = getPlayerBase()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if base and hrp then
            for _, desc in ipairs(base:GetDescendants()) do
                if desc:IsA("BasePart") then
                    local dName = desc.Name:lower()
                    if dName:find("cash") or dName:find("money") or dName:find("collect") or dName:find("tien") then
                        pcall(function()
                            if firetouchinterest then
                                firetouchinterest(hrp, desc, 0)
                                task.wait(0.01)
                                firetouchinterest(hrp, desc, 1)
                            end
                        end)
                    end
                elseif desc:IsA("ProximityPrompt") then
                    local act = stripAccents(desc.ActionText or ""):lower()
                    local obj = stripAccents(desc.ObjectText or ""):lower()
                    if act:find("collect") or act:find("claim") or act:find("nhan") or act:find("thu")
                       or obj:find("cash") or obj:find("money") or obj:find("tien") then
                        triggerPrompt(desc)
                    end
                end
            end
        end
    end)
end

local function executeEquipBestCars()
    pcall(function()
        -- 1. Remote Equip Best
        local equipRemote = findRemote({"equipbest", "autoequip", "bestcars", "equipall", "equipbestcars", "setbest"})
        if equipRemote then
            if equipRemote:IsA("RemoteEvent") then
                equipRemote:FireServer()
                equipRemote:FireServer(true)
            elseif equipRemote:IsA("RemoteFunction") then
                equipRemote:InvokeServer()
            end
            setStatus("🏎️ Đã tự động trang bị các mẫu xe mạnh nhất vào Showroom!")
            return
        end

        -- 2. Tìm nút Equip Best trên giao diện game
        local pGui = LocalPlayer:FindFirstChild("PlayerGui")
        if pGui then
            for _, desc in ipairs(pGui:GetDescendants()) do
                if not isOurGui(desc) and (desc:IsA("TextLabel") or desc:IsA("TextButton")) then
                    local txt = stripAccents(desc.Text or "")
                    if txt:find("equip best") or txt:find("trang bi tot nhat") or txt:find("chon xe tot nhat") then
                        local btn = resolveClickableButton(desc)
                        if btn then
                            clickGuiObject(btn)
                            setStatus("🏎️ Đã bấm nút Equip Best trên màn hình!")
                            return
                        end
                    end
                end
            end
        end
    end)
end

local function executeUpgradeGarage()
    pcall(function()
        local upRemote = findRemote({"upgradeslot", "upgradebase", "upgradeshowroom", "buyupgrade", "upgrade", "buyslot"})
        if upRemote then
            if upRemote:IsA("RemoteEvent") then
                upRemote:FireServer()
                upRemote:FireServer("Slot")
                upRemote:FireServer("OfflineCash")
            elseif upRemote:IsA("RemoteFunction") then
                upRemote:InvokeServer()
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- 🔄 MODULE 3: AUTO REBIRTH & REWARDS (TÁI SINH & NHẬN THƯỞNG)
-- ═══════════════════════════════════════════════════════════

local function checkAndRebirth()
    pcall(function()
        local currentCash, _, currentRebirths = getPlayerStats()
        local targetCash = RebirthThresholds[State.RebirthThresholdIndex].Value

        if currentCash >= targetCash then
            setStatus("🔄 Tiền (" .. formatNumber(currentCash) .. ") đã đạt mốc Rebirth! Đang tái sinh...")
            local rebirthRemote = findRemote({"dorebirth", "rebirth", "prestige", "buyrebirth", "claimrebirth"})
            if rebirthRemote then
                if rebirthRemote:IsA("RemoteEvent") then
                    rebirthRemote:FireServer()
                    rebirthRemote:FireServer(1)
                elseif rebirthRemote:IsA("RemoteFunction") then
                    rebirthRemote:InvokeServer()
                end
                TotalRebirths = TotalRebirths + 1
                setStatus("🎉 TÁI SINH THÀNH CÔNG! Đã nhận hệ số nhân tiền mới.")
                return
            end

            -- Dự phòng bấm nút Rebirth trên UI
            local pGui = LocalPlayer:FindFirstChild("PlayerGui")
            if pGui then
                for _, desc in ipairs(pGui:GetDescendants()) do
                    if not isOurGui(desc) and (desc:IsA("TextLabel") or desc:IsA("TextButton")) then
                        local txt = stripAccents(desc.Text or "")
                        if txt == "rebirth" or txt == "tai sinh" or txt:find("^rebirth") then
                            local btn = resolveClickableButton(desc)
                            if btn then
                                clickGuiObject(btn)
                                task.wait(0.3)
                                -- Bấm xác nhận Yes nếu có
                                for _, c in ipairs(pGui:GetDescendants()) do
                                    if not isOurGui(c) and (c:IsA("TextLabel") or c:IsA("TextButton")) then
                                        local cTxt = stripAccents(c.Text or "")
                                        if cTxt == "yes" or cTxt == "co" or cTxt:find("confirm") then
                                            clickGuiObject(resolveClickableButton(c))
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function claimQuestsAndIndex()
    pcall(function()
        -- 1. Quests & Daily Rewards
        if State.AutoClaimQuests then
            local qRemote = findRemote({"claimquest", "claimdaily", "claimreward", "claimfree", "claimallquests", "claim"})
            if qRemote then
                if qRemote:IsA("RemoteEvent") then
                    qRemote:FireServer("All")
                    qRemote:FireServer(1)
                    qRemote:FireServer()
                elseif qRemote:IsA("RemoteFunction") then
                    qRemote:InvokeServer("All")
                end
            end
        end

        -- 2. Index Book Gems
        if State.AutoClaimIndex then
            local indexRemote = findRemote({"claimindex", "claimallindex", "indexreward", "carindex", "collectionreward"})
            if indexRemote then
                if indexRemote:IsA("RemoteEvent") then
                    indexRemote:FireServer()
                    indexRemote:FireServer("All")
                elseif indexRemote:IsA("RemoteFunction") then
                    indexRemote:InvokeServer()
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- 🚿 MODULE 4: AUTO CAR WASH (RỬA XE ASMR TỰ ĐỘNG)
-- ═══════════════════════════════════════════════════════════

local function executeWashCar()
    pcall(function()
        -- 1. Bắn Remote rửa xe
        local washRemote = findRemote({"washcar", "cleancar", "wash", "clean", "cleanvehicle"})
        if washRemote then
            if washRemote:IsA("RemoteEvent") then
                washRemote:FireServer()
                washRemote:FireServer(true)
            elseif washRemote:IsA("RemoteFunction") then
                washRemote:InvokeServer()
            end
            setStatus("🚿 Đã xịt rửa xe bóng loáng (ASMR Car Wash)!")
            return
        end

        -- 2. Tương tác ProximityPrompt tại trạm rửa xe
        local base = getPlayerBase()
        local searchRoots = {base, Workspace:FindFirstChild("CarWash"), Workspace:FindFirstChild("Wash"), Workspace}
        for _, root in ipairs(searchRoots) do
            if root then
                for _, prompt in ipairs(root:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        local act = stripAccents(prompt.ActionText or ""):lower()
                        local obj = stripAccents(prompt.ObjectText or ""):lower()
                        if act:find("wash") or act:find("clean") or act:find("rua") or obj:find("wash") or obj:find("rua") then
                            triggerPrompt(prompt)
                            setStatus("🚿 Đang rửa xe tại trạm Car Wash...")
                            break
                        end
                    end
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════
-- 🎁 MODULE 5: AUTO REDEEM CODES (NHẬP TẤT CẢ CODE)
-- ═══════════════════════════════════════════════════════════

local ACTIVE_CODES = {
    "100XHATCH",        -- 100x Hatch Speed trong 1 Giờ (Mới nhất)
    "RELEASE",          -- 1x Everything Potion
    "LARP",             -- 3x Crate Roll Luck Potions
    "DISCORDWELCOME"    -- 100 Gems
}

local function redeemAllPromoCodes()
    setStatus("🎁 Đang tự động nhập toàn bộ giftcode mới nhất...")
    local codeRemote = findRemote({"redeemcode", "claimcode", "entercode", "promo", "code"})

    for _, code in ipairs(ACTIVE_CODES) do
        pcall(function()
            if codeRemote then
                if codeRemote:IsA("RemoteEvent") then
                    codeRemote:FireServer(code)
                elseif codeRemote:IsA("RemoteFunction") then
                    codeRemote:InvokeServer(code)
                end
            else
                -- Fallback nhập code qua giao diện Textbox
                local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                if pGui then
                    for _, desc in ipairs(pGui:GetDescendants()) do
                        if desc:IsA("TextBox") and not isOurGui(desc) then
                            local ph = (desc.PlaceholderText or ""):lower()
                            local n = desc.Name:lower()
                            if ph:find("code") or n:find("code") then
                                desc.Text = code
                                task.wait(0.1)
                                -- Tìm nút Submit cạnh Textbox
                                local p = desc.Parent
                                if p then
                                    for _, sib in ipairs(p:GetChildren()) do
                                        if sib:IsA("GuiButton") and sib ~= desc then
                                            clickGuiObject(sib)
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.3)
    end
    setStatus("✅ Đã hoàn tất nhập 4 mã code quà tặng!")
end

-- ═══════════════════════════════════════════════════════════
-- ⚡ MODULE 6: UTILITIES & PERFORMANCE (ANTI-AFK & FPS BOOSTER)
-- ═══════════════════════════════════════════════════════════

-- 1. Anti-AFK 24/7 Engine
pcall(function()
    LocalPlayer.Idled:Connect(function()
        if State.AntiAFK then
            VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        end
    end)
end)

-- 2. FPS Booster (Siêu Mượt 60 FPS)
local function toggleFPSBooster(enable)
    pcall(function()
        Lighting.GlobalShadows = not enable
        Lighting.FogEnd = enable and 9e9 or 1000
        settings().Rendering.QualityLevel = enable and 1 or 7

        for _, desc in ipairs(Workspace:GetDescendants()) do
            if desc:IsA("BasePart") and not desc:FindFirstAncestorOfClass("Player") then
                if enable then
                    desc.Material = Enum.Material.SmoothPlastic
                    desc.CastShadow = false
                end
            elseif desc:IsA("Decal") or desc:IsA("Texture") then
                if enable then desc.Transparency = 0.5 end
            elseif desc:IsA("ParticleEmitter") or desc:IsA("Trail") or desc:IsA("Smoke") or desc:IsA("Fire") then
                desc.Enabled = not enable
            end
        end
    end)
    setStatus(enable and "⚡ Đã bật Chế Độ Siêu Mượt 60 FPS!" or "Đã khôi phục đồ họa mặc định.")
end

-- 3. WalkSpeed Controller
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and State.EnableCustomSpeed then
                hum.WalkSpeed = State.CustomSpeed
            end
        end)
    end
end)

-- ═══════════════════════════════════════════════════════════
-- ⚙️ BACKGROUND LOOPS (ĐIỀU HÀNH CHÍNH)
-- ═══════════════════════════════════════════════════════════

-- Loop 1: Auto Crate Open Loop
task.spawn(function()
    while true do
        task.wait(0.1)
        if State.AutoOpenCrates then
            openSelectedCrate()
        end
    end
end)

-- Loop 2: Auto Collect Cash Loop (Mỗi 0.8s)
task.spawn(function()
    while true do
        task.wait(0.8)
        if State.AutoCollectCash then
            collectShowroomCash()
        end
    end
end)

-- Loop 3: Auto Equip Best & Upgrade Garage (Mỗi 4s)
task.spawn(function()
    while true do
        task.wait(4.0)
        if State.AutoEquipBest then
            executeEquipBestCars()
        end
        if State.AutoUpgradeGarage then
            executeUpgradeGarage()
        end
    end
end)

-- Loop 4: Auto Rebirth & Claims (Mỗi 2s)
task.spawn(function()
    while true do
        task.wait(2.0)
        if State.AutoRebirth then
            checkAndRebirth()
        end
        if State.AutoClaimQuests or State.AutoClaimIndex then
            claimQuestsAndIndex()
        end
        if State.AutoWashCar then
            executeWashCar()
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- 🎨 GIAO DIỆN ĐIỀU KHIỂN CHUYÊN NGHIỆP (PREMIUM CAR HUB UI)
-- ═══════════════════════════════════════════════════════════

ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DreamCarCollectionHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = getGuiContainer()
end)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 480)
MainFrame.Position = UDim2.new(0.04, 0, 0.18, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 229, 255)
MainStroke.Thickness = 1.8
MainStroke.Parent = MainFrame

-- Draggable Window
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 42)
Topbar.BackgroundColor3 = Color3.fromRGB(22, 32, 44)
Topbar.BorderSizePixel = 0
Topbar.Parent = MainFrame

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 12)
TopbarCorner.Parent = Topbar

local TopbarBottomFill = Instance.new("Frame")
TopbarBottomFill.Size = UDim2.new(1, 0, 0, 10)
TopbarBottomFill.Position = UDim2.new(0, 0, 1, -10)
TopbarBottomFill.BackgroundColor3 = Color3.fromRGB(22, 32, 44)
TopbarBottomFill.BorderSizePixel = 0
TopbarBottomFill.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🏎️ DREAM CAR COLLECTION V1.0"
Title.TextColor3 = Color3.fromRGB(0, 229, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -64, 0, 7)
MinBtn.BackgroundColor3 = Color3.fromRGB(35, 48, 68)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 14
MinBtn.Parent = Topbar
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 40, 60)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 13
CloseBtn.Parent = Topbar
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = CloseBtn

-- Live Status & Stats Banner
local StatusBanner = Instance.new("Frame")
StatusBanner.Size = UDim2.new(1, -20, 0, 32)
StatusBanner.Position = UDim2.new(0, 10, 0, 48)
StatusBanner.BackgroundColor3 = Color3.fromRGB(18, 26, 38)
StatusBanner.BorderSizePixel = 0
StatusBanner.Parent = MainFrame
local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 8)
sbCorner.Parent = StatusBanner

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -12, 1, 0)
StatusLabel.Position = UDim2.new(0, 6, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🟢 Trạng thái: Sẵn sàng hoạt động"
StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
StatusLabel.Font = Enum.Font.SourceSansSemibold
StatusLabel.TextSize = 11
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusBanner

updateStatusUI = function(msg)
    StatusLabel.Text = msg
end

local StatsBanner = Instance.new("Frame")
StatsBanner.Size = UDim2.new(1, -20, 0, 26)
StatsBanner.Position = UDim2.new(0, 10, 0, 84)
StatsBanner.BackgroundColor3 = Color3.fromRGB(12, 18, 26)
StatsBanner.BorderSizePixel = 0
StatsBanner.Parent = MainFrame
local stbCorner = Instance.new("UICorner")
stbCorner.CornerRadius = UDim.new(0, 6)
stbCorner.Parent = StatsBanner

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -12, 1, 0)
StatsLabel.Position = UDim2.new(0, 6, 0, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "💰 Tiền: $0 | 📦 Đã mở: 0 | 🔄 Rebirth: 0"
StatsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
StatsLabel.Font = Enum.Font.SourceSansBold
StatsLabel.TextSize = 11
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = StatsBanner

updateStatsUI = function()
    local cash, _, rebirths = getPlayerStats()
    StatsLabel.Text = "💰 Tiền: $" .. formatNumber(cash) .. " | 📦 Đã mở: " .. tostring(TotalHatched) .. " | 🔄 Rebirth: " .. tostring(rebirths)
end

task.spawn(function()
    while true do
        task.wait(1.5)
        pcall(updateStatsUI)
    end
end)

-- Content Scroll Area
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -120)
Scroll.Position = UDim2.new(0, 10, 0, 116)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 820)
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 7)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Parent = Scroll

-- ── UI Component Generator Helpers ──
local function createSectionHeader(title, color)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, -4, 0, 26)
    h.BackgroundColor3 = Color3.fromRGB(20, 30, 44)
    h.BorderSizePixel = 0
    h.Parent = Scroll

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = h

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -12, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = title
    l.TextColor3 = color or Color3.fromRGB(0, 229, 255)
    l.Font = Enum.Font.SourceSansBold
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = h
    return h
end

local function createToggle(title, defaultVal, callback, activeColor)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 36)
    row.BackgroundColor3 = Color3.fromRGB(18, 24, 34)
    row.BorderSizePixel = 0
    row.Parent = Scroll

    local rCorner = Instance.new("UICorner")
    rCorner.CornerRadius = UDim.new(0, 6)
    rCorner.Parent = row

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -85, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 68, 0, 24)
    btn.Position = UDim2.new(1, -74, 0.5, -12)
    btn.BackgroundColor3 = defaultVal and (activeColor or Color3.fromRGB(0, 200, 120)) or Color3.fromRGB(45, 55, 70)
    btn.Text = defaultVal and "BẬT" or "TẮT"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.Parent = row

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local state = defaultVal
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and (activeColor or Color3.fromRGB(0, 200, 120)) or Color3.fromRGB(45, 55, 70)
        btn.Text = state and "BẬT" or "TẮT"
        pcall(callback, state)
    end)
    return row
end

local function createActionButton(title, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 34)
    btn.BackgroundColor3 = color or Color3.fromRGB(0, 140, 255)
    btn.Text = title
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = Scroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    return btn
end

-- ═══════════════════════════════════════════════════════════
-- ── SECTION 1: AUTO CRATE / HATCH (MỞ RƯƠNG XE) ──
-- ═══════════════════════════════════════════════════════════

createSectionHeader("📦 MỞ RƯƠNG XE (AUTO CRATE / HATCH)", Color3.fromRGB(0, 229, 255))

createToggle("📦 Bật Tự Động Mở Rương", State.AutoOpenCrates, function(val)
    State.AutoOpenCrates = val
    setStatus(val and "📦 Đã BẬT Auto Mở Rương (" .. CratePresets[State.SelectedCrateIndex].Name .. ")!" or "⏸️ Đã TẮT Auto Mở Rương.")
end, Color3.fromRGB(0, 200, 120))

local btnCrateType = Instance.new("TextButton")
btnCrateType.Size = UDim2.new(1, -4, 0, 32)
btnCrateType.BackgroundColor3 = Color3.fromRGB(24, 36, 52)
btnCrateType.Text = "🎯 Loại Rương: [ " .. CratePresets[State.SelectedCrateIndex].Name .. " ]"
btnCrateType.TextColor3 = Color3.fromRGB(255, 215, 0)
btnCrateType.Font = Enum.Font.SourceSansBold
btnCrateType.TextSize = 12
btnCrateType.Parent = Scroll
local ctCorner = Instance.new("UICorner")
ctCorner.CornerRadius = UDim.new(0, 6)
ctCorner.Parent = btnCrateType

btnCrateType.MouseButton1Click:Connect(function()
    State.SelectedCrateIndex = (State.SelectedCrateIndex % #CratePresets) + 1
    local c = CratePresets[State.SelectedCrateIndex]
    btnCrateType.Text = "🎯 Loại Rương: [ " .. c.Name .. " ]"
    setStatus("🎯 Đã chuyển sang mở rương: " .. c.Name)
end)

createToggle("⚡ Bỏ Qua Hoạt Ảnh Mở Hộp (Fast Hatch)", State.SkipHatchAnimation, function(val)
    State.SkipHatchAnimation = val
end)

createToggle("🗑️ Auto Bán / Xóa Xe Rác (Common/Rare)", State.AutoDeleteCars, function(val)
    State.AutoDeleteCars = val
    setStatus(val and "🗑️ Đã BẬT Auto Bán/Xóa xe rác cấp thấp!" or "Đã TẮT xóa xe.")
end, Color3.fromRGB(255, 140, 0))

-- ═══════════════════════════════════════════════════════════
-- ── SECTION 2: GARAGE & THU TIỀN (AUTO ECONOMY) ──
-- ═══════════════════════════════════════════════════════════

createSectionHeader("🏎️ GARAGE & THU TIỀN THỤ ĐỘNG", Color3.fromRGB(57, 255, 20))

createToggle("💰 Tự Động Hút Tiền Showroom (Auto Collect)", State.AutoCollectCash, function(val)
    State.AutoCollectCash = val
    setStatus(val and "💰 Đã BẬT Tự Động Hút Tiền Showroom!" or "Đã TẮT hút tiền.")
end, Color3.fromRGB(57, 255, 20))

createToggle("⚡ Tự Động Đặt Xe Xịn Nhất (Auto Equip Best)", State.AutoEquipBest, function(val)
    State.AutoEquipBest = val
    if val then executeEquipBestCars() end
end, Color3.fromRGB(0, 229, 255))

createActionButton("🏎️ ĐẶT XE XỊN NHẤT NGAY (EQUIP BEST NOW)", Color3.fromRGB(20, 120, 220), function()
    executeEquipBestCars()
end)

createToggle("🏗️ Tự Động Nâng Cấp Garage / Base", State.AutoUpgradeGarage, function(val)
    State.AutoUpgradeGarage = val
    setStatus(val and "🏗️ Đã BẬT Tự Động Nâng Cấp Garage!" or "Đã TẮT nâng cấp.")
end)

-- ═══════════════════════════════════════════════════════════
-- ── SECTION 3: TÁI SINH & NHẬN THƯỞNG (REBIRTH & CLAIMS) ──
-- ═══════════════════════════════════════════════════════════

createSectionHeader("🔄 TÁI SINH & NHẬN THƯỞNG", Color3.fromRGB(255, 170, 0))

createToggle("🔄 Tự Động Tái Sinh (Auto Rebirth)", State.AutoRebirth, function(val)
    State.AutoRebirth = val
    setStatus(val and "🔄 Đã BẬT Auto Rebirth khi đạt mốc tiền!" or "Đã TẮT Auto Rebirth.")
end, Color3.fromRGB(255, 170, 0))

local btnRebirthThreshold = Instance.new("TextButton")
btnRebirthThreshold.Size = UDim2.new(1, -4, 0, 32)
btnRebirthThreshold.BackgroundColor3 = Color3.fromRGB(34, 30, 48)
btnRebirthThreshold.Text = "🎯 Mốc Rebirth: [ " .. RebirthThresholds[State.RebirthThresholdIndex].Name .. " ]"
btnRebirthThreshold.TextColor3 = Color3.fromRGB(255, 200, 50)
btnRebirthThreshold.Font = Enum.Font.SourceSansBold
btnRebirthThreshold.TextSize = 12
btnRebirthThreshold.Parent = Scroll
local rtCorner = Instance.new("UICorner")
rtCorner.CornerRadius = UDim.new(0, 6)
rtCorner.Parent = btnRebirthThreshold

btnRebirthThreshold.MouseButton1Click:Connect(function()
    State.RebirthThresholdIndex = (State.RebirthThresholdIndex % #RebirthThresholds) + 1
    local t = RebirthThresholds[State.RebirthThresholdIndex]
    btnRebirthThreshold.Text = "🎯 Mốc Rebirth: [ " .. t.Name .. " ]"
    setStatus("🎯 Đã đặt mốc Rebirth: " .. t.Name)
end)

createActionButton("🔄 TÁI SINH NGAY BÂY GIỜ (REBIRTH NOW)", Color3.fromRGB(180, 80, 20), function()
    local rebirthRemote = findRemote({"dorebirth", "rebirth", "prestige", "buyrebirth", "claimrebirth"})
    if rebirthRemote then
        if rebirthRemote:IsA("RemoteEvent") then rebirthRemote:FireServer()
        elseif rebirthRemote:IsA("RemoteFunction") then rebirthRemote:InvokeServer() end
        setStatus("🔄 Đã gửi yêu cầu Tái Sinh ngay lập tức!")
    else
        setStatus("⚠️ Đang kiểm tra điều kiện Rebirth trên giao diện...")
    end
end)

createToggle("🎁 Tự Động Nhận Quà Nhiệm Vụ & Hằng Ngày", State.AutoClaimQuests, function(val)
    State.AutoClaimQuests = val
end)

createToggle("📖 Tự Động Nhận Thưởng Mục Lục Xe (Index)", State.AutoClaimIndex, function(val)
    State.AutoClaimIndex = val
end)

-- ═══════════════════════════════════════════════════════════
-- ── SECTION 4: RỬA XE & HOẠT ĐỘNG (CAR WASH) ──
-- ═══════════════════════════════════════════════════════════

createSectionHeader("🚿 RỬA XE & HOẠT ĐỘNG (CAR WASH)", Color3.fromRGB(0, 200, 255))

createToggle("🚿 Tự Động Rửa Xe ASMR (Auto Wash Car)", State.AutoWashCar, function(val)
    State.AutoWashCar = val
    setStatus(val and "🚿 Đã BẬT Tự Động Rửa Xe tại trạm Car Wash!" or "Đã TẮT tự rửa xe.")
end, Color3.fromRGB(0, 200, 255))

createActionButton("🚿 RỬA XE NGAY LẬP TỨC (WASH CAR NOW)", Color3.fromRGB(0, 140, 180), function()
    executeWashCar()
end)

-- ═══════════════════════════════════════════════════════════
-- ── SECTION 5: MÃ GIFTCODE QUÀ TẶNG (REDEEM CODES) ──
-- ═══════════════════════════════════════════════════════════

createSectionHeader("🎁 NHẬP GIFTCODE TỰ ĐỘNG", Color3.fromRGB(255, 60, 120))

createActionButton("🎁 NHẬP TẤT CẢ CODE MỚI NHẤT (REDEEM ALL)", Color3.fromRGB(200, 30, 80), function()
    redeemAllPromoCodes()
end)

-- ═══════════════════════════════════════════════════════════
-- ── SECTION 6: TIỆN ÍCH & TỐI ƯU TREO MÁY (UTILITIES) ──
-- ═══════════════════════════════════════════════════════════

createSectionHeader("⚡ TIỆN ÍCH & TREO MÁY 24/7", Color3.fromRGB(0, 255, 180))

createToggle("🛡️ Chống Disconnect 24/7 (Anti-AFK)", State.AntiAFK, function(val)
    State.AntiAFK = val
    setStatus(val and "🛡️ Đã BẬT Chống Disconnect 24/7!" or "Đã TẮT Anti-AFK.")
end, Color3.fromRGB(0, 255, 180))

createToggle("⚡ Chế Độ Siêu Mượt 60 FPS (FPS Booster)", State.FPSBooster, function(val)
    State.FPSBooster = val
    toggleFPSBooster(val)
end, Color3.fromRGB(0, 255, 180))

local speedPresets = {16, 28, 45, 70}
local currentSpeedIdx = 1
local btnSpeed = Instance.new("TextButton")
btnSpeed.Size = UDim2.new(1, -4, 0, 32)
btnSpeed.BackgroundColor3 = Color3.fromRGB(24, 36, 52)
btnSpeed.Text = "🏃 Tốc Độ Chạy: [ " .. tostring(speedPresets[currentSpeedIdx]) .. " (Mặc định) ]"
btnSpeed.TextColor3 = Color3.fromRGB(0, 229, 255)
btnSpeed.Font = Enum.Font.SourceSansBold
btnSpeed.TextSize = 12
btnSpeed.Parent = Scroll
local spCorner = Instance.new("UICorner")
spCorner.CornerRadius = UDim.new(0, 6)
spCorner.Parent = btnSpeed

btnSpeed.MouseButton1Click:Connect(function()
    currentSpeedIdx = (currentSpeedIdx % #speedPresets) + 1
    State.CustomSpeed = speedPresets[currentSpeedIdx]
    State.EnableCustomSpeed = (State.CustomSpeed > 16)
    btnSpeed.Text = "🏃 Tốc Độ Chạy: [ " .. tostring(State.CustomSpeed) .. (State.CustomSpeed == 16 and " (Mặc định)" or " (Tăng tốc)") .. " ]"
    setStatus("🏃 Đã đặt tốc độ chạy: " .. tostring(State.CustomSpeed))
end)

-- ── Nút Thu Gọn & Đóng Giao Diện ──
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    Scroll.Visible = not isMinimized
    StatusBanner.Visible = not isMinimized
    StatsBanner.Visible = not isMinimized
    MainFrame.Size = isMinimized and UDim2.new(0, 360, 0, 42) or UDim2.new(0, 360, 0, 480)
    MinBtn.Text = isMinimized and "+" or "—"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tự động nhập code khi vừa nạp script
task.spawn(function()
    task.wait(1.5)
    redeemAllPromoCodes()
end)

setStatus("🚀 Đã nạp thành công Dream Car Collection Hub V1.0!")
