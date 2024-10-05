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
var filters: Array = []
# 避免等待时间过长，新增移除handler都先放在queue
var handlers_op: Array = []

# 线程相关
var log_thread: Thread
var mutex: Mutex
# 操作handlers安全锁
var handlers_op_mutex: Mutex
var is_thread_running: bool = false

func _init():
	# 初始化时不做具体操作，处理器会在场景树加入时启动
	pass

func _enter_tree():
	# 启动持久线程
	mutex = Mutex.new()
	handlers_op_mutex = Mutex.new()
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
	handlers_op_mutex.lock()
	handlers_op.append({
		cmd = "add",
		handler = handler})
	handlers_op_mutex.unlock()

func remove_handler(handler: LogHandler) -> void:
	handlers_op_mutex.lock()
	handlers_op.append({
		cmd = "remove",
		handler = handler})
	handlers_op_mutex.unlock()

## filter 由主线程运行，尽量不要加入太复杂的filter避免影响游戏性能
func add_filter(handler: LogHandler) -> void:
	filters.append(handler)

func remove_filter(handler: LogHandler) -> void:
	filters.erase(handler)

# 线程还没启动之前 log 的内容不会被处理
func _log(level: LogLevel, message: String, custom_data: LogHandlerData) -> void:
	
	var timestamp = Time.get_datetime_string_from_system()

	var wrapper = {"data": message}
	for filter in filters:
		if not filter._handle(level, timestamp, wrapper, custom_data):
			return

	if not is_thread_running or level < current_level:
		return
	
	mutex.lock()
	write_buffer.append([level, timestamp, wrapper.data, custom_data])
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
func swap_buffer():
	mutex.lock()
	var tmp = write_buffer
	write_buffer = read_buffer
	read_buffer = tmp
	mutex.unlock()

func _write_thread():
	# 這裡需要無窮迴圈，讓資料清完後再break退出
	while 1:
		# 新增移除 handlers
		handlers_op_mutex.lock()
		if handlers_op.size() > 0:
			for op in handlers_op:
				match op.cmd:
					"add":
						handlers.append(op.handler)
					"remove":
						handlers.erase(op.handler)

			handlers_op.clear()
		handlers_op_mutex.unlock()

		# 读取缓存里面有资料，直接处理
		# 没资料的话就跟写入缓存互换
		if read_buffer.size() > 0:
			for log_entry in read_buffer:
				# 封装到字典的 data 变量
				var wrapper = {"data": log_entry[2]}
				for handler in handlers:
					if not handler._handle(log_entry[0], log_entry[1], wrapper, log_entry[3]):
						break
			read_buffer.clear()
				
		else:
			swap_buffer();
			if read_buffer.size() == 0:
				# 必须要等待所有内容都被清空才离开，避免重要资讯没被处理
				if not is_thread_running:
					return
				# 延迟以避免过度使用 CPU
				OS.delay_msec(50)
