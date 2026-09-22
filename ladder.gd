extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.set_on_ladder(true, self)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		body.set_on_ladder(false, null)
