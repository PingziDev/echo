class_name DumpStackLogHandler
extends LogHandler
## DumpStackLogHandler
## 倾印堆栈
## 需要使用 add_filter 才能正确取得堆栈内容

# stack显示行数
var stack_size_debug := 0 
var stack_size_info := 0
var stack_size_warning := 0 
var stack_size_error := 0
var stack_size_known := 0

var stack_no_color_template = "\t{source}:{line}"

# 预设跳过内容，因为logger到filter这个路径对开发者没用
var skip := 3

## 禁止在回呼里面使用log，避免成为无穷回圈
## args: Dictionary { source, line, function }
var on_get_stack : Callable

# stack忽略的内容, 每行格式{source，function},会寻找并过滤
var stack_ignore_filters := [
#	{source = "logger", function = ""},
]


func _get_stack(stack_size) -> String:
	var stack := get_stack()
	var stack_trace_message := ""
	var got_stack_count := 0
	var count := 0
	#	stack_size = min(stack_size,stack.size())
	if !stack.is_empty():  # aka has stack trace.
		for i in stack.size():
			var entry = stack[i]
			var infilter := stack_ignore_filters.any(
				func(filter): return (
					entry.source.contains(filter.source)
					and (!filter.function or entry.function.contains(filter.function))
				)
			)
			
			# 跳过内logger到filter这个路径
			count += 1
			if count <= skip:
				continue

			if infilter:
				continue

			var args = { "source": entry.source,
				"line" : str(entry.line),
				"function" : entry.function
			}

			if on_get_stack:
				on_get_stack.call(args)

			stack_trace_message += ("\t{source}:{line} {function}".format(
				{source = args["source"], line = args["line"], function = args["function"]}
			))

			got_stack_count += 1
			if got_stack_count >= stack_size:
				break
			stack_trace_message += "\n"
	else:
		##TODO: test print_debug()
		stack_trace_message = "No stack trace available, please run from within the editor or connect to a remote debug context."

	return stack_trace_message



func _handle(level: LogHandler.LogLevel, timestamp: String, _message: Dictionary, _custom_data: LogHandlerData) -> bool:
	match level:
		LogHandler.LogLevel.DEBUG:
			if stack_size_debug > 0:
				_message.data = _message.data + "\n" + _get_stack(stack_size_debug)

		LogHandler.LogLevel.INFO:
			if stack_size_info > 0:
				_message.data = _message.data + "\n" + _get_stack(stack_size_info)

		LogHandler.LogLevel.WARNING:
			if stack_size_warning > 0:
				_message.data = _message.data + "\n" + _get_stack(stack_size_warning)

		LogHandler.LogLevel.ERROR:
			if stack_size_error > 0:
				_message.data = _message.data + "\n" + _get_stack(stack_size_error)
		
		_:
			if stack_size_known > 0:
				_message.data = _message.data + "\n" + _get_stack(stack_size_known)
	
	return true
