GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})

local original_ip_1 = GetModConfigData("original_ip_1")
local original_ip_2 = GetModConfigData("original_ip_2")
local original_ip_3 = GetModConfigData("original_ip_3")

local fix_ip_1 = GetModConfigData("fix_ip_1")
local fix_ip_2 = GetModConfigData("fix_ip_2")
local fix_ip_3 = GetModConfigData("fix_ip_3")

local original_port_1 = GetModConfigData("original_port_1")
local original_port_2 = GetModConfigData("original_port_2")
local original_port_3 = GetModConfigData("original_port_3")
local original_port_4 = GetModConfigData("original_port_4")
local original_port_5 = GetModConfigData("original_port_5")
local original_port_6 = GetModConfigData("original_port_6")
local original_port_7 = GetModConfigData("original_port_7")
local original_port_8 = GetModConfigData("original_port_8")
local original_port_9 = GetModConfigData("original_port_9")

local fix_port_1 = GetModConfigData("fix_port_1")
local fix_port_2 = GetModConfigData("fix_port_2")
local fix_port_3 = GetModConfigData("fix_port_3")
local fix_port_4 = GetModConfigData("fix_port_4")
local fix_port_5 = GetModConfigData("fix_port_5")
local fix_port_6 = GetModConfigData("fix_port_6")
local fix_port_7 = GetModConfigData("fix_port_7")
local fix_port_8 = GetModConfigData("fix_port_8")
local fix_port_9 = GetModConfigData("fix_port_9")

local function DEBUG_print(...)
    if GetModConfigData("DEBUG_print") then
        print(...)
    end
end

-- 将字符串安全转换为数字
local function tonumber_or_nil(x)
    local n = tonumber(x)
    return n
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

if GLOBAL.NetworkProxy then
    local oldStartClient = GLOBAL.NetworkProxy.StartClient
    GLOBAL.NetworkProxy.StartClient = function(self, ip, port, id, password, netid, ...)
        DEBUG_print("[强制纠正IP端口] 原始IP", ip, "原始端口", port)

        if netid then
            DEBUG_print("[强制纠正IP端口] 将netid", netid, "删除！")
            netid = nil
        end
        if original_ip_1 == "0.0.0.0" then
            ip = fix_ip_1
        elseif ip == original_ip_1 then
            ip = fix_ip_1
        elseif ip == original_ip_2 then
            ip = fix_ip_2
        elseif ip == original_ip_3 then
            ip = fix_ip_3
        end

        port = fix_port(port)

        DEBUG_print("[强制纠正IP端口] 纠正后的IP", ip, "纠正后的端口", port)
        return oldStartClient(self, ip, port, id, password, netid, ...)
    end
end