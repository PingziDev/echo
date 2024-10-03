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

func _handle(level: LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	var message : String = _message.data
	var log_message = "[%s] [%s] %s" % [timestamp, get_level_string(level), message]
	file = FileAccess.open(log_file_path, FileAccess.READ_WRITE)
	
	# 检查档案是否成功打开
	if file == null:
		# 如果档案不存在，创建新档案
		file = FileAccess.open(log_file_path, FileAccess.WRITE)
		if file == null:
			push_error("Failed to write to log file: %s" % log_file_path)
			return true
			
	file.seek_end()
	file.store_line(log_message)
	file.close()

	return true
