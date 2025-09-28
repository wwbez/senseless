extends Node2D

@export var color_name: String = "Red"               # Pillar color
@export var matching_pillars: Array[NodePath] = []   # Other pillars linked to this one

@onready var sprite = get_node_or_null("BaseSprite") or get_node_or_null("BaseSprite2")
var activated: bool = false
var player_in_area: bool = false

func _ready():
	if sprite:
		sprite.modulate = Color.WHITE  # default unlit
	else:
		print("⚠️ No BaseSprite or BaseSprite2 found on ", name)

	# Connect signals for the ActivationArea
	var area = get_node_or_null("ActivationArea")
	if area:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)
	else:
		print("⚠️ ActivationArea missing on ", name)

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
	if sprite:
		sprite.modulate = get_glow_color(color_name)

	# Light up linked pillars
	for path in matching_pillars:
		var pillar = get_node_or_null(path)
		if pillar and pillar.has_method("force_activate"):
			pillar.force_activate(color_name)

# Called externally when another pillar activates us
func force_activate(color: String):
	activated = true
	if sprite:
		sprite.modulate = get_glow_color(color)

func get_glow_color(name: String) -> Color:
	match name:
		"Red": return Color(1, 0, 0)
		"Blue": return Color(0, 0, 1)
		"Green": return Color(0, 1, 0)
		_: return Color(1, 1, 1)
