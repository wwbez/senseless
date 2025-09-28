extends Node2D  # This script is for PillarB1

@export var color_name: String = "Blue"   # Set the color for B1
@export var matching_pillars: Array[NodePath] = []  # Add linked pillars here

@onready var base_sprite = $BaseSprite2
@onready var activation_area = $ActivationArea2

var activated = false
var player_in_area = false

func _ready():
	name = "PillarB1"  # Explicit name for clarity

	if not base_sprite:
		push_error("BaseSprite2 missing in " + name)
		return
	if not activation_area:
		push_error("ActivationArea2 missing in " + name)
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
		if pillar and pillar.has_node("BaseSprite2"):
			pillar.get_node("BaseSprite2").modulate = get_color_bright(color_name)

# Dark version (inactive)
func get_color_dark(name: String) -> Color:
	match name:
		"Red": return Color(0.3, 0, 0)
		"Blue": return Color(0, 0, 0.3)
		"Green": return Color(0, 0.3, 0)
		_: return Color(0.3, 0.3, 0.3)

# Bright version (activated)
func get_color_bright(name: String) -> Color:
	match name:
		"Red": return Color(1, 0, 0)
		"Blue": return Color(0, 0, 1)
		"Green": return Color(0, 1, 0)
		_: return Color(1, 1, 1)
