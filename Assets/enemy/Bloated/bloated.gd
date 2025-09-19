extends CharacterBody2D

@export var speed: float = 10.0
@export var gravity: float = 500.0
@export var direction: int = 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	move_and_slide()
