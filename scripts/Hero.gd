# Main character (player). Mostly you're just updating the input vector in Mover
# with key controls. 

extends "res://scripts/Mover.gd"

export(bool) var locked = false # Locks from movement
export(bool) var runOnly = false # Forces run mode
export(bool) var walkOnly = false # Forces walk mode

var lastInputVector = Vector2() # To reduce calculations when there's no change

func _ready():
	GroundLocked = true
	applyGroundLock(global_transform.origin)
	
func _process(delta):
	if locked:
		return
	else:
		# Determine whether the user is walking or running
		var speed = 3
		if walkOnly:
			speed = 2.5
		elif not runOnly:
			if Input.is_action_pressed("walk"):
				speed = 2.5
		speed *= delta
		
		var inputVector = _getInputVector()
		
		# Optimization: No re-computing movement vector if controls haven't changed. 
		# Also prevents camera changes from stuttering user
		if lastInputVector != inputVector:
			lastInputVector = inputVector
			var cam = get_node("../../CameraSet").currentCamera
			MovementVector = _translateInputVectorForCamera(inputVector, cam) * speed
		
# Retrieves a normalized x/y representing keyboard with no transform applied
func _getInputVector():
	var inputVector = Vector2()
	if Input.is_action_pressed("left"):
		inputVector.x = -0.75
	elif Input.is_action_pressed("right"):
		inputVector.x = 0.75
		
	if Input.is_action_pressed("up"):
		inputVector.y = 1.5
	elif Input.is_action_pressed("down"):
		inputVector.y = -1.5
	
	return inputVector

# Returns a V3 calculated from a V2 input vector in relation to the POV of a camera
func _translateInputVectorForCamera(inputVector, camera):
	var result = Vector3(inputVector.x, 0, -inputVector.y)
	var angle = camera.rotation_degrees.y
	var absolute = abs(angle)

	# We want to consider every 45 degrees of peripheral range a different directional
	# facing with -45 to 45 as north, 45 to 135 west, etc. Since it's actually -179 to 179
	# I'm using absolute to take advantage and know north and south right off the bat.
	if absolute < 45:
		pass # facing due north, vector is safe
	elif absolute < 135:
		# We are facing east or west, therefore invert controls
		result = Vector3(-inputVector.y, 0, inputVector.x)

		if angle > 45: # Facing west, z inverts
			result.z = result.z * -1
		else: # Facing east, x inverts
			result.x = result.x * -1
	else:
		# As we are facing south both directions change their baring
		result.z = result.z * -1
		result.x = result.x * -1
	return result
	
