# Area was overloaded to swap the camera when a 'zone' is entered

extends Area

# These must be set in the editor. Target is the camera to swap to when entered,
# player is the triggering player object (Hero)
export(NodePath) var target = null
export(NodePath) var player = null

var invalid = false

func _ready():
	connect("body_entered", self, "_on_Area_body_entered")
	pass

func _on_Area_body_entered(body):
	if !invalid:
		if player == null || target == null:
			print_debug(self.name + " does not have a proper variable configuration and is disabled.")
			invalid = true
		elif body == get_node(player):
			get_node("../").set_current_camera(get_node(target))
