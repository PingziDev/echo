class_name ConsoleLogHandler
extends LogHandler
## 标准终端机输出

#输出格式模板
var template := "{timestamp} {level} {message}"

func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	var message : String = _message.data
	var log_message = template.format(
			{
				timestamp = timestamp,
				level = get_level_string(level),
				message = message,
			})
	print(log_message)
	return true
