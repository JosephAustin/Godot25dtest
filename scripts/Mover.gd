# Basically this is a body that stays with its base on ground level as the movement
# vector is changed. See the Hero. Separating this makes it so you could have several
# NPCs with the same position checks.

extends KinematicBody

var GroundLocked = false

var MovementVector = Vector3()

func applyGroundLock(forPosition):
	if GroundLocked:
		var state = get_world().direct_space_state
		var intersect = state.intersect_ray(forPosition, Vector3(0, -100, 0), [], 0 | 1)
		if intersect && intersect.position: 
			if abs(global_transform.origin.y - intersect.position.y) < 1: # Prevents massive climbs or drops
				global_transform.origin.y = intersect.position.y + 0.5
				return true
		return false
	return true
	
func _process(delta):
	if MovementVector == Vector3.ZERO:
		pass # stop animations
	else:
		# Prevent continuing into collisions
		if not test_move(transform, MovementVector):
			var newPosition = translation + (MovementVector)
			look_at(newPosition, Vector3.UP)
			newPosition.y += 1
			
			if applyGroundLock(newPosition):
				move_and_collide(MovementVector)


