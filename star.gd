extends Area2D

func _ready() -> void:
	add_to_group("collectible")
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.add_score(1)
		queue_free()
