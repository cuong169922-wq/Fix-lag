-- Xóa visual map (giữ ground, NPC, player, nước, bầu trời)
task.spawn(function()
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- Danh sách tên object trang trí cần xóa
    local visualNames = {
        "Grass", "Bush", "Flower", "Leaf", "Rock", "Pebble", "Stone",
        "Tree", "Log", "Branch", "Cloud", "Smoke", "Dust", "Sparkle",
        "Glow", "Aura", "Effect", "Particle", "VFX", "Decal", "Texture",
        "Billboard", "SelectionBox", "Light", "PointLight", "SpotLight",
        "Beam", "Trail", "Fire", "Sparkles", "Smoke"
    }
    
    -- Kiểm tra part có phải là sàn/ground không
    local function isWalkablePart(part)
        if not part:IsA("BasePart") then return false end
        if part.CanCollide and part.Size.Y > 1 then return true end
        local name = part.Name:lower()
        if name:find("ground") or name:find("floor") or name:find("platform") or name:find("base") then
            return true
        end
        return false
    end
    
    -- Xóa visual
    local function removeVisual(obj)
        pcall(function()
            -- Giữ player
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
                if obj == LocalPlayer.Character then return end
                -- Giữ NPC (có humanoid nhưng không phải local)
                return
            end
            -- Giữ nước (Terrain)
            if obj:IsA("Terrain") then return end
            -- Giữ part có thể đứng (chỉ xóa decal/texture trên đó)
            if obj:IsA("BasePart") and isWalkablePart(obj) then
                for _, child in pairs(obj:GetChildren()) do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        child:Destroy()
                    end
                end
                return
            end
            -- Xóa theo tên
            for _, name in pairs(visualNames) do
                if obj.Name:find(name) or obj.Name:lower():find(name:lower()) then
                    obj:Destroy()
                    break
                end
            end
            -- Xóa các component effect
            if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj:Destroy()
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj:Destroy()
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj:Destroy()
            elseif obj:IsA("Beam") or obj:IsA("Trail") then
                obj:Destroy()
            elseif obj:IsA("BillboardGui") or obj:IsA("SelectionBox") then
                obj:Destroy()
            end
        end)
    end
    
    -- Quét toàn bộ Workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        removeVisual(obj)
    end
    
    -- Bắt object mới sinh ra
    Workspace.DescendantAdded:Connect(removeVisual)
    
    print("Đã xóa visual map (giữ ground, NPC, player, nước, bầu trời)")
end)
