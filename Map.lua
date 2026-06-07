-- ========== POTATO MODE - FIX LAG BLOX FRUITS ==========
-- Giảm họa toàn map, xóa chi tiết phức tạp, giảm 40% effect skill, tối màu

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Tối màu tổng thể (giảm độ sặc sỡ)
Lighting.Brightness = 0.6          -- Giảm độ sáng
Lighting.Ambient = Color3.new(0.3, 0.3, 0.3)  -- Tối màu
Lighting.OutdoorAmbient = Color3.new(0.3, 0.3, 0.3)
Lighting.ColorShift_Top = Color3.new(0.2, 0.2, 0.2)
Lighting.ColorShift_Bottom = Color3.new(0.1, 0.1, 0.1)
Lighting.ExposureCompensation = 0.5
-- Tắt shadow cho đỡ lag
Lighting.GlobalShadows = false
Lighting.ShadowSoftness = 0

-- 2. Xóa các effect phức tạp trong toàn bộ Workspace (chạy định kỳ)
local function potatoClean(obj)
    if not obj then return end
    -- Xóa particle, light, decal, mesh gây lag
    if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        obj.Enabled = false
        obj:Destroy()
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
    elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
        obj:Destroy()
    elseif obj:IsA("Beam") or obj:IsA("Trail") then
        obj:Destroy()
    elseif obj:IsA("BillboardGui") or obj:IsA("SelectionBox") then
        obj:Destroy()
    elseif obj:IsA("MeshPart") and obj.Material == Enum.Material.Neon then
        obj.Material = Enum.Material.SmoothPlastic
    end
end

-- Quét toàn bộ map hiện tại
for _, obj in pairs(Workspace:GetDescendants()) do
    potatoClean(obj)
end

-- Bắt các đối tượng mới sinh ra (skill effect mới)
Workspace.DescendantAdded:Connect(potatoClean)

-- 3. Giảm 40% hiệu ứng skill (local player)
local function reduceSkillEffects(character)
    if not character then return end
    -- Tìm tất cả effect trong người chơi
    for _, obj in pairs(character:GetDescendants()) do
        if obj:IsA("ParticleEmitter") then
            obj.Rate = math.floor(obj.Rate * 0.6)   -- giảm 40% hạt
            obj.Lifetime = NumberRange.new(0.5, 1)
        elseif obj:IsA("Fire") or obj:IsA("Smoke") then
            obj.Size = obj.Size * 0.6
            obj.Heat = 0
        elseif obj:IsA("Sound") then
            obj.Volume = obj.Volume * 0.5  -- giảm âm thanh gây lag nhẹ
        elseif obj:IsA("Trail") or obj:IsA("Beam") then
            obj:Destroy()
        elseif obj:IsA("Decal") then
            obj:Destroy()
        end
    end
end

-- Áp dụng cho nhân vật hiện tại
local playerChar = LocalPlayer.Character
if playerChar then
    reduceSkillEffects(playerChar)
end

-- Khi nhân vật respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    reduceSkillEffects(char)
end)

-- 4. Vô hiệu hóa các hiệu ứng skill trong không gian map (ví dụ aura, skill boss)
-- Lọc các object có tên chứa "Effect", "Skill", "Ability", "Particle"
for _, obj in pairs(Workspace:GetDescendants()) do
    local name = obj.Name:lower()
    if name:find("effect") or name:find("skill") or name:find("particle") or name:find("aura") then
        if obj:IsA("Model") or obj:IsA("Part") then
            for _, child in pairs(obj:GetChildren()) do
                potatoClean(child)
            end
            obj:Destroy()
        else
            potatoClean(obj)
        end
    end
end

-- Duy trì mỗi 2 giây quét lại để bắt kịp effect mới
task.spawn(function()
    while true do
        task.wait(2)
        -- Quét nhẹ lại một số khu vực
        for _, v in pairs(Workspace:GetChildren()) do
            if v.Name:lower():find("effect") or v.Name:lower():find("skill") then
                v:Destroy()
            end
        end
    end
end)

print("Potato Mode đã kích hoạt - FPS sẽ tăng đáng kể!")
-- ========== KẾT THÚC POTATO MODE ==========
