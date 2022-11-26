extends Spatial

export(bool) var dev = false

var currentCamera = null

func set_current_camera(c):
	if currentCamera != null:
		currentCamera.Hide()
		
	currentCamera = c
	c.Switch(dev)

func _ready():
	set_current_camera(get_children()[0])

func _input(event):
	# Test manual camera swapping
	if event.is_action_pressed("switch"):
		var n = false
		var cams = get_children()
		for cam in cams:
			if cam.current:
				if cam == cams.back():
					set_current_camera(cams[0])
				else:
					n = true
			elif n:
				set_current_camera(cam)
				n = false
