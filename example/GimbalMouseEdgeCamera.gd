extends Spatial

# mouse
var mouse_position_h
var mouse_position_v

# rotation
var rotation_h
var rotation_v
var rotation_inertia_h
var rotation_inertia_v
var doRotate_h = false
var doRotate_v = false

func _input(event):
    if event is InputEventMouseMotion:
        update_mouse_position(event)
    
    # close game on clicking escape #DEBUG 
    if Input.is_key_pressed(KEY_ESCAPE):
        get_tree().quit()

func _process(delta):
    pass

# update the mouse position every time motion is detected
func update_mouse_position(e):
    mouse_position_h = e.position.x
    mouse_position_v = e.position.y