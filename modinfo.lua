---@diagnostic disable: lowercase-global
name = "强制纠正IP端口(客户端)"
version = "0.1"
description = [[
本模组需配合 强制纠正IP端口(服务端) 使用
在进入了开启 强制纠正IP端口(服务端) 的房间时会自动订阅&开启此模组

本模组分为客户端部分和服务器部分
此为客户端部分，用于接收并应用服务器下发的IP端口
服务器部分用于下发纠正后的IP端口
]]
author = "冰冰羊"
api_version = 10
priority = 99999

dst_compatible = true
forge_compatible = true
gorge_compatible = true
all_clients_require_mod = false
client_only_mod = true
server_only_mod = false

local function SkipSpace()
	return { name = "",label = "", hover = "", options = { { description = "", data = false }, }, default = false}
end

configuration_options =
{
    {
        name = "DEBUG_print",
        label = "打印纠正日志",
        hover = "在客户端日志中打印纠正前后的IP和端口",
        options =   {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true
    },
}