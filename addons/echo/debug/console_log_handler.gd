class_name ConsoleLogHandler
extends LogHandler
## 标准终端机输出

func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	var message : String = _message.data
	var log_message
	
	match level:
		LogHandler.LogLevel.DEBUG:
			log_message = "[%s] DEBUG %s" % [timestamp, message]

		LogHandler.LogLevel.INFO:
			log_message = "[%s] INFO %s" % [timestamp, message]

		LogHandler.LogLevel.WARNING:
			log_message = "[%s] WARNING %s" % [timestamp, message]

		LogHandler.LogLevel.ERROR:
			log_message = "[%s] ERROR %s" % [timestamp, message]

		_:
			log_message = "[%s] UNKNOWN %s" % [timestamp, message]
			
	print(log_message)
	return true
