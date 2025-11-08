---@diagnostic disable: lowercase-global
name = "强制纠正IP端口(服务端)"
version = "0.2.1.1"
version_compatible = "0.2"
description = [[
设置本模组需订阅【配置扩展】！
本模组分为客户端部分和服务器部分
此为服务器部分，用于下发纠正后的IP端口
客户端部分用于接收并应用服务器下发的IP端口

玩家进入了开启本模组的服务器后会自动订阅并开启客户端部分的模组
]]
author = "冰冰羊"
api_version = 10
priority = 99999

dst_compatible = true
forge_compatible = true
gorge_compatible = true
all_clients_require_mod = true
client_only_mod = false
server_only_mod = false

local function SkipSpace()
	return { name = "",label = "", hover = "", options = { { description = "", data = false }, }, default = false}
end

configuration_options =
{
    {
		name = "master_port",
		label = "主世界服务器端口",
		hover = "请填写主世界端口 server_port 例如：10999。不填的效果等于填10999",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
	SkipSpace(),
    {
		name = "original_ip_1",
		label = "原IP-1",
		hover = "请填写服务器1的原始IP\n如：157.148.69.186\n如果想匹配任意内容，请填写0.0.0.0 这将导致客户端连接所有世界时都使用 纠正IP-1 同时其它2个IP设置将失效",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_ip_1",
		label = "纠正IP-1",
		hover = "请填写服务器1的纠正IP\n当客户端连接到“原IP-1”的服务器时，会强制纠正IP为纠正IP-1",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    SkipSpace(),
    {
		name = "original_ip_2",
		label = "原IP-2",
		hover = "请填写服务器2的原始IP",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_ip_2",
		label = "纠正IP-2",
		hover = "请填写服务器2的纠正IP\n当客户端连接到“原IP-2”的服务器时，会强制纠正IP为纠正IP-2",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    SkipSpace(),
    {
		name = "original_ip_3",
		label = "原IP-3",
		hover = "请填写服务器3的原始IP",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_ip_3",
		label = "纠正IP-3",
		hover = "请填写服务器3的纠正IP\n当客户端连接到“原IP-3”的服务器时，会强制纠正IP为纠正IP-3",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    SkipSpace(),
    {
		name = "original_port_1",
		label = "原端口-1",
		hover = "请填写世界1的原始server_port",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_1",
		label = "纠正端口-1",
		hover = "请填写“原端口-1”的纠正端口\n当客户端连接到“原端口-1”的世界时，会强制纠正端口为“纠正端口-1”",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    SkipSpace(),
    {
		name = "original_port_2",
		label = "原端口-2",
		hover = "请填写世界2的原始server_port",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_2",
		label = "纠正端口-2",
		hover = "请填写“原端口-2”的纠正端口\n当客户端连接到“原端口-2”的世界时，会强制纠正端口为“纠正端口-2”",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    SkipSpace(),
    {
		name = "original_port_3",
		label = "原端口-3",
		hover = "请填写世界3的原始server_port",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_3",
		label = "纠正端口-3",
		hover = "请填写“原端口-3”的纠正端口\n当客户端连接到“原端口-3”的世界时，会强制纠正端口为“纠正端口-3”",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    SkipSpace(),
    {
		name = "original_port_4",
		label = "原端口-4",
		hover = "请填写世界4的原始server_port",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_4",
		label = "纠正端口-4",
		hover = "请填写“原端口-4”的纠正端口\n当客户端连接到“原端口-4”的世界时，会强制纠正端口为“纠正端口-4”",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    SkipSpace(),
    {
		name = "original_port_5",
		label = "原端口-5",
		hover = "请填写世界5的原始server_port",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
        {
		name = "fix_port_5",
		label = "纠正端口-5",
		hover = "请填写“原端口-5”的纠正端口\n当客户端连接到“原端口-5”的世界时，会强制纠正端口为“纠正端口-5”",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    SkipSpace(),
    {
		name = "original_port_6",
		label = "原端口-6",
		hover = "请填写世界6的原始server_port",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_6",
		label = "纠正端口-6",
		hover = "请填写“原端口-6”的纠正端口\n当客户端连接到“原端口-6”的世界时，会强制纠正端口为“纠正端口-6”",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    SkipSpace(),
    {
		name = "original_port_7",
		label = "原端口-7",
		hover = "请填写世界7的原始server_port",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_7",
		label = "纠正端口-7",
		hover = "请填写“原端口-7”的纠正端口\n当客户端连接到“原端口-7”的世界时，会强制纠正端口为“纠正端口-7”",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    SkipSpace(),
    {
		name = "original_port_8",
		label = "原端口-8",
		hover = "请填写世界8的原始server_port",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_8",
		label = "纠正端口-8",
		hover = "请填写“原端口-8”的纠正端口\n当客户端连接到“原端口-8”的世界时，会强制纠正端口为“纠正端口-8”",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    SkipSpace(),
    {
		name = "original_port_9",
		label = "原端口-9",
		hover = "请填写世界9的原始server_port",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_9",
		label = "纠正端口-9",
		hover = "请填写“原端口-9”的纠正端口\n当客户端连接到“原端口-9”的世界时，会强制纠正端口为“纠正端口-9”",
		options =	{
						{description = "请开启配置扩展Mod", data = ""},
					},
		default = "",
        is_text_config = true
	},
}