extends CharacterBody2D

#Atributos do inimigo
@export var vida: int = 10
@export var speed: float = 32
@export var chase_speed: float = 60
@export var attack_damage = 1

#Interaçao com o mundo
@export var gravity: float = 500.0
var direction: int = 1
var can_flip: bool = true

enum EnemyState {IDLE, PATROLLING, CHASING, ATTACKING}
@export var enemy_state = EnemyState.IDLE

@onready var floor_ray: RayCast2D = $RayCast2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var chase_area: Area2D = $ChaseArea

var player : CharacterBody2D = null

func _ready() -> void:
	hitbox.body_entered.connect(_on_body_entered)
	# Normaliza a escala do nó raiz e sincroniza a orientação visual inicial
	self.scale.x = direction * -1

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	control_animation()
	
	if enemy_state != EnemyState.CHASING:
		can_flip = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if is_on_wall() or not floor_ray.is_colliding():
		if can_flip: flip_direction()

	if enemy_state == EnemyState.PATROLLING:
		velocity.x = direction * speed
	elif enemy_state == EnemyState.IDLE:
		velocity.x = 0
	elif enemy_state == EnemyState.CHASING:
		can_flip = false
		var chase_direction = 1 if player.global_position.x > global_position.x else -1
		velocity.x = chase_direction * chase_speed
		
	move_and_slide()

func control_animation():
	if enemy_state == EnemyState.IDLE:
		sprite.play("idle")
	elif enemy_state == EnemyState.PATROLLING:
		sprite.play("patrol")
	elif enemy_state == EnemyState.CHASING:
		sprite.speed_scale = chase_speed / speed

func flip_direction():
	direction *= -1
	# Espelha somente o sprite para evitar conflitos com filhos
	sprite.flip_h = direction < 0
	# Ajusta o RayCast para olhar sempre para a frente
	floor_ray.position.x = -floor_ray.position.x
	chase_area.scale.x *= -1
	if enemy_state == EnemyState.PATROLLING:
		velocity.x = direction * speed

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(1)
		var knockback_dir = sign(body.global_position.x - global_position.x)
		body.apply_knockback(knockback_dir)

func _on_chase_area_body_entered(body: Node2D) -> void:
	if body is Player:
		enemy_state = EnemyState.CHASING
		player = body as CharacterBody2D
