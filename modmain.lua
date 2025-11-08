GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})

----------------------------------------------------------------读写文件--------------------------------------------------------------------------------------------------------------------------------

RW_Data = {}
local DATA_FILE = 'mod_config_data/ip-fix-setting.json'

function RW_Data:SaveData(data)
	local str = json.encode(data)
	SavePersistentString(DATA_FILE, str)
end

function RW_Data:LoadData()
	local data
	TheSim:GetPersistentString(DATA_FILE, function(load_success, str)
		if load_success then
			if string.len(str) > 0 and not string.find(str,"return") then
				data = json.decode(str) or {}
			else
				data = {}
			end
		end
	end)
	return data or {}
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local config_data = {}
local client_modid = "workshop-3600067779" -- 客户端版模组ID

local try_num = 0
local function Auto_Enable_Mod()
    try_num = try_num + 1
    if try_num > 5 then return end
    TheGlobalInstance:DoTaskInTime(10, function() -- 等10秒检查模组是否下载完成
        if KnownModIndex:GetModInfo(client_modid) then -- 下载完成，启用模组
            print("[强制纠正IP端口(服务端)] 正在自动开启模组：强制纠正IP端口(客户端)")
            KnownModIndex:Enable(client_modid)
            KnownModIndex:Save()

            -- 客户端模组需要在下次才会加载，这里提前记录好数据
            for _,v in pairs(modinfo.configuration_options) do
                config_data[v.name] = GetModConfigData(v.name)
            end
            RW_Data:SaveData(config_data)

         -- 未下载完成，再次尝试
            TheSim:SubscribeToMod(client_modid)
            Auto_Enable_Mod()
        end
    end)
end

-- 游戏初始化后检测是否安装/启用客户端模组
AddPrefabPostInit("world",function()
    if TheNet:GetIsClient() then
        if not KnownModIndex:GetModInfo(client_modid) then
            TheSim:SubscribeToMod(client_modid)
            Auto_Enable_Mod()
        elseif not KnownModIndex:IsModEnabledAny(client_modid) then
            Auto_Enable_Mod()
        end
    end
end)