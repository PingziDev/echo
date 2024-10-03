extends Node2D

var is_editor = false

	
# 依照需求决定控制元件
func get_color() -> LogHandlerData:
	if is_editor:
		return RichLogHandler.make_color( RichLogHandler.FG_CYAN,
			RichLogHandler.FG_GREEN,
			RichLogHandler.FG_RED
			)
	else:
		return ColorConsoleLogHandler.make_color( ColorConsoleLogHandler.BG_GREEN + ColorConsoleLogHandler.BOLD,
			ColorConsoleLogHandler.BG_BLUE + ColorConsoleLogHandler.BOLD,
			ColorConsoleLogHandler.BG_RED + ColorConsoleLogHandler.BOLD
			)
	
# 添加颜色	
func logger_info(message):
	Logger.info(message,  get_color())


# 添加分类
func logger_category_debug(message, category):
	# 建立一个颜色处理器控制包
	var log_handler_data = get_color()
	# 添加分类
	log_handler_data.data["category"] = category
	
	Logger.debug(message, log_handler_data)

	
func _ready() -> void:
	
	# Logger为全局类，所有的handler只需要添加一次，请于autoload添加
	
	
	# 加入一个自定义的分类处理器
	Logger.add_handler(CategoryLogHandler.new())
	
	# 控制码过滤器只能过滤讯息本身的内容，其他LogHandler所附加上去的效果会直接输出，不会被过滤
	# 可以将一些嵌入的控制码过滤掉，避免log到档案中
	
	# 过滤所有 RichLogHandler 控制码
	#Logger.add_handler(RegexLogHandler.new(RegexLogHandler.StripFunction.RICH_TAG))
	
	# 过滤所有 ColorConsoleLogHandler 控制码
	#Logger.add_handler(RegexLogHandler.new(RegexLogHandler.StripFunction.ANSI_CODE))
	
	
	
	# 通用log，使用 ColorConsoleLogHandler 内嵌控制码在终端机支援的情况下一样会显示颜色
	# godot 自带output好像有bug, 使用print后马上接print_rich，结果print也可以解析print_rich的控制码
	Logger.add_handler(ConsoleLogHandler.new())
	
	# 引擎编辑器除错工具
	Logger.add_handler(EditorLogHandler.new())

	# 引擎编辑器 output ，带有彩色输出
	Logger.add_handler(RichLogHandler.new())
	
	# 带颜色输出 自定义输出颜色
	#Logger.add_handler( RichLogHandler.new({ debug = RichLogHandler.FG_GREEN,
	#		info = RichLogHandler.FG_GREEN,
	#		warning = RichLogHandler.FG_GREEN,
	#		error = RichLogHandler.FG_GREEN
	#		}))	
	
	# 带颜色输出
	# default color
	Logger.add_handler( ColorConsoleLogHandler.new())
	
	# 带颜色输出 自定义输出颜色
	#Logger.add_handler( ColorConsoleLogHandler.new({ debug = ColorConsoleLogHandler.FG_GREEN,
	#		info = ColorConsoleLogHandler.FG_GREEN,
	#		warning = ColorConsoleLogHandler.FG_GREEN,
	#		error = ColorConsoleLogHandler.FG_GREEN
	#		}))
	
	# 档案输出
	# 指定路径档名
	#Logger.add_handler(FileLogHandler.new("res://echo.txt"))
	
	# 不指定路径档名
	Logger.add_handler(FileLogHandler.new())
	
	# 一般log
	Logger.debug("Ready")
	Logger.info("Ready")
	Logger.warning("Ready")
	Logger.error("Ready")
	
			
	var message
	
	# 终端机颜色内嵌
	message	 = ColorConsoleLogHandler.colorize("I am", ColorConsoleLogHandler.FG_YELLOW) +  ColorConsoleLogHandler.colorize(" color console", ColorConsoleLogHandler.FG_CYAN) +  ColorConsoleLogHandler.colorize(" !!!", ColorConsoleLogHandler.FG_RED)
	Logger.debug(message)
	
	message	 = RichLogHandler.colorize("I am", RichLogHandler.FG_YELLOW) +  RichLogHandler.colorize(" rich output", RichLogHandler.FG_CYAN) +  RichLogHandler.colorize(" !!!", RichLogHandler.FG_RED)
	Logger.debug(message, RichLogHandler.make_inline())
	
	# 使用变量控制输出，并封装方便使用
	logger_info("color switch");
	
	# 加入 echo 分類，
	# category_log_handler 会将不在 show_category 的类别都过滤掉
	# 将分类修改个名字试试，在试试效果~
	logger_category_debug("you can't see me", "echo")
	
