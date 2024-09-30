# console_log_handler.gd
extends LogHandler

class_name ConsoleLogHandler

func handle(level: LogHandler.LogLevel, timestamp: String, message: String) -> void:
	var log_message = "[%s] [%s] %s" % [timestamp, get_level_string(level), message]
	print(log_message)

func get_level_string(level: LogHandler.LogLevel) -> String:
	match level:
		LogHandler.LogLevel.DEBUG:
			return "DEBUG"
		LogHandler.LogLevel.INFO:
			return "INFO"
		LogHandler.LogLevel.WARNING:
			return "WARNING"
		LogHandler.LogLevel.ERROR:
			return "ERROR"
		_:
			return "UNKNOWN"
