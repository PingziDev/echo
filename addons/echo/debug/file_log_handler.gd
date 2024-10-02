class_name FileLogHandler
extends LogHandler
## FileLogHandler
## 文档输出

var log_file_path: String = "user://log.txt"
var file

func _init(path: String = "user://log.txt"):
	log_file_path = path
	file = FileAccess.open(log_file_path, FileAccess.READ_WRITE)
	if file:
		file.close()
	else:
		push_error("Failed to open log file: %s" % log_file_path)

func _handle(level: LogLevel, timestamp: String, message: String, _custom_data: LogHandlerData) -> void:
	var log_message = "[%s] [%s] %s" % [timestamp, get_level_string(level), message]
	file = FileAccess.open(log_file_path, FileAccess.READ_WRITE)
	if file:
		file.seek_end()
		file.store_line(log_message)
		file.close()
	else:
		push_error("Failed to write to log file: %s" % log_file_path)
