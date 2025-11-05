GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})


local client_modid = "dst-ip-fix" -- 客户端版模组ID

local function Auto_Enable_Mod()
    TheGlobalInstance:DoTaskInTime(10, function() -- 等10秒检查模组是否下载完成
        if KnownModIndex:GetModInfo(client_modid) then -- 下载完成，启用模组
            KnownModIndex:Enable(client_modid)
            KnownModIndex:Save()
        else -- 未下载完成，再次尝试
            Auto_Enable_Mod()
        end
    end)
end

-- 游戏初始化后检测是否安装/启用客户端模组
AddGamePostInit(function()
    if not KnownModIndex:GetModInfo(client_modid) then
        TheSim:SubscribeToMod(client_modid)
        Auto_Enable_Mod()
    elseif not KnownModIndex:IsModEnabledAny(client_modid) then
        Auto_Enable_Mod()
    end
end)