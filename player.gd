extends CharacterBody2D

var screen_size
const gravity : int = 1000
const max_vel : int = 600
const float_speed : int = -500
var floating : bool = false
var falling : bool = false
const starting_position = Vector2(100, 400)

func _ready() -> void:
	reset()
	screen_size = get_viewport_rect().size
	pass
	
func reset():
	falling = false
	floating = false
	position = starting_position
	set_rotation(0)

func _physics_process(delta: float) -> void:
	if floating or falling:
		velocity.y += gravity * delta
		if velocity.y > max_vel:
			velocity.y = max_vel
		if floating:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		elif floating:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
			move_and_collide(velocity * delta)
		else :
			$AnimatedSprite2D.stop()
func flap():
	velocity.y = float_speed
	pass
	
func _process(delta: float) -> void:
	
	pass
