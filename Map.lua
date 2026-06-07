-- ========== POTATO MODE CỰC MẠNH (XÓA HẾT MỸ THUẬT, GIỮ NGUYÊN GAMEPLAY) ==========
task.spawn(function()
    local Lighting = game:GetService("Lighting")
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    
    -- 1. Ép lighting mỗi frame (tối màu, tắt shadow)
    RunService.RenderStepped:Connect(function()
        Lighting.Brightness = 0.4
        Lighting.Ambient = Color3.new(0.15, 0.15, 0.15)
        Lighting.OutdoorAmbient = Color3.new(0.15, 0.15, 0.15)
        Lighting.GlobalShadows = false
        Lighting.ShadowSoftness = 0
        Lighting.ExposureCompensation = 0.3
        Lighting.ColorShift_Top = Color3.new(0.1, 0.1, 0.1)
        Lighting.ColorShift_Bottom = Color3.new(0.05, 0.05, 0.05)
        Lighting.ClockTime = 0  -- Ép nửa đêm, tối hết cỡ
        Lighting.FogEnd = 50    -- Sương mù gần để che bớt chi tiết xa
        Lighting.FogColor = Color3.new(0.1, 0.1, 0.1)
    end)
    
    -- 2. Xóa tất cả effect, light, particle, decal, beam (chạy liên tục)
    local function killEffects(obj)
        if not obj then return end
        local success, err = pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
                obj:Destroy()
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj:Destroy()
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("Beam") or obj:IsA("Trail") then
                obj:Destroy()
            elseif obj:IsA("BillboardGui") or obj:IsA("SelectionBox") or obj:IsA("SelectionSphere") then
                obj:Destroy()
            elseif obj:IsA("MeshPart") and obj.Material == Enum.Material.Neon then
                obj.Material = Enum.Material.SmoothPlastic
            elseif obj:IsA("Explosion") then
                obj:Destroy()
            elseif obj:IsA("Sound") then
                obj:Destroy()
            end
        end)
    end
    
    -- Quét toàn bộ Workspace hiện tại
    for _, obj in pairs(Workspace:GetDescendants()) do
        killEffects(obj)
    end
    
    -- Bắt object mới sinh ra (skill, boss effect)
    Workspace.DescendantAdded:Connect(killEffects)
    
    -- 3. Xóa detail map (cây cỏ, đá nhỏ, vật dụng trang trí)
    local detailNames = {"Grass", "Bush", "Rock", "Pebble", "Flower", "Tree", "Leaf", "Cloud", "Smoke", "Dust", "Sparkle", "Glow", "Aura", "Effect", "Particle", "VFX"}
    
    local function killDetail(obj)
        for _, name in pairs(detailNames) do
            if obj.Name:find(name) or obj.Name:lower():find(name:lower()) then
                pcall(function() obj:Destroy() end)
                break
            end
        end
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        killDetail(obj)
    end
    Workspace.DescendantAdded:Connect(killDetail)
    
    -- 4. Giảm chất lượng mesh/texture toàn map
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            elseif obj:IsA("Decal") then
                obj:Destroy()
            end
        end)
    end
    
    -- 5. Tắt water reflection và wave (giảm lag mạnh)
    local Terrain = Workspace.Terrain
    if Terrain then
        Terrain.WaterReflectance = 0
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterTransparency = 0
    end
    
    print("Potato Mode cực mạnh đã kích hoạt! Map sẽ xấu hẳn để tăng FPS.")
end)
-- ========== KẾT THÚC ==========
