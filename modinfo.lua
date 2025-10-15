---@diagnostic disable: lowercase-global
name = "强制纠正IP端口"
version = "0.1.1"
description = [[
设置本模组需订阅【便捷配置】或【文本模组配置】！
本模组针对无法设置对等端口的服务器/同时拥有多个公网IP的服务器
举例：你的服务器拥有2个公网IP，第一个是1.1.1.1，第二个是2.2.2.2
你给1.1.1.1设置了端口转发 外网端口20999→本地端口10999 外网端口20998→本地端口10998
但你上网优先使用外网IP 2.2.2.2
这时候你给科雷上报的服务器信息就是： 服务器IP 2.2.2.2 地上世界端口10999 地下世界端口10998
但客户端连接你的服务器需要使用 1.1.1.1 地上世界端口20999 地下世界端口 20998
这时候就需要使用本模组来纠正IP和端口了！
以上面的情况为例，你需要设置
原IP-1 为 2.2.2.2 纠正IP为 1.1.1.1
原端口-1 为 10999 纠正端口-1 为 20999
原端口-2 为 10998 纠正端口-2 为 20998
接着让客户端使用直连代码c_connect("1.1.1.1",20999)进入服务器，进服后本MOD就能为你工作了，
而不是在玩家穿越世界时变为使用你上报给科雷的错误IP和端口，导致掉线或变为P2P连接
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
        name = "DEBUG_print",
        label = "打印纠正日志",
        hover = "在客户端日志中打印纠正前后的IP和端口",
        options =   {
            {description = "开启", data = true},
            {description = "关闭", data = false},
        },
        default = true
    },
    SkipSpace(),
    {
		name = "original_ip_1",
		label = "原IP-1",
		hover = "请填写服务器1的原始IP\n如：157.148.69.186\n如果想匹配任意内容，请填写0.0.0.0 这将导致客户端连接所有世界时都使用 纠正IP-1 同时其它2个IP设置将失效",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_ip_1",
		label = "纠正IP-1",
		hover = "请填写服务器1的纠正IP\n当客户端连接到“原IP-1”的服务器时，会强制纠正IP为纠正IP-1",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
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
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_ip_2",
		label = "纠正IP-2",
		hover = "请填写服务器2的纠正IP\n当客户端连接到“原IP-2”的服务器时，会强制纠正IP为纠正IP-2",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
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
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_ip_3",
		label = "纠正IP-3",
		hover = "请填写服务器3的纠正IP\n当客户端连接到“原IP-3”的服务器时，会强制纠正IP为纠正IP-3",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
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
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_1",
		label = "纠正端口-1",
		hover = "请填写“原端口-1”的纠正端口\n当客户端连接到“原端口-1”的世界时，会强制纠正端口为“纠正端口-1”",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
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
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_2",
		label = "纠正端口-2",
		hover = "请填写“原端口-2”的纠正端口\n当客户端连接到“原端口-2”的世界时，会强制纠正端口为“纠正端口-2”",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
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
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_3",
		label = "纠正端口-3",
		hover = "请填写“原端口-3”的纠正端口\n当客户端连接到“原端口-3”的世界时，会强制纠正端口为“纠正端口-3”",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
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
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_4",
		label = "纠正端口-4",
		hover = "请填写“原端口-4”的纠正端口\n当客户端连接到“原端口-4”的世界时，会强制纠正端口为“纠正端口-4”",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
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
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
        {
		name = "fix_port_5",
		label = "纠正端口-5",
		hover = "请填写“原端口-5”的纠正端口\n当客户端连接到“原端口-5”的世界时，会强制纠正端口为“纠正端口-5”",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
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
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_6",
		label = "纠正端口-6",
		hover = "请填写“原端口-6”的纠正端口\n当客户端连接到“原端口-6”的世界时，会强制纠正端口为“纠正端口-6”",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
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
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_7",
		label = "纠正端口-7",
		hover = "请填写“原端口-7”的纠正端口\n当客户端连接到“原端口-7”的世界时，会强制纠正端口为“纠正端口-7”",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
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
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_8",
		label = "纠正端口-8",
		hover = "请填写“原端口-8”的纠正端口\n当客户端连接到“原端口-8”的世界时，会强制纠正端口为“纠正端口-8”",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
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
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
    {
		name = "fix_port_9",
		label = "纠正端口-9",
		hover = "请填写“原端口-9”的纠正端口\n当客户端连接到“原端口-9”的世界时，会强制纠正端口为“纠正端口-9”",
		options =	{
						{description = "请订阅便携配置Mod后进行设置", data = ""},
					},
		default = "",
        is_text_config = true
	},
}