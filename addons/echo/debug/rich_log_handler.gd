class_name RichLogHandler
extends LogHandler
## RichLogHandler
## 使用 print_rich 输出到 godot 编辑器 output 窗口

const data_tag = "RichLogHandler"

## 颜色管理，定义常用颜色，背景色
const FG_BLACK = "black"
const FG_RED = "red"
const FG_GREEN = "green"
const FG_YELLOW = "yellow"
const FG_BLUE = "blue"
const FG_MAGENTA = "magenta"
const FG_CYAN = "cyan"
const FG_WHITE = "white"
const FG_ORANGE = "orange"
const FG_GRAY = "gray"
const FG_PINK = "pink"
const FG_PURPLE = "purple"


# godot 编辑器输出窗口可能存在bug, 换行后的控制码可能被当文字列印
# 一般模板输出单一颜色，客制模板可分别控制
var custom_template := "[color={color_timestamp}]{timestamp} [/color] [color={color_level}]{level} [/color] [color={color_message}]{message}[/color]"
var default_template := "[color={color}]{timestamp} {level} {message}[/color]"

var color_debug ="green"
var color_info = "blue"
var color_warning = "yellow"
var color_error = "red"
var color_known = "cyan"

# LogColor 颜色对应表
static var color_map : Dictionary = {}

# 快速建立颜色
static func make_color(t:LogColor, l:LogColor, m:LogColor) -> LogHandlerData:
	var data = LogHandlerData.new(RichLogHandler.get_handler_data_tag())
	data.data = { 
		timestamp = color_map.get(t, FG_WHITE),
		level = color_map.get(l, FG_WHITE),
		message = color_map.get(m, FG_WHITE)
	}
	return data
	
static func get_handler_data_tag() -> String:
	return data_tag	
	
# 外部一律使用 LogColor 定义
static func colorize(text: String, color: LogColor) -> String:
	var color_code = color_map.get(color, FG_WHITE)
	return "[color=%s]%s[/color]" % [color_code, text]

# 加上颜色属性
func _colorize(text: String, color_code: String) -> String:
	return "[color=%s]%s[/color]" % [color_code, text]
	
# 建立颜色对应表
func create_color_map():	
	color_map[LogColor.FG_BLACK] = FG_BLACK
	color_map[LogColor.FG_RED] = FG_RED
	color_map[LogColor.FG_GREEN] = FG_GREEN
	color_map[LogColor.FG_YELLOW] = FG_YELLOW
	color_map[LogColor.FG_BLUE] = FG_BLUE
	color_map[LogColor.FG_MAGENTA] = FG_MAGENTA
	color_map[LogColor.FG_CYAN] = FG_CYAN
	color_map[LogColor.FG_WHITE] = FG_WHITE
	color_map[LogColor.FG_ORANGE] = FG_ORANGE
	color_map[LogColor.FG_GRAY] = FG_GRAY
	color_map[LogColor.FG_PINK] = FG_PINK
	color_map[LogColor.FG_PURPLE] = FG_PURPLE


# 不给初始颜色就会使用内定值
func _init(default_color :Dictionary = {}):
	#for color in ['black', 'red', 'green', 'yellow', 'blue', 'magenta', 'pink', 'purple', 'cyan', 'white', 'orange', 'gray']:
	#	print_rich("[color={color}]Hello world![/color]".format({color=color}))
	if default_color:
		color_debug = default_color.get("debug", color_debug)
		color_info = default_color.get("info", color_info)
		color_warning = default_color.get("warning", color_warning)
		color_error = default_color.get("error", color_error)
		color_known = default_color.get("known", color_known)

	create_color_map()


func _print_rich(_custom_data: LogHandlerData, timestamp: String, level: String, message: String, default_colorg: String):
	# 使用自定义颜色
	if _custom_data and _custom_data.tag == data_tag:
		var data : Dictionary = _custom_data.data
		var color_t = data.get("timestamp", default_colorg)
		var color_l = data.get("level", default_colorg)
		var color_m = data.get("message", default_colorg)
		var inline = data.get("inline", false)
		var	log_message = custom_template.format({
				color_timestamp = color_t,
				color_level = color_l,
				color_message =color_m,
				timestamp = timestamp,
				level = level,
				message = message
				})
		print_rich(log_message)
		return
	else:
		var log_message =  default_template.format({
				color = default_colorg,
				timestamp = timestamp,
				level = level,
				message = message
				})
		print_rich(log_message)

func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	var message : String = _message.data
	#Dictionary
	var log_message
	var color
	
	match level:
		LogHandler.LogLevel.DEBUG:
			_print_rich(_custom_data, timestamp, "DEBUG", message, color_debug)
			   
		LogHandler.LogLevel.INFO:
			_print_rich(_custom_data, timestamp, "INFO", message, color_info)
			
		LogHandler.LogLevel.WARNING:
			_print_rich(_custom_data, timestamp, "WARNING", message, color_warning)
			
		LogHandler.LogLevel.ERROR:
			_print_rich(_custom_data, timestamp, "ERROR", message, color_error)
		_:
			_print_rich(_custom_data, timestamp, "UNKNOWN", message, color_known)
			
	return true
 
