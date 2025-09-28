extends Node2D

@export var color_name: String = "Red"
@export var matching_pillars: Array[NodePath] = []

@onready var base_sprite = $BaseSprite
@onready var activation_area = $ActivationArea

var activated = false
var player_in_area = false

func _ready():
	if not base_sprite:
		push_error("BaseSprite missing!")
		return
	if not activation_area:
		push_error("ActivationArea missing!")
		return

	# Connect signals
	activation_area.body_entered.connect(_on_body_entered)
	activation_area.body_exited.connect(_on_body_exited)
	
	# Set initial color (darker)
	base_sprite.modulate = get_color_dark(color_name)

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("interact") and not activated:
		activate()

func _on_body_entered(body):
	if body.name == "Player":
		player_in_area = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false

func activate():
	activated = true
	base_sprite.modulate = get_color_bright(color_name)
	
	Global.activated_pillars += 1
	if(Global.activated_pillars == 3):
		print(Global.activated_pillars)
	
	# Activate matching pillars
	for path in matching_pillars:
		var pillar = get_node_or_null(path)
		if pillar and pillar.has_node("BaseSprite"):
			pillar.get_node("BaseSprite").modulate = get_color_bright(color_name)

# Dark version of the color (initial)
func get_color_dark(name: String) -> Color:
	match name:
		"Red": return Color(0, 0, 0)
		"Blue": return Color(0, 0, 0)
		"Green": return Color(0, 0, 0)
		_: return Color(0, 0, 0)

# Bright version (activated)
func get_color_bright(name: String) -> Color:
	match name:
		"Red": return Color(1, 0, 0)
		"Blue": return Color(0, 0, 1)
		"Green": return Color(0, 1, 0)
		_: return Color(1, 1, 1)
		
