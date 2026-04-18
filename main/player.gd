extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var interface: XRInterface

func _ready():
	add_to_group("player")
	var interface = XRServer.find_interface("OpenXR")
	if interface and interface.initialize():
		# turn the main viewport into an ARVR viewport:
		get_viewport().use_xr = true
# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# turn off v-sync
		#OS.vsync_enabled = false

		# put our physics in sync with our expected frame rate:
		#Engine.iterations_per_second= 90

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
