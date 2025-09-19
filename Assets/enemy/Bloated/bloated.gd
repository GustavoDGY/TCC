extends CharacterBody2D

@export var speed: float = 10.0
@export var gravity: float = 500.0
@export var direction: int = 1 # -1 = esquerda, 1 = direita

@onready var floor_ray: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	move_and_slide()
