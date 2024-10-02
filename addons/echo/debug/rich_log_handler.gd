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


func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> void:
	var message : String = _message.data
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
				log_message = custom_template.format({
						color_timestamp = color_t,
						color_level = color_l,
						color_message =color_m,
						timestamp = timestamp,
						level = "DEBUG",
						message = message
						})
				print_rich(log_message)
				return
			log_message =  default_template.format({
					color = color_debug,
					timestamp = timestamp,
					level = "DEBUG",
					message = message
					})
			   
		LogHandler.LogLevel.INFO:
			# 使用自定义颜色
			if _custom_data and _custom_data.tag == data_tag:
				var data : Dictionary = _custom_data.data
				var color_t = data.get("timestamp", color_info)
				var color_l = data.get("level", color_info)
				var color_m = data.get("message", color_info)
				log_message = custom_template.format({
						color_timestamp = color_t,
						color_level = color_l,
						color_message =color_m,
						timestamp = timestamp,
						level = "INFO",
						message = message
						})
				print_rich(log_message)
				return
			log_message =  default_template.format({
					color = color_info,
					timestamp = timestamp,
					level = "INFO",
					message = message
					})

		LogHandler.LogLevel.WARNING:
			# 使用自定义颜色
			if _custom_data and _custom_data.tag == data_tag:
				var data : Dictionary = _custom_data.data
				var color_t = data.get("timestamp", color_warning)
				var color_l = data.get("level", color_warning)
				var color_m = data.get("message", color_warning)
				log_message = custom_template.format({
						color_timestamp = color_t,
						color_level = color_l,
						color_message =color_m,
						timestamp = timestamp,
						level = "WARNING",
						message = message
						})
				print_rich(log_message)
				return
			log_message =  default_template.format({
					color = color_warning,
					timestamp = timestamp,
					level = "WARNING",
					message = message
					})

		LogHandler.LogLevel.ERROR:
			# 使用自定义颜色
			if _custom_data and _custom_data.tag == data_tag:
				var data : Dictionary = _custom_data.data
				var color_t = data.get("timestamp", color_error)
				var color_l = data.get("level", color_error)
				var color_m = data.get("message", color_error)
				log_message = custom_template.format({
						color_timestamp = color_t,
						color_level = color_l,
						color_message =color_m,
						timestamp = timestamp,
						level = "ERROR",
						message = message
						})
				print_rich(log_message)
				return
			log_message =  default_template.format({
					color = color_error,
					timestamp = timestamp,
					level = "ERROR",
					message = message
					})

		_:
			# 使用自定义颜色
			if _custom_data and _custom_data.tag == data_tag:
				var data : Dictionary = _custom_data.data
				var color_t = data.get("timestamp", color_known)
				var color_l = data.get("level", color_known)
				var color_m = data.get("message", color_known)
				log_message = custom_template.format({
						color_timestamp = color_t,
						color_level = color_l,
						color_message =color_m,
						timestamp = timestamp,
						level = "UNKNOWN",
						message = message
						})
				print_rich(log_message)
				return
			log_message =  default_template.format({
					color = color_known,
					timestamp = timestamp,
					level = "UNKNOWN",
					message = message
					})
			
	print_rich(log_message)
