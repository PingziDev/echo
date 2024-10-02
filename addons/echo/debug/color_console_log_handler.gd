class_name ColorConsoleLogHandler
extends LogHandler
## ColorConsoleLogHandler
## 彩色终端机输出
## example
## ColorConsoleLogHandler.new({ debug = ColorConsoleLogHandler.FG_GREEN,
## 		info = ColorConsoleLogHandler.FG_GREEN,
## 		warning = ColorConsoleLogHandler.FG_GREEN
## 		})


## 颜色管理，定义常用颜色，背景色
const RESET = "\u001b[0m"
const BOLD = "\u001b[1m"
const UNDERLINE = "\u001b[4m"

const FG_BLACK = "\u001b[30m"
const FG_RED = "\u001b[31m"
const FG_GREEN = "\u001b[32m"
const FG_YELLOW = "\u001b[33m"
const FG_BLUE = "\u001b[34m"
const FG_MAGENTA = "\u001b[35m"
const FG_CYAN = "\u001b[36m"
const FG_WHITE = "\u001b[37m"

const BG_BLACK = "\u001b[40m"
const BG_RED = "\u001b[41m"
const BG_GREEN = "\u001b[42m"
const BG_YELLOW = "\u001b[43m"
const BG_BLUE = "\u001b[44m"
const BG_MAGENTA = "\u001b[45m"
const BG_CYAN = "\u001b[46m"
const BG_WHITE = "\u001b[47m"


const data_tag = "ColorConsoleLogHandler"

var color_debug = ColorConsoleLogHandler.FG_GREEN
var color_info = ColorConsoleLogHandler.FG_BLUE
var color_warning = ColorConsoleLogHandler.FG_YELLOW
var color_error = ColorConsoleLogHandler.FG_RED
var color_known = ColorConsoleLogHandler.FG_CYAN

static func get_handler_data_tag() -> String:
	return data_tag
	
# 快速建立颜色
static func make_color(t, l, m) -> LogHandlerData:
	var data = LogHandlerData.new(ColorConsoleLogHandler.get_handler_data_tag())
	data.data = { 
		timestamp = t,
		level = l,
		message = m
	}
	return data
	
# 加上颜色属性
func colorize(text: String, color_code: String) -> String:
	return color_code + text + RESET

	
	
# 不给初始颜色就会使用内定值
func _init(default_color :Dictionary = {}):
	if default_color:
		color_debug = default_color.get("debug", color_debug)
		color_info = default_color.get("info", color_info)
		color_warning = default_color.get("warning", color_warning)
		color_error = default_color.get("error", color_error)
		color_known = default_color.get("known", color_known)
		

func _handle(level: LogHandler.LogLevel, timestamp: String, message: String, _custom_data: LogHandlerData) -> void:
	#Dictionary
	var log_message
	var color
	
	match level:
		LogHandler.LogLevel.DEBUG:
			# 使用自定义颜色
			if _custom_data and _custom_data.tag == data_tag:
				var data : Dictionary = _custom_data.data
				var color_t = data.get("timestamp", color_debug)
				var color_l = data.get("level", color_debug)
				var color_m = data.get("message", color_debug)
				log_message = "%s %s %s" % [colorize("["+timestamp+"]", color_t), colorize("DEBUG", color_l), colorize(message, color_m)]
				print(log_message)
				return
			color = color_debug
			log_message =  "[%s] DEBUG %s" % [timestamp, message]
			   
		LogHandler.LogLevel.INFO:
			# 使用自定义颜色
			if _custom_data and _custom_data.tag == data_tag:
				var data : Dictionary = _custom_data.data
				var color_t = data.get("timestamp", color_info)
				var color_l = data.get("level", color_info)
				var color_m = data.get("message", color_info)
				log_message = "%s %s %s" % [colorize("["+timestamp+"]", color_t), colorize("INFO", color_l), colorize(message, color_m)]
				print(log_message)
				return
			color = color_info
			log_message =  "[%s] INFO %s" % [timestamp, message]

		LogHandler.LogLevel.WARNING:
			# 使用自定义颜色
			if _custom_data and _custom_data.tag == data_tag:
				var data : Dictionary = _custom_data.data
				var color_t = data.get("timestamp", color_warning)
				var color_l = data.get("level", color_warning)
				var color_m = data.get("message", color_warning)
				log_message = "%s %s %s" % [colorize("["+timestamp+"]", color_t), colorize("WARNING", color_l), colorize(message, color_m)]
				print(log_message)
				return
			color = color_warning
			log_message =  "[%s] WARNING %s" % [timestamp, message]

		LogHandler.LogLevel.ERROR:
			# 使用自定义颜色
			if _custom_data and _custom_data.tag == data_tag:
				var data : Dictionary = _custom_data.data
				var color_t = data.get("timestamp", color_error)
				var color_l = data.get("level", color_error)
				var color_m = data.get("message", color_error)
				log_message = "%s %s %s" % [colorize("["+timestamp+"]", color_t), colorize("ERROR", color_l), colorize(message, color_m)]
				print(log_message)
				return
			color = color_error
			log_message =  "[%s] ERROR %s" % [timestamp, message]

		_:
			# 使用自定义颜色
			if _custom_data and _custom_data.tag == data_tag:
				var data : Dictionary = _custom_data.data
				var color_t = data.get("timestamp", color_known)
				var color_l = data.get("level", color_known)
				var color_m = data.get("message", color_known)
				log_message = "%s %s %s" % [colorize("["+timestamp+"]", color_t), colorize("UNKNOWN", color_l), colorize(message, color_m)]
				print(log_message)
				return
			color = color_known
			log_message =  "[%s] UNKNOWN %s" % [timestamp, message]
			
	print(colorize(log_message, color))
	
