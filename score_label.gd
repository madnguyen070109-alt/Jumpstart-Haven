extends Label

var player: Node
var finished := false

func _ready() -> void:
	player = get_tree().current_scene.find_child("player", true, false)
	if player:
		player.score_changed.connect(_on_score_changed)
		text = "Score: " + str(player.score)

func _on_score_changed(new_score: int) -> void:
	text = "Score: " + str(new_score)
	# Wait a frame so the collected coin is actually gone from the group
	await get_tree().process_frame
	if not finished and get_tree().get_nodes_in_group("collectible").is_empty():
		_end_game(new_score)

func _end_game(final_score: int) -> void:
	finished = true
	player.set_physics_process(false)  # freeze the player
	text = "You collected everything!\nScore: %d\nPress Space to restart" % final_score

func _unhandled_input(event: InputEvent) -> void:
	if finished and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
