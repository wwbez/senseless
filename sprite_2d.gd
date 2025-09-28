extends CharacterBody2D  # You likely want to move the player, not just animate a sprite

@export var movement_speed: float = 60.0
var character_direction: Vector2 = Vector2.ZERO

enum States { IDLE, MOVE }
var currentState = States.IDLE

func _physics_process(delta: float) -> void:
	handle_state_transitions()
	perform_state_actions(delta)
	move_and_slide()  # Now valid because CharacterBody2D has this method


func handle_state_transitions() -> void:
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		currentState = States.MOVE
	else:
		currentState = States.IDLE


func perform_state_actions(delta: float) -> void:
	match currentState:
		States.MOVE:
			character_direction.x = Input.get_axis("ui_left", "ui_right")
			character_direction.y = Input.get_axis("ui_up", "ui_down")
			character_direction = character_direction.normalized()

			if character_direction.x < 0 and character_direction.y == 0:
				$Sprite.animation = "walkLeft"
			elif character_direction.x > 0 and character_direction.y == 0:
				$Sprite.animation = "walkRight"
			elif character_direction.y < 0:
				$Sprite.animation = "walkLeft"
			elif character_direction.y > 0:
				$Sprite.animation = "walkRight"

			velocity = character_direction * movement_speed

		States.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, movement_speed * delta)
			$Sprite.animation = "idle"
