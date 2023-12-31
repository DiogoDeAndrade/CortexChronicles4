extends CharacterBody3D

class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SPEED = 0.01

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var interactable : Node3D = null
var inventory : Array[String] = []
var hold : bool = false

# Auto initialized variables
@onready var camera := $Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if hold:
		return
		
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			self.rotate_y(-event.relative.x * MOUSE_SPEED)
			camera.rotate_x(-event.relative.y * MOUSE_SPEED)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !hold:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and !hold:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	if hold:
		if Input.is_action_just_pressed("Interact"):
			var gameText = Utils.find_game_text()
			if gameText:
				gameText.skip()

func has_item(item):
	return inventory.has(item)
	
func add_item(item : String, allow_duplicates : bool = false):
	if !allow_duplicates:
		if has_item(item):
			return
	inventory.append(item)
	
func set_hold(h : bool):
	hold = h
