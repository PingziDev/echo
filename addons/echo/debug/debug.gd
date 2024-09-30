class_name Debug extends CanvasLayer  # 使用node2d,方便在世界坐标中绘制图形,如果要在viewport上绘制,则要使用canvaslayer

var debugnode2d: TheDebug_node2d

var debugging = true
## 录制视频
var recording = false


func _ready():
	layer = 999
	_set_debug_window()

	debugnode2d = TheDebug_node2d.new()
	debugnode2d.z_index = 999
	add_child(debugnode2d)


# 测试环境窗口放在右上角
func _set_debug_window():
	# 左上角启动
	#DisplayServer.window_set_size(Vector2(1920,1080))
	# if debugging and OS.has_feature("editor") or OS.is_debug_build():
	# DebugMenu.show()
	# DebugMenu.style = DebugMenu.Style.VISIBLE_COMPACT

	if debugging and OS.has_feature("editor"):
		DisplayServer.window_set_position(Vector2(1140, 0))
		DisplayServer.window_set_size(Vector2(1366, 768))

	if recording:
		# DebugMenu.hide()
		DisplayServer.window_set_size(Vector2(1920, 1080))
		DisplayServer.window_set_position(Vector2(0, 0))


#		DisplayServer.window_set_size(Vector2(1920*0.94, 1080*0.94))
# 		Main.gamespeed = 3

#		DisplayServer.window_set_size(Vector2(1000,2000))
#		DisplayServer.window_set_position(Vector2(0,250))

# 右上角启动
#DisplayServer.window_set_position(Vector2(DisplayServer.screen_get_size().x-DisplayServer.window_get_size().x-60,0))
#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


class TheDebug_node2d:
	extends Node2D

	var _draw_shapes: Array  # [[Shape2D,color]]

	## 只有node2d可以draw
	func _draw():
		for data in _draw_shapes:
			if data[0] != null:
				var shp = data[0].shape
				if shp is RectangleShape2D:
					var s = shp.extents
					draw_rect(Rect2(data[0].global_position - s, s * 2), data[1])
				elif shp is CapsuleShape2D or shp is CircleShape2D:
					var s = shp.radius
					draw_circle(data[0].global_position, s, data[1])
				else:
					Logger.error("shp type not defined" + shp)

	func draw_shape(shp, color = Color("b3b0006b")):
		_draw_shapes.append([shp, color])
		queue_redraw()

	func clear_draws():
		_draw_shapes.clear()
		queue_redraw()


func is_vscode():
	return "vscode" in OS.get_cmdline_args()
