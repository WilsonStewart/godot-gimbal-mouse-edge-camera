extends Spatial

# feature switches
var useInertia = false

# mouse
var mouse_position_h
var mouse_position_v

# rotation
var rotation_h = 0
var rotation_v = 0
var rotation_inertia_h
var rotation_inertia_v
var doRotate_h = false
var doRotate_v = false

# hud
const mouse_position_hud_format_string = "mouse position: (%s, %s)"
const rotation_h_hud_format_string = "rotation_h: %s"

func _ready():
#	OS.window_fullscreen = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _input(event):
	if event is InputEventMouseMotion:
		update_mouse_position(event)
	
	# close game on clicking escape #DEBUG 
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
		
	if Input.is_key_pressed(KEY_J):
		$MousePositionHUD.text
	

func _process(delta):
	$RotationHHUD.text = rotation_h_hud_format_string % rotation_h
	
	# set rotation vars h
	if mouse_position_h < mouse_buffer_left:
		doRotate_h = true
		rotation_h = calc_rotation(mouse_position_h, mouse_buffer_left) * delta

	else if mouse_position_h > mouse_buffer_right:
		doRotate_h = true
		rotation_h = calc_rotation(mouse_position_h, mouse_buffer_right) * delta

	else:
		doRotate_h = false

	# Apply rotation
	if doRotate_h:
		pass
	else:
		if useInertia:
			apply_inertia()

# update the mouse position every time motion is detected
func update_mouse_position(e):
	mouse_position_h = e.position.x
	mouse_position_v = e.position.y
	var text = rotation_h_hud_format_string % rotation_h
	print(text)
	
	$MousePositionHUD.text = mouse_position_hud_format_string % [mouse_position_h, mouse_position_v]

func calc_rotation(mouse_position, mouse_buffer):
	return -pow(mouse_position - mouse_buffer, 3)

func apply_inertia():
	pass