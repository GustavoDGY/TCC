extends CharacterBody2D

#Atributos do inimigo
@export var vida: int = 10
@export var speed: float = 10.0
@export var attack_damage = 1

#Interaçao com o mundo
@export var gravity: float = 500.0
var direction: int = 1

enum EnemyState {IDLE, PATROLLING, CHASING, ATTACKING}
@export var enemy_state = EnemyState.IDLE

@onready var floor_ray: RayCast2D = $RayCast2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

var teste = 0

func _ready() -> void:
	hitbox.body_entered.connect(_on_body_entered)
	# Normaliza a escala do nó raiz e sincroniza a orientação visual inicial
	self.scale.x = direction * -1

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	control_animation()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if is_on_wall() or not floor_ray.is_colliding():
		flip_direction()

	if enemy_state == EnemyState.PATROLLING:
		velocity.x = direction * speed
	elif enemy_state == EnemyState.IDLE:
		velocity.x = 0
		
	move_and_slide()

func control_animation():
	if enemy_state == EnemyState.IDLE:
		sprite.play("idle")
	elif enemy_state == EnemyState.PATROLLING:
		sprite.play("patrol")

func flip_direction():
	direction *= -1
	# Espelha somente o sprite para evitar conflitos com filhos
	sprite.flip_h = direction < 0
	# Ajusta o RayCast para olhar sempre para a frente
	floor_ray.position.x = -floor_ray.position.x
	if enemy_state == EnemyState.PATROLLING:
		velocity.x = direction * speed

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(1)
		var knockback_dir = sign(body.global_position.x - global_position.x)
		body.apply_knockback(knockback_dir)
