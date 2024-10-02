extends Node
## 日志系统
## autoload 

# 引入 LogHandler 的枚举
enum LogLevel {
	DEBUG = 0,
	INFO,
	WARNING,
	ERROR
}

var current_level: LogLevel = LogLevel.DEBUG
#写入读取分开，减少lock使用
var write_buffer: Array = []
var read_buffer: Array = []
var handlers: Array = []

# 线程相关
var log_thread: Thread
var mutex: Mutex
var is_thread_running: bool = false

func _init():
	# 初始化时不做具体操作，处理器会在场景树加入时启动
	pass

func _enter_tree():
	# 启动持久线程
	mutex = Mutex.new()
	log_thread = Thread.new()
	is_thread_running = true
	log_thread.start(_write_thread)

func _exit_tree():
	# 停止线程并写入剩余日志
	is_thread_running = false
	# 等待线程
	OS.delay_msec(100)
	log_thread.wait_to_finish()


func add_handler(handler: LogHandler) -> void:
	handlers.append(handler)

func remove_handler(handler: LogHandler) -> void:
	handlers.erase(handler)


# 线程还没启动之前 log 的内容不会被处理
func _log(level: LogLevel, message: String, custom_data) -> void:
	if not is_thread_running or level < current_level:
		return

	var timestamp = Time.get_datetime_string_from_system()
	mutex.lock()
	write_buffer.append([level, timestamp, message, custom_data])
	mutex.unlock()
	


func debug(message: String, custom_data = null) -> void:
	_log(LogLevel.DEBUG, message, custom_data)

func info(message: String, custom_data = null) -> void:
	_log(LogLevel.INFO, message, custom_data)

func warning(message: String, custom_data = null) -> void:
	_log(LogLevel.WARNING, message, custom_data)

func error(message: String, custom_data = null) -> void:
	_log(LogLevel.ERROR, message, custom_data)

	
# 交换读写缓存，需要线程安全
func buffer_exchange():
	mutex.lock()
	var tmp = write_buffer
	write_buffer = read_buffer
	read_buffer = tmp
	mutex.unlock()

func _write_thread():
	while 1:
		# 读取缓存里面有资料，直接处理
		# 没资料的话就跟写入缓存互换
		if read_buffer.size() > 0:
			for log_entry in read_buffer:
				# 封装到字典的 data 变量
				var wrapper = {"data": log_entry[2]}
				for handler in handlers:
					handler._handle(log_entry[0], log_entry[1], wrapper, log_entry[3])

				
			read_buffer.clear()
				
		else:
			buffer_exchange();
			if read_buffer.size() == 0:
				# 必须要等待所有内容都被清空才离开，避免重要资讯没被处理
				if not is_thread_running:
					break
				# 延迟以避免过度使用 CPU
				OS.delay_msec(50)
