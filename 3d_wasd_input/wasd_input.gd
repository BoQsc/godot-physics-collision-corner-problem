extends Node

# Signal to send movement direction
signal move_input(direction: Vector2)

func _ready():
	_add_input_action("move_left", KEY_A)
	_add_input_action("move_right", KEY_D)
	_add_input_action("move_up", KEY_W)
	_add_input_action("move_down", KEY_S)

func _add_input_action(action_name: String, key_code: int):
	if not InputMap.has_action(action_name):
		var event := InputEventKey.new()
		event.keycode = key_code
		InputMap.add_action(action_name)
		InputMap.action_add_event(action_name, event)

func _process(_delta):
	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	# Normalize to prevent diagonal speed boost
	if input_dir.length() > 1:
		input_dir = input_dir.normalized()

	emit_signal("move_input", input_dir)
