extends MeshInstance

# Export variables.
export var max_speed = 10.0
export var max_acceleration = 10.0
export var bounciness = 0.5
export var allowed_area = Rect2(Vector2(-5.0, -5.0), Vector2(10.0, 10.0))

# Script global variables.
var velocity = Vector3(0.0, 0.0, 0.0);

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var player_input = Vector2(0.0, 0.0)
	if Input.is_action_pressed("move_right"):
		player_input.x = -1.0
	if Input.is_action_pressed("move_left"):
		player_input.x = 1.0
	if Input.is_action_pressed("move_up"):
		player_input.y = 1.0
	if Input.is_action_pressed("move_down"):
		player_input.y = -1.0
	player_input = player_input.clamped(1.0)
	
	var desired_velocity = Vector3(player_input.x, 0.0, player_input.y) * max_speed
	var max_speed_change = max_acceleration * delta
	
	if (velocity.x < desired_velocity.x):
		velocity.x = min(velocity.x + max_speed_change, desired_velocity.x)
	elif (velocity.x > desired_velocity.x):
		velocity.x = max(velocity.x - max_speed_change, desired_velocity.x)
		
	if (velocity.z < desired_velocity.z):
		velocity.z = min(velocity.z + max_speed_change, desired_velocity.z)
	elif (velocity.z > desired_velocity.z):
		velocity.z = max(velocity.z - max_speed_change, desired_velocity.z)
	
	var displacement = velocity * delta
	var new_position = self.transform.origin + displacement
	
	if (not allowed_area.has_point(Vector2(new_position.x, new_position.z))):
		
		if new_position.x < allowed_area.position.x:
			new_position.x = allowed_area.position.x
			velocity.x = -velocity.x * bounciness
		elif (new_position.x > allowed_area.position.x + allowed_area.size.x):
			new_position.x = allowed_area.position.x + allowed_area.size.x
			velocity.x = -velocity.x * bounciness
			
		if new_position.z < allowed_area.position.y:
			new_position.z = allowed_area.position.y
			velocity.z = -velocity.z * bounciness
		elif (new_position.z > allowed_area.position.y + allowed_area.size.y):
			new_position.z = allowed_area.position.y + allowed_area.size.y
			velocity.z = -velocity.z * bounciness
		
	self.transform.origin = new_position
