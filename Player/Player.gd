extends KinematicBody2D

var velocity = Vector2.ZERO

var rotation_speed = 5.0
var speed = 0.1
var max_speed = 10



func _ready():
	pass

func _physics_process(_delta):
	position = position + velocity
	velocity = velocity.normalized() * clamp(velocity.length(), 0, max_speed)
	
	$Exhaust.hide()
	if Input.is_action_pressed("forward"):
		velocity = velocity + Vector2(0,-speed).rotated(rotation)
		$Exhaust.show()
	if Input.is_action_pressed("left"):
		rotation_degrees = rotation_degrees - rotation_speed
	if Input.is_action_pressed("right"):
		rotation_degrees = rotation_degrees + rotation_speed
		
	position.x = wrapf(position.x, 0, 1024)
	position.y = wrapf(position.y, 0, 600)
