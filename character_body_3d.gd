extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var wasd_input = get_node_or_null("WASDInput")
var input_dir: Vector2 = Vector2.ZERO

func _ready():
	if wasd_input:
		wasd_input.connect("move_input", _on_move_input)

func _on_move_input(direction: Vector2):
	# Update the global input direction when WASD is available
	input_dir = direction

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# If the WASD subnode isn't present, fall back to UI arrow keys
	if not wasd_input:
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	# Convert the 2D input direction into 3D movement based on the character's orientation
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
