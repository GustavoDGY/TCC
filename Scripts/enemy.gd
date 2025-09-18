extends CharacterBody2D

@export var speed: float = 10.0
@export var gravity: float = 500.0
@export var direction: int = 1 # -1 = esquerda, 1 = direita

@onready var floor_ray: RayCast2D = $RayCast2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	hitbox.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	velocity.x = direction * speed
	move_and_slide()

	if is_on_wall():
		flip_direction()
	if not floor_ray.is_colliding():
		flip_direction()

func flip_direction() -> void:
	direction *= -1
	sprite.flip_h = direction < 0
	floor_ray.position.x = -floor_ray.position.x

func _on_body_entered(body: Node2D) -> void:
	# Verifica se o corpo que colidiu é uma instância do Player
	if body is Player:
		var knockback_dir = sign(body.global_position.x - global_position.x)
		body.apply_knockback(knockback_dir)
