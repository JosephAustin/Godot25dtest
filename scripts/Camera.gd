# This one does some of the frustrum math.

extends Camera

export(Vector2) var followTolerance = Vector2(1,1)
export(NodePath) var followTarget = null
export(Vector2) var targetOffset = Vector2(0,0)
export(float) var forcedPanSpeed = 0.0
export(Vector2) var minPan = Vector2(0,0)
export(Vector2) var maxPan = Vector2(0,0)

func _ready():
	visible = false

func _process(delta):
	var target = get_node(followTarget)
	var position = unproject_position(target.global_transform.origin)
	position -= get_viewport().size / 2
	
	var scaler = near * 0.0023 # this should be calculatable
	var distTol = 20
	var frustumTol = distTol * scaler
	var newOffset = frustum_offset
	if abs(position.x) > distTol:
		if position.x > 0:
			newOffset.x = (position.x * scaler) - frustumTol
		else:
			newOffset.x = (position.x * scaler) + frustumTol
	if abs(position.y) > distTol:
		if position.y > 0:
			newOffset.y = (-position.y * scaler) + frustumTol
		else:
			newOffset.y = (-position.y * scaler) - frustumTol
	frustum_offset.x = clamp(newOffset.x, minPan.x, maxPan.x) 
	frustum_offset.y = clamp(newOffset.y, minPan.y, maxPan.y) 
	
func Switch(dev):
	visible = true
	if dev && OS.is_debug_build():
		cull_mask = 1 | 2
	else:
		cull_mask = 2
	set_current(true)
		
func Hide():
	visible = false
