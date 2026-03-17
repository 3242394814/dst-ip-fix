GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})

local server_modid = "workshop-3487026153" -- 服务器模组ID
local DEBUG_print = GetModConfigData("DEBUG_print") and print or function(...) end
-- local UpdateText = rawget(_G, "UpdateText") or function(...) end

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

-- 读取上次记录的模组配置
-- DEBUG_print("[强制纠正IP端口] 正在读取上次记录的配置")
for k,v in pairs(RW_Data:LoadData()) do
    -- if k ~= "" and v ~= "" then DEBUG_print(k,"=",v) end
    env[k] = v
end

-- 将字符串安全转换为数字
local function tonumber_or_nil(x)
    local n = tonumber(x)
    return n
end

local function fix_ip(ip)
    if type(ip) ~= "string" then
        return ip
    end

    -- 如果不是纯 IPv4（数字和点），说明是域名，直接返回
    if not string.find(ip, "^%d+%.%d+%.%d+%.%d+$") then
        return ip
    end

    if original_ip_1 == "0.0.0.0" then
        return fix_ip_1
    elseif ip == original_ip_1 then
        return fix_ip_1
    elseif ip == original_ip_2 then
        return fix_ip_2
    elseif ip == original_ip_3 then
        return fix_ip_3
    end
    return ip
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
思路

服务器开了纠正模组：
玩家连接服务器 -> 不纠正IP端口 -> 连接上了服务器 -> 接收到模组设置 -> 立刻检查服务器下发的设置 -> 需要纠正就纠正IP端口后重新连接 -> 进服开玩
玩家连接服务器 -> 不纠正IP端口 -> 连接上了服务器 -> 穿越到从世界 -> 使用新的IP端口 -> 连接上了从世界服务器 -> 接收到模组设置 -> 立刻检查服务器下发的设置 -> 需要纠正就纠正IP端口后重新连接 -> 进服开玩

服务器没开纠正模组：
玩家连接服务器 -> 不纠正IP端口 -> 连接上了服务器 -> 接收到模组设置 -> 服务器没开纠正模组 -> 进服开玩

从大厅搜索服务器进：
检查服务器的IP是否等于config.last_server_ip，等于就纠正后进
]]

local current_original_ip, current_original_port -- 当前服务器原始IP端口
local current_target_ip, current_target_port, current_target_password -- 当前连接的房间IP、端口、密码(连接从世界时分配的是随机密码，会影响重连，所以用不上，缺点是可能需要玩家手动再输入一遍密码)
local need_reconnect = false -- 是否需要纠正（重新连接服务器）
local old_SetTempModConfigData = KnownModIndex.SetTempModConfigData
KnownModIndex.SetTempModConfigData = function(self, temp_mods_config_data, ...) -- 进服/穿越世界时服务器会下发模组设置给客户端
    old_SetTempModConfigData(self, temp_mods_config_data, ...)

    if current_target_ip and not IsPrivateIP(current_target_ip) then
        for modname, config_data in pairs(temp_mods_config_data) do
            if modname == server_modid then
                config_data.have_server_mod = true
                config_data.last_server_ip = current_original_ip
                RW_Data:SaveData(config_data)

                -- 检查服务器下发的数据和上次记录的数据是否一致
                for k,v in pairs(config_data) do
                    if k ~= "have_server_mod" and k ~= "last_server_ip" and k ~= "" and env[k] ~= v then
                        DEBUG_print("[强制纠正IP端口] 检测到服务器下发的纠正数据与我们上次记录的不同", k, "：上次记录的 = ", env[k], "服务器下发的 = ", v)
                        env[k] = v -- 下面跑纠正函数会用到
                    end
                end

                -- 跑一遍纠正函数 看看是否需要纠正。如果IP是域名 说明已经纠正过了
                if (string.find(current_target_ip, "^%d+%.%d+%.%d+%.%d+$") and current_target_ip ~= fix_ip(current_target_ip)) or current_target_port ~= fix_port(current_target_port) then
                    DEBUG_print("[强制纠正IP端口] 检测到当前需要纠正IP端口")
                    if current_target_ip ~= fix_ip(current_target_ip) then
                        DEBUG_print("当前IP", current_target_ip, "需要纠正为", fix_ip(current_target_ip))
                    end
                    if current_target_port ~= fix_port(current_target_port) then
                        DEBUG_print("当前端口", current_target_port, "需要纠正为", fix_port(current_target_port))
                    end
                    need_reconnect = true
                end

                break
            end
        end
    end

    if need_reconnect then
        need_reconnect = false
        DEBUG_print("[强制纠正IP端口] 强制重连服务器以进行纠正")
        TheNet:Disconnect(false) -- 断开连接服务器，有风险，可能会崩溃
        if TheFrontEnd:GetActiveScreen().name == "ConnectingToGamePopup" then TheFrontEnd:PopScreen() end -- 关闭旧的"连接中"窗口
        c_connect(current_target_ip, master_port) -- 重新连接服务器(使用服务器设置的主世界端口重连 否则连不上)
    else
        DEBUG_print("[强制纠正IP端口] 本次连接不需要强制断开重连以纠正IP端口")
    end

    -- 如果服务器IP相同但关了纠正IP端口模组，则删除last_server_ip
    local config = RW_Data:LoadData()
    if not config.have_server_mod and config.last_server_ip == current_original_ip then
        DEBUG_print("[强制纠正IP端口] 检测到服务器关闭了【强制纠正IP端口(服务端)】，删除last_server_ip记录")
        config.last_server_ip = nil
        RW_Data:SaveData(config)
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function fix_ip_port(ip, port)
    local fixed_ip, fixed_port, fixed -- 是否纠正过
    local config = RW_Data:LoadData()
    if config.have_server_mod or config.last_server_ip == ip then -- 如果服务器开启了纠正模组，或服务器IP和上次记录的IP一致(防止连都连不上, 无法判断是否开模组)，就使用纠正
        DEBUG_print("[强制纠正IP端口] 原始IP", ip, "原始端口", port)

        if not IsPrivateIP(ip) then -- 连接内网IP时不纠正
            fixed_ip = fix_ip(ip)
            fixed_port = fix_port(port)
        end

        DEBUG_print("[强制纠正IP端口] 纠正后的IP", ip, "纠正后的端口", port)
        fixed = ip ~= fixed_ip or port ~= fixed_port
    else
        DEBUG_print("[强制纠正IP端口] 当前进入的服务器不需要纠正IP端口\n上个需要纠正IP端口的服务器IP：" .. tostring(config.last_server_ip) , "本次连接的服务器IP：", tostring(ip))
    end

    current_target_ip = fixed_ip or ip
    current_target_port = fixed_port or port
    return current_target_ip, current_target_port, fixed
end

-- local NeedHookTheNetJoinServerResponse = false
if GLOBAL.NetworkProxy then
    local oldStartClient = GLOBAL.NetworkProxy.StartClient
    GLOBAL.NetworkProxy.StartClient = function(self, ip, port, id, password, netid, ...)
        current_original_ip = ip

        if not port or port == "" then port = 10999 end
        local fixed_ip, fixed_port, fixed = fix_ip_port(ip, port)

        if fixed and netid then
            DEBUG_print("[强制纠正IP端口] 将netid", netid, "删除！")
            netid = nil
        end

        return oldStartClient(self, fixed_ip, fixed_port, id, password, netid, ...)
    end

    -- 从大厅进最终会使用到这个方法，所以HOOK这个方法
    -- local oldJoinServerResponse = NetworkProxy.JoinServerResponse
    -- NetworkProxy.JoinServerResponse = function(self, ...)
    --     if NeedHookTheNetJoinServerResponse then
    --         DEBUG_print("[强制纠正IP端口] 当前需要纠正IP端口！")
    --         c_connect(current_original_ip, current_original_port) -- 现在压力给到NetworkProxy.StartClient
    --         NeedHookTheNetJoinServerResponse = false
    --         return
    --     end
    --     return oldJoinServerResponse(self, ...)
    -- end
end

AddClassPostConstruct("screens/redux/serverlistingscreen", function(self)
    local old_Join = self.Join
    self.Join = function(warnedOffline, warnedLanguage, warnedPaused, ...)
        local selected_index_actual = self.selected_index_actual -- 当前选中的服务器索引
        local sever_info = TheNet:GetServerListingFromActualIndex(selected_index_actual)
        current_target_ip = sever_info and sever_info.ip -- 给KnownModIndex.SetTempModConfigData部分使用
        current_original_ip = current_target_ip
        -- current_original_port = sever_info and sever_info.port
        -- if current_original_ip and current_original_port then
        --     DEBUG_print("[强制纠正IP端口] 当前从服务器列表进入的服务器IP端口为", current_original_ip, current_original_port)

        --     local config = RW_Data:LoadData()
        --     if config.last_server_ip == current_original_ip then
        --         NeedHookTheNetJoinServerResponse = true
        --     end
        -- end

        return old_Join(self, warnedOffline, warnedLanguage, warnedPaused, ...)
    end
end)

-- 回到主菜单时重置have_server_mod
AddClassPostConstruct("screens/redux/mainscreen", function()
    if InGamePlay() then return end
    local config = RW_Data:LoadData()
    config.have_server_mod = false
    RW_Data:SaveData(config)
end)

rawset(GLOBAL, "c_reset_ip_port_fix_conf", function()
    RW_Data:SaveData({})
    if rawget(GLOBAL, "UpdateText") then
        GLOBAL.UpdateText("[强制纠正IP端口] 已重置缓存数据")
    else
        print("[强制纠正IP端口] 已重置缓存数据")
    end
end)