extends CharacterBody2D
class_name Player

signal vida_mudou(nova_vida: int)

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
var vida = 5

@onready var death_ui = $"../DeathUI"
@onready var animation = $AnimatedSprite2D
@onready var player = $"."

@export var knockback_force: Vector2 = Vector2(100, -100)
var is_knocked: bool = false
@onready var knockback_timer: Timer = Timer.new()

@export var attack_duration: float = 0.3
@onready var attack_timer: Timer = Timer.new()

# Track floor state for landing detection
var was_on_floor: bool = true
enum MovementState {
	IDLE,
	RUNNING,
	JUMPING,
	ON_AIR,
	LANDED
}

enum ActionState {
	NONE,
	ATTACKING
}

enum StatusState {
	NORMAL,
	DAMAGED,
	DYING
}

var movement_state: MovementState = MovementState.IDLE
var action_state: ActionState = ActionState.NONE
var status_state: StatusState = StatusState.NORMAL

func set_movement_state(new_state: int) -> void:
	if movement_state == new_state:
		return
	movement_state = new_state

func set_action_state(new_state: int) -> void:
	if action_state == new_state:
		return
	action_state = new_state

func set_status_state(new_state: int) -> void:
	if status_state == new_state:
		return
	status_state = new_state

func _ready() -> void:
	add_child(knockback_timer)
	knockback_timer.one_shot = true
	knockback_timer.wait_time = 0.3 # Ajuste a duração do knockback aqui
	knockback_timer.timeout.connect(end_knockback)

	add_child(attack_timer)
	attack_timer.one_shot = true
	attack_timer.wait_time = attack_duration
	attack_timer.timeout.connect(end_attack)

func _process(delta: float) -> void:
	control_animations()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var on_floor := is_on_floor()
	if not on_floor:
		velocity += get_gravity() * delta

	# When knocked or dying, let physics carry the body and skip input
	if is_knocked or status_state == StatusState.DYING:
		# Apenas move o jogador com a velocidade do knockback, sem input
		move_and_slide()
		was_on_floor = on_floor
		return

	# Handle attack input (can overlap with movement states)
	if Input.is_action_just_pressed("attack") and action_state == ActionState.NONE:
		set_action_state(ActionState.ATTACKING)
		attack_timer.start(attack_duration)

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and on_floor:
		velocity.y = JUMP_VELOCITY
		set_movement_state(MovementState.JUMPING)

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		animation.flip_h = direction < 0
	
	velocity.x = direction * SPEED
	
	var landed_this_frame := (not was_on_floor) and on_floor
	if not on_floor:
		if velocity.y < 0.0:
			set_movement_state(MovementState.JUMPING)
		else:
			set_movement_state(MovementState.ON_AIR)
	else:
		if landed_this_frame:
			set_movement_state(MovementState.LANDED)
		elif direction != 0:
			set_movement_state(MovementState.RUNNING)
		else:
			set_movement_state(MovementState.IDLE)

	move_and_slide()

	# After processing landing frame, transition to proper ground state
	if landed_this_frame:
		if direction != 0:
			set_movement_state(MovementState.RUNNING)
		else:
			set_movement_state(MovementState.IDLE)

	was_on_floor = on_floor

func apply_knockback(direction: int) -> void:
	is_knocked = true
	set_status_state(StatusState.DAMAGED)
	velocity.x = knockback_force.x * direction
	velocity.y = knockback_force.y
	knockback_timer.start()

func end_knockback() -> void:
	is_knocked = false
	velocity.x = 0
	if status_state != StatusState.DYING:
		set_status_state(StatusState.NORMAL)

func end_attack() -> void:
	set_action_state(ActionState.NONE)

func take_damage(damage_amount: int) -> void:
	vida -= damage_amount
	vida_mudou.emit(vida)
	# Futuramente, você pode adicionar a lógica de "morte" aqui
	if vida <= 0:
		set_status_state(StatusState.DYING)
		# Chama a função para mostrar a tela de morte
		death_ui.show_death_screen()
	else:
		set_status_state(StatusState.DAMAGED)
		
func control_animations():
	# Prioritize dying animation if available
	if status_state == StatusState.DYING:
		if animation.sprite_frames and animation.sprite_frames.has_animation("die"):
			animation.play("die")
			return
	# Then attacking if available
	if action_state == ActionState.ATTACKING:
		if animation.sprite_frames and animation.sprite_frames.has_animation("attack"):
			animation.play("attack")
			return
	# Otherwise, use movement state
	match movement_state:
		MovementState.RUNNING:
			animation.play("run")
		MovementState.JUMPING:
			animation.play("jump")
		MovementState.ON_AIR: 
			animation.play("air")
		MovementState.LANDED:
			animation.play("land")
		MovementState.IDLE:
			animation.play("idle")
