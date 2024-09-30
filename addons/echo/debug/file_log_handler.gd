# FileLogHandler.gd
extends LogHandler

class_name FileLogHandler

var log_file_path: String = "user://log.txt"
var file

func _init(path: String = "user://log.txt"):
	log_file_path = path
	file = FileAccess.open(log_file_path, FileAccess.READ_WRITE)
	if file:
		file.close()
	else:
		push_error("Failed to open log file: %s" % log_file_path)
		

func handle(level: LogLevel, timestamp: String, message: String) -> void:
	var log_message = "[%s] [%s] %s" % [timestamp, get_level_string(level), message]
	file = FileAccess.open(log_file_path, FileAccess.READ_WRITE)
	if file:
		file.seek_end()
		file.store_line(log_message)
		file.close()
	else:
		push_error("Failed to write to log file: %s" % log_file_path)

func get_level_string(level: LogLevel) -> String:
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
