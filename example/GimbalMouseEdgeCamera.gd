extends Spatial

# feature switches
var useInteria = true

var rotation_h = 0
var rotation_sensitivity_h = .005 #bigger number = more sensitivity (i.e. screen will spin/accelerate faster. default is 0.006)
var rotation_inertia_h = 15 #smaller number == more inertia (i.e more time for the spin to stop moving. default is 15)
var rotation_max_h

var rotation_v = 0
var rotation_sensitivity_v = .02
var rotation_acceleration_v = .001
var rotation_direction_h = 0
var rotation_direction_v = 0

var screen_width
var screen_height
var screen_buffer_h = 200
var screen_buffer_y = 200

var mouse_position_h = -1
var mouse_position_y = -1
var mouse_buffer_l = 200
var mouse_buffer_r = 823
var mouse_half_h = "c"

var is_currently_rotating_h = false

func _ready():
	OS.window_fullscreen = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_position_h = event.position.x
		mouse_position_y = event.position.y

		var MousePositionHUDText = "(%s, %s)"
		$MousePositionHUD.text = MousePositionHUDText % [mouse_position_h, mouse_position_y]

		#need to find a way to get rid of this.
		var screen_size = get_viewport().size
		screen_width = screen_size.x - 1
		screen_height = screen_size.y - 1
		
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
#
func _process(delta):
	$MaxRotHHUD.text = str(rotation_max_h)
	$RotationHHUD.text = str(rotation_h)

	# Set rotation direction indicators
	set_rotation_direction_h()
	set_mouse_half_h()
	set_rotation_max(delta)
	execute_rotation(delta)

	# if is_currently_rotating_h:
	# 	rotation_speed_max_h = (rotation_sensitivity_h * pow(screen_buffer_h - mouse_position_h,2) * delta)
	# else:
	# 	rotation_speed_max_h = (rotation_sensitivity_h * pow(mouse_position_h,2) * delta)

	# if mouse_position_h < screen_buffer_h:
	# 	is_currently_rotating_h = true

	# 	rotation_h = lerp(rotation_h,clamp(rotation_h + (rotation_max_h * rotation_sensitivity_h),0,rotation_max_h),rotation_max_h)
	# 	$OuterGimbal.rotation_degrees.y += rotation_h
	# else:
	# 	is_currently_rotating_h = false

func apply_inertia(delta):
	if rotation_h == "r":
		rotation_h = clamp(rotation_h - (rotation_h * pow((rotation_inertia_h * delta),2)),0,rotation_max_h)
		$OuterGimbal.rotation_degrees.y += rotation_h
	elif rotation_h == "l":
		rotation_h = clamp(rotation_h + (rotation_h * pow((rotation_inertia_h * delta),2)),rotation_max_h,0)
		print(rotation_h)
		# $OuterGimbal.rotation_degrees.y += rotation_h

func set_rotation_direction_h():
	if mouse_position_h < mouse_buffer_l:
		rotation_direction_h = "l"
	elif mouse_position_h > mouse_buffer_r:
		rotation_direction_h = "r"
	else:
		rotation_direction_h = "nr"

	var RotationDirectionHHudText = "rot direction h: %s"
	$RotationDirectionHHud.text = RotationDirectionHHudText % rotation_direction_h

func set_mouse_half_h():
	if mouse_position_h < screen_width / 2:
		mouse_half_h = "l"
	elif mouse_position_h > screen_width / 2:
		mouse_half_h = "r"
	else:
		mouse_half_h = "c"

func execute_rotation(delta):
	# Execute rotation_h
	if rotation_direction_h == "l":
		rotation_h = lerp(rotation_h, clamp(rotation_h + (rotation_max_h * rotation_sensitivity_h),0,rotation_max_h), rotation_max_h)
		$OuterGimbal.rotation_degrees.y += rotation_h
	elif rotation_direction_h == "r":
		rotation_h = lerp(rotation_h,clamp(rotation_h + (rotation_max_h * rotation_sensitivity_h), rotation_max_h, 0),-rotation_max_h)
		$OuterGimbal.rotation_degrees.y += rotation_h
	elif rotation_direction_h == "nr":
		if useInteria:
			if not rotation_h == 0:
				apply_inertia(delta)
		else:
			# rotation_h = 0
			pass


func set_rotation_max(delta):
	# Calcuate max_rotation_h
	if rotation_direction_h == "l":
		rotation_max_h = (rotation_sensitivity_h * pow(mouse_buffer_l - mouse_position_h,2) * delta)
	elif rotation_direction_h == "r":
		rotation_max_h = -(rotation_sensitivity_h * pow(mouse_position_h - mouse_buffer_r,2) * delta)
	else:
		if mouse_half_h == "l":
			pass
		rotation_max_h = (rotation_sensitivity_h * pow((mouse_position_h-511.5),2) * delta)
		

		#INERIA CODE
		# if not rotation_h == 0:
		# 	apply_inertia(delta)
