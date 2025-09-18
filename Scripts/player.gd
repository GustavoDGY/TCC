extends CharacterBody2D
class_name Player

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var vida = 5

@export var knockback_force: Vector2 = Vector2(100, -100)
var is_knocked: bool = false
@onready var knockback_timer: Timer = Timer.new()

func _ready() -> void:
	add_child(knockback_timer)
	knockback_timer.one_shot = true
	knockback_timer.wait_time = 0.3 # Ajuste a duração do knockback aqui
	knockback_timer.timeout.connect(end_knockback)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_knocked:
		# Apenas move o jogador com a velocidade do knockback, sem input
		move_and_slide()
		return

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func apply_knockback(direction: int) -> void:
	is_knocked = true
	velocity.x = knockback_force.x * direction
	velocity.y = knockback_force.y
	knockback_timer.start()

func end_knockback() -> void:
	is_knocked = false
	velocity.x = 0
