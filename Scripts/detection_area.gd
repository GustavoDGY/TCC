extends Area2D
class_name DetectionArea

@export var enemy_path: NodePath
@onready var enemy: CharacterBody2D = get_node(enemy_path) as CharacterBody2D

func _on_body_entered(body: Player) -> void:
	enemy.player_ref = body

func _on_body_exited(_body: Player) -> void:
	enemy.player_ref = null
