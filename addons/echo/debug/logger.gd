extends Node

## TODO 将配置提取成resource config
## 调式类型 TODO 讨论如何配置化

@export_category("配置")
#@export var show_level := Logger.loglevel.debug
@export var show_level := Logger.loglevel.profiler

# 分类, hide优先级高于show
# * 代表全部
# main,schedule,
@export var show_category: Array[String] = [
#"", # 开启此项会全部显示
# 关闭all后,开启哪项显示哪项
#LogType.main,
#LogType.schedule,
# LogType.saveload,
#LogType.combo,
#LogType.supplier,
#LogType.settlement,
#LogType.input,
# LogType.BUSINNESS,
# LogType.BUY,
]

@export var write_file := true
@export var profiler_max := 200
@export var is_profiling := false
@export var debug_stack_size := 6  # stack显示行数
@export var info_stack_size := 1  # stack显示行数

# stack忽略的内容, 每行格式{source，function},会寻找并过滤
@export var stack_ignore_filters := [
	{source = "logger", function = ""},
]

enum loglevel { profiler, debug, info, warn, error }
#var no_color_template = '{time}|{level}|{category} {name} {data}'
#var color_template = '[code]{time}|{level}|{category}[/code] [color={levelcolor}]{name}[/color] [color={datacolor}]{data}[/color]'

var no_color_template := "[{category}] {name} {data}"
var color_template := "[[color=gray]{category}[/color]] [color={levelcolor}]{name}[/color] [color={datacolor}]{data}[/color]"

var stack_no_color_template = "\t{source}:{line}"
var stack_color_template = "\t\t[code][color={sourcecolor}]{source}:{line}[/color] [color={functioncolor}]{function}[/color][/code]"

var time_temmplate := "{hour}:{minute}:{second}"
var log_dir := "res://logs"
var log_path := "res://logs/debug.log"
var profiler_path := "res://logs/profiler.log"
var profiler_data: Array
var file: FileAccess
var is_editor:
	get:
		return OS.has_feature("editor")

## 决定是否要颜色
var show_color := false

#	for color in ['black', 'red', 'green', 'yellow', 'blue', 'magenta', 'pink', 'purple', 'cyan', 'white', 'orange', 'gray']:
#		print_rich("[color={color}]Hello world![/color]".format({color=color}))


func _ready():
	show_color = !Echo.debug.is_vscode()  # vscode无法解析带颜色的字符
	if !DirAccess.dir_exists_absolute(log_dir):
		DirAccess.make_dir_absolute(log_dir)
	prints(
		"---logger ready:",
		"show_level:" + loglevel.keys()[show_level],
		"show_category:" + ",".join(show_category.map(func(i): return "")),
		"---"
	)


func set_show_level(level):
	show_level = level
	prints("set show_level:" + loglevel.keys()[show_level])


func _is_category_show(category):
	if show_category.has(""):
		return true
	if category == "":
		# 默认的也显示
		return true
	return show_category.has(category)


func debug(name, data = "", category: String = ""):
	if show_level > loglevel.debug or !_is_category_show(category):
		return
	_print_rich(_get_message(name, data, category, loglevel.debug, "cyan", "white"))
	if is_editor:
		_print_rich(_get_stack(debug_stack_size))
		_write_file(name, data, category, loglevel.debug)


func info(name, data = "", category: String = ""):
	if show_level > loglevel.info or !_is_category_show(category):
		return
	var msg = _get_message(name, data, category, loglevel.info, "green", "white")
	if is_editor:
		msg += _get_stack(info_stack_size)
	_print_rich(msg)
	#	print_rich(_get_stack(info_stack_size))
	if is_editor:
		_write_file(name, data, category, loglevel.info)


func warn(name, data = "", category: String = ""):
	if show_level > loglevel.warn or !_is_category_show(category):
		return
	_print_rich(_get_message(name, data, category, loglevel.warn, "yellow", "white"))
	if is_editor:
		_print_rich(_get_stack(debug_stack_size))
		_write_file(name, data, category, loglevel.warn)
	push_warning(_get_message(name, data, category, loglevel.warn))


func error(name, data = "", category: String = ""):
	if show_level > loglevel.error or !_is_category_show(category):
		return
	_print_rich(_get_message(name, data, category, loglevel.error, "pink", "white"))
	#	printerr(_get_message(data,category,'error'))
	if is_editor:
		_print_rich(_get_stack(debug_stack_size))
	push_error(_get_message(name, data, category, loglevel.error))
	if is_editor:
		_write_file(name, data, category, loglevel.error)


func _get_message(
	name,
	data,
	category: String = "",
	level = loglevel.info,
	levelcolor = "orange",
	datacolor = "white"
):
	if show_color:
		return color_template.format(
			{
				level = loglevel.keys()[level],
				time = time_temmplate.format(Time.get_datetime_dict_from_system(true)),
				category = "",
				name = str(name),
				data = str(data),
				levelcolor = levelcolor,
				datacolor = datacolor
			}
		)
	return (
		no_color_template
		. format(
			{
				level = loglevel.keys()[level],
				time = time_temmplate.format(Time.get_datetime_dict_from_system(true)),
				category = "",
				name = str(name),
				data = str(data),
			}
		)
	)


func _write_file(name, data, category, level):
	if write_file:
		if file == null:
			file = FileAccess.open(log_path, FileAccess.WRITE)
		file.store_line(_get_message(name, data, category, level))


func _get_stack(stack_size) -> String:
	var stack := get_stack()
	var stack_trace_message := ""
	var got_stack_count := 0
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
			if infilter:
				continue
			if show_color:
				stack_trace_message += (
					stack_color_template
					. format(
						{
							source = entry.source,
							line = str(entry.line),
							function = entry.function,
							# black, red, green, yellow, blue, magenta, pink, purple, cyan, white, orange, gray.
							sourcecolor = "gray",
							functioncolor = "orange"
						}
					)
				)
			else:
				stack_trace_message += (stack_no_color_template.format(
					{source = entry.source, line = str(entry.line), function = entry.function}
				))

			got_stack_count += 1
			if got_stack_count >= stack_size:
				break
			stack_trace_message += "\n"
	else:
		##TODO: test print_debug()
		stack_trace_message = "No stack trace available, please run from within the editor or connect to a remote debug context."
	return stack_trace_message


func profiler_start(category: String = ""):
	if show_level > loglevel.debug or !_is_category_show(category):
		return
	profiler_data.clear()
	is_profiling = true
	_add_profiler_message(
		"--------------profilter start-----------------[{category}]".format({category = ""}),
		"",
		category
	)


func profiler(name, data = "", category: String = ""):
	if show_level > loglevel.debug or !_is_category_show(category):
		return
	if is_profiling:
		_add_profiler_message(name, data, category)
		if profiler_data.size() >= profiler_max:
			profiler_stop()


func profiler_stop(category: String = ""):
	if show_level > loglevel.debug or !_is_category_show(category):
		return
	is_profiling = false
	_add_profiler_message(
		"--------------profilter stop-----------------[{category}]".format({category = ""}),
		"",
		category
	)
	var file := FileAccess.open(profiler_path, FileAccess.WRITE)
	for line in profiler_data:
		file.store_line(line)
	file.close()
	profiler_data.clear()


func _add_profiler_message(name, data, category):
	var msg = _get_message(name, data, category, loglevel.profiler)
	profiler_data.append(msg)
	_print_rich(msg)


func mouse_text(msg):
	var mousetext := RichTextLabel.new()
	mousetext.name = "mousetext"
	mousetext.z_index = 999
	mousetext.bbcode_enabled = true
	mousetext.size = Vector2(200, 100)
	Echo.debug.add_child(mousetext)
	mousetext.global_position = Echo.debug.debugnode2d.get_global_mouse_position()
	mousetext.text = str(msg)
	var DURATION := 0.5
	var newposition := mousetext.position + Vector2(0, -30)
	await (
		mousetext
		. create_tween()
		. tween_property(mousetext, "position", newposition, DURATION)
		. finished
	)
	mousetext.queue_free()


func transform_text(msg, transform: Node2D, offset = Vector2(0, -100)):
	var mousetext := RichTextLabel.new()
	mousetext.name = "mousetext"
	mousetext.z_index = 999
	mousetext.bbcode_enabled = true
	mousetext.size = Vector2(200, 100)
	Echo.debug.add_child(mousetext)
	mousetext.global_position = transform.get_screen_transform().origin + offset
	mousetext.text = str(msg)
	var DURATION := 0.5
	var newposition := mousetext.position + Vector2(0, -30)
	await (
		mousetext
		. create_tween()
		. tween_property(mousetext, "position", newposition, DURATION)
		. finished
	)
	mousetext.queue_free()


## exp:
#_cmd('which',['pip3'])
#_cmd('pip',[ '--version'])
#_cmd("pip3", ["install", "gdtoolkit"])
func debug_cmd(path, args = []):
	var output := []
	var res1 := OS.execute(path, args, output)
	Logger.info(
		path + " " + " ".join(args),
		("[sucess]" if res1 == OK else "[fail]") + " " + "\n".join(output)
	)


func _print_rich(msg):
	if show_color:
		print_rich(msg)
	else:
		print(msg)
