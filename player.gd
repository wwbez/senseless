extends CharacterBody2D

@export var movement_speed: float = 100.0
@export var light_radius: float = 200.0  # radius of torchlight

var last_facing_direction := "Right"

# Internal nodes for light
var darkness_overlay: ColorRect
var light_sprite: Sprite2D

func _ready():
	# Assign this player to global for access everywhere
	Global.player = self

	# Create a full-screen black overlay
	darkness_overlay = ColorRect.new()
	darkness_overlay.color = Color(0, 0, 0, 1)  # fully black
	darkness_overlay.size = get_viewport_rect().size  # corrected property
	var canvas = CanvasLayer.new()
	canvas.layer = 100  # ensure it's on top
	canvas.add_child(darkness_overlay)
	get_tree().current_scene.add_child(canvas)

	# Create a light sprite on top
	light_sprite = Sprite2D.new()
	var grad = Gradient.new()
	grad.add_point(0.0, Color(1,1,1,1))  # bright center
	grad.add_point(1.0, Color(1,1,1,0))  # transparent edges

	var tex = GradientTexture2D.new()
	tex.gradient = grad
	tex.width = 256
	tex.height = 256
	tex.fill = GradientTexture2D.FILL_RADIAL

	light_sprite.texture = tex
	light_sprite.centered = true
	light_sprite.scale = Vector2(light_radius/128, light_radius/128)
	canvas.add_child(light_sprite)

func _physics_process(_delta):
	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if input_vector != Vector2.ZERO:
		velocity = input_vector.normalized() * movement_speed

		if input_vector.x < 0:
			$AnimatedSprite2D.play("walkLeft")
			last_facing_direction = "Left"
		elif input_vector.x > 0:
			$AnimatedSprite2D.play("walkRight")
			last_facing_direction = "Right"
		else:
			if last_facing_direction == "Left":
				$AnimatedSprite2D.play("walkLeft")
			else:
				$AnimatedSprite2D.play("walkRight")
	else:
		velocity = Vector2.ZERO
		if last_facing_direction == "Left":
			$AnimatedSprite2D.play("idleLeft")
		else:
			$AnimatedSprite2D.play("idleRight")

	move_and_slide()
