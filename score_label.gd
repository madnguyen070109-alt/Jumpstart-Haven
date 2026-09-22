extends Label


func _ready() -> void:
	# Find the player node in your scene (make sure the path matches your scene tree)
	# If your player is inside a level node, you might need: get_node("/root/Main/player")
	var player = get_tree().current_scene.find_child("player", true, false)
	
	if player:
		# Connect the player's signal to this label's function
		player.score_changed.connect(_on_score_changed)
		# Set the starting text
		text = "Score: " + str(player.score)

func _on_score_changed(new_score: int) -> void:
	# Update the visible text whenever the player updates their score
	text = "Score: " + str(new_score)
