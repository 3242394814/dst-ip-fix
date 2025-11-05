GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})

local server_modid = "workshop-3487026153" -- 服务器模组ID
local DEBUG_print = GetModConfigData("DEBUG_print") and print or function(...) end

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

-- 判断是否为内网IP
local function IsPrivateIP(ip)
    if type(ip) ~= "string" then
        return false
    end

    -- 去掉前后空格
    ip = ip:match("^%s*(.-)%s*$")

    -- 10.x.x.x
    if string.find(ip, "^10%.") then
        return true
    end

    -- 172.16.x.x ~ 172.31.x.x
    if string.find(ip, "^172%.") then
        local _, _, second = string.find(ip, "^172%.(%d+)")
        if second then
            local num = tonumber(second)
            if num and num >= 16 and num <= 31 then
                return true
            end
        end
    end

    -- 192.168.x.x
    if string.find(ip, "^192%.168%.") then
        return true
    end

    -- 127.x.x.x (本地回环)
    if string.find(ip, "^127%.") then
        return true
    end

    if string.find(ip, "localhost") then
        return true
    end

    -- 169.254.x.x (自动私有地址)
    if string.find(ip, "^169%.254%.") then
        return true
    end

    return false
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 以下这些变量会被定义在模组env环境
-- local master_port
-- local original_ip_1, original_ip_2, original_ip_3
-- local fix_ip_1, fix_ip_2, fix_ip_3
-- local original_port_1, original_port_2, original_port_3, original_port_4, original_port_5, original_port_6, original_port_7, original_port_8, original_port_9
-- local fix_port_1, fix_port_2, fix_port_3, fix_port_4, fix_port_5, fix_port_6, fix_port_7, fix_port_8, fix_port_9

-- 将字符串安全转换为数字
local function tonumber_or_nil(x)
    local n = tonumber(x)
    return n
end

local function fix_ip(ip)
    if original_ip_1 == "0.0.0.0" then
        return fix_ip_1
    elseif ip == original_ip_1 then
        return fix_ip_1
    elseif ip == original_ip_2 then
        return fix_ip_2
    elseif ip == original_ip_3 then
        return fix_ip_3
    end
end

-- 将原始端口与配置项比较，并替换为对应的纠正端口
local function fix_port(port)
    if port == tonumber_or_nil(original_port_1) then
        return tonumber_or_nil(fix_port_1)
    elseif port == tonumber_or_nil(original_port_2) then
        return tonumber_or_nil(fix_port_2)
    elseif port == tonumber_or_nil(original_port_3) then
        return tonumber_or_nil(fix_port_3)
    elseif port == tonumber_or_nil(original_port_4) then
        return tonumber_or_nil(fix_port_4)
    elseif port == tonumber_or_nil(original_port_5) then
        return tonumber_or_nil(fix_port_5)
    elseif port == tonumber_or_nil(original_port_6) then
        return tonumber_or_nil(fix_port_6)
    elseif port == tonumber_or_nil(original_port_7) then
        return tonumber_or_nil(fix_port_7)
    elseif port == tonumber_or_nil(original_port_8) then
        return tonumber_or_nil(fix_port_8)
    elseif port == tonumber_or_nil(original_port_9) then
        return tonumber_or_nil(fix_port_9)
    else
        return port
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
思路：
玩家连接服务器 -> 不纠正IP端口 -> 连接上了服务器 -> 立刻检查服务器下发的设置(服务器没有开纠正模组就进服开玩) -> 需要纠正/设置与上次记录的不同就纠正IP端口后重新连接 -> 进服开玩
]]

-- 读取上次记录的模组配置
-- DEBUG_print("[强制纠正IP端口] 正在读取上次记录的配置")
for k,v in pairs(RW_Data:LoadData()) do
    -- if k ~= "" and v ~= "" then DEBUG_print(k,"=",v) end
    env[k] = v
end

local current_target_ip, current_target_port, current_target_password -- 当前连接的房间IP、端口、密码(连接从世界时分配的是随机密码，会影响重连，所以用不上，缺点是可能需要玩家手动再输入一遍密码)
local have_server_mod = false -- 服务器是否开启纠正模组
local need_reconnect = false -- 是否需要纠正（重新连接服务器）
local old_SetTempModConfigData = KnownModIndex.SetTempModConfigData
KnownModIndex.SetTempModConfigData = function(self, temp_mods_config_data, ...) -- 进服/穿越世界时服务器会下发模组设置给客户端
    old_SetTempModConfigData(self, temp_mods_config_data, ...)
    for modname, config_data in pairs(temp_mods_config_data) do
        if modname == server_modid then
            have_server_mod = true
            RW_Data:SaveData(config_data)

            -- 检查服务器下发的数据和上次记录的数据是否一致
            for k,v in pairs(config_data) do
                if k ~= "" and v ~= "" and env[k] ~= v then
                    DEBUG_print("[强制纠正IP端口] 检测到服务器下发的纠正数据与我们上次记录的不同", k, "：上次记录的 = ", env[k], "服务器下发的 = ", v)
                    need_reconnect = true
                    env[k] = v
                end
            end

            -- 跑一遍纠正函数 看看是否需要纠正
            if not IsPrivateIP(current_target_ip) then
                if current_target_ip ~= fix_ip(current_target_ip) or current_target_port ~= fix_port(current_target_port) then
                    need_reconnect = true
                end
            end
        end
    end

    if need_reconnect then
        DEBUG_print("[强制纠正IP端口] 强制重连服务器以进行纠正")
        TheNet:Disconnect(false) -- 断开连接服务器
        if TheFrontEnd:GetActiveScreen().name == "ConnectingToGamePopup" then TheFrontEnd:PopScreen() end -- 关闭"连接中"窗口
        c_connect(current_target_ip, master_port) -- 重新连接服务器(使用服务器设置的主世界端口重连 否则连不上)
    end

    if not need_reconnect then
        DEBUG_print("[强制纠正IP端口] 本次连接不需要强制断开重连以纠正IP端口")
    end

    -- if not have_server_mod then -- 如果服务器没开纠正模组
    --     RW_Data:SaveData({}) -- 清空数据
    -- end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if GLOBAL.NetworkProxy then
    local oldStartClient = GLOBAL.NetworkProxy.StartClient
    GLOBAL.NetworkProxy.StartClient = function(self, ip, port, id, password, netid, ...)
        current_target_ip = ip
        current_target_port = port

        if have_server_mod then
            DEBUG_print("[强制纠正IP端口] 原始IP", ip, "原始端口", port)

            if netid then
                DEBUG_print("[强制纠正IP端口] 将netid", netid, "删除！")
                netid = nil
            end

            if not IsPrivateIP(ip) then -- 连接内网IP时不纠正
                ip = fix_ip(ip)
                port = fix_port(port)
            end

            DEBUG_print("[强制纠正IP端口] 纠正后的IP", ip, "纠正后的端口", port)
        end
        return oldStartClient(self, ip, port, id, password, netid, ...)
    end
end