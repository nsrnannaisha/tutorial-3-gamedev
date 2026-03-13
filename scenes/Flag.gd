extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		body.win()
		get_parent().get_node("WinBG").visible = true
		get_parent().get_node("WinText").visible = true
		await get_tree().create_timer(3.0).timeout
		get_tree().reload_current_scene()
