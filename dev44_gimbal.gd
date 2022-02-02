extends Spatial

var rotation_h = 0
var rotation_sensitivity_h = .006 #bigger number = more sensitivity (i.e. screen will spin/accelerate faster. default is 0.006)
var rotation_inertia_h = 15 #smaller number == more inertia (i.e more time for the spin to stop moving. default is 15)
var rotation_speed_max_h

var rotation_v = 0
var rotation_sensitivity_v = .02
var rotation_acceleration_v = .001

var screen_width
var screen_height
var screen_buffer_h = 150
var screen_buffer_y = 200

var mouse_position_h = -1
var mouse_position_y = -1

var is_currently_rotating_h = false

func _ready():
	OS.window_fullscreen = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_position_h = event.position.x
		mouse_position_y = event.position.y
		
		var screen_size = get_viewport().size
		screen_width = screen_size.x - 1
		screen_height = screen_size.y - 1
		
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
#
func _process(delta):

	if is_currently_rotating_h:
		rotation_speed_max_h = (rotation_sensitivity_h * pow(screen_buffer_h - mouse_position_h,2) * delta)
	else:
		rotation_speed_max_h = (rotation_sensitivity_h * pow(mouse_position_h,2) * delta)
		
		#INERIA CODE
		if not rotation_h == 0:
			$gimbal_h.rotation_degrees.y += rotation_h
			rotation_h = clamp(rotation_h - (rotation_h * pow((rotation_inertia_h * delta),2)),0,rotation_speed_max_h)

	if mouse_position_h < screen_buffer_h:
		is_currently_rotating_h = true

		rotation_h = lerp(rotation_h,clamp(rotation_h + (rotation_speed_max_h * rotation_sensitivity_h),0,rotation_speed_max_h),rotation_speed_max_h)
		$gimbal_h.rotation_degrees.y += rotation_h
	else:
		is_currently_rotating_h = false

	print(rotation_h)

	# if mouse_position_x < screen_buffer_x:
	# 	rotation_h = -lerp(((screen_buffer_x - mouse_position_x) * rotation_sensitivity_h),-0.3,rotation_acceleration_h)
	# 	$gimbal_h.rotation_degrees.y += rotation_h
		
	# if mouse_position_x > screen_width-screen_buffer_x:
	# 	rotation_h = -lerp((((screen_width-screen_buffer_x) - mouse_position_x) * rotation_sensitivity_h),0.3,rotation_acceleration_h)
	# 	$gimbal_h.rotation_degrees.y += rotation_h
	
	# if mouse_position_y < screen_buffer_y:
	# 	rotation_v = -lerp(((screen_buffer_y - mouse_position_y) * rotation_sensitivity_v),-0.3,rotation_acceleration_v)
	# 	$gimbal_h/gimbal_v.rotation_degrees.x += rotation_v
		
	# if mouse_position_y > screen_height-screen_buffer_y:
	# 	rotation_v = -lerp((((screen_height-screen_buffer_y) - mouse_position_y) * rotation_sensitivity_v),0.3,rotation_acceleration_v)
	# 	$gimbal_h/gimbal_v.rotation_degrees.x += rotation_v
