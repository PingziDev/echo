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



# 一般模板输出单一颜色，客制模板可分别控制
var custom_template := "[color={color_timestamp}][{timestamp}][/color] [color={color_level}]{level}[/color] [color={color_message}]{message}[/color]"
# 有内嵌控制码就不需要再另外加入颜色
var custom_inline_template := "[color={color_timestamp}][{timestamp}][/color] [color={color_level}]{level}[/color] {message}"
var default_template := "[color={color}][{timestamp}] {message} {level}[/color]"

var color_debug ="green"
var color_info = "blue"
var color_warning = "yellow"
var color_error = "red"
var color_known = "cyan"

# 快速建立颜色
static func make_color(t, l, m) -> LogHandlerData:
	var data = LogHandlerData.new(RichLogHandler.get_handler_data_tag())
	data.data = { 
		timestamp = t,
		level = l,
		message = m
	}
	return data
	
static func get_handler_data_tag() -> String:
	return data_tag	
	
# 加上颜色属性
static func colorize(text: String, color_code: String) -> String:
	return "[color=%s]%s[/color]" % [color_code, text]

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


func _print_rich(_custom_data: LogHandlerData, timestamp: String, level: String, message: String, default_colorg: String):
	# 使用自定义颜色
	if _custom_data and _custom_data.tag == data_tag:
		var data : Dictionary = _custom_data.data
		var color_t = data.get("timestamp", default_colorg)
		var color_l = data.get("level", default_colorg)
		var color_m = data.get("message", default_colorg)
		var inline = data.get("inline", false)
		var log_message
		
		# 使用内嵌的颜色，不需要再另外加上控制码
		if inline:
				log_message = custom_inline_template.format({
				color_timestamp = color_t,
				color_level = color_l,
				timestamp = timestamp,
				level = level,
				message = message
				})
		else:
			log_message = custom_template.format({
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
 
