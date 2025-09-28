extends Node2D

@export var jumpscare_sound: AudioStream = preload("res://jumpscare (1).wav")
@export var next_scene_path: String = "res://path_to_scene.tscn"  # optional scene change
@export var flash_duration := 0.3
@export var detection_radius := 65  # distance from player to trigger jumpscare


var has_triggered := false  # ensures this NPC only triggers once

var flash_rect: ColorRect
var canvas_layer: CanvasLayer
var audio_player: AudioStreamPlayer

func _ready():
	# CanvasLayer to ensure flash is on top
	canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	add_child(canvas_layer)

	# Fullscreen flash (transparent initially)
	flash_rect = ColorRect.new()
	flash_rect.color = Color(1, 1, 1, 0)
	flash_rect.anchor_left = 0
	flash_rect.anchor_top = 0
	flash_rect.anchor_right = 1
	flash_rect.anchor_bottom = 1
	canvas_layer.add_child(flash_rect)

	# Audio player for jumpscare
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = jumpscare_sound
	add_child(audio_player)

func _process(delta):
	if has_triggered:
		return  # Already triggered

	var player_node = Global.player
	if player_node:
		var distance = global_position.distance_to(player_node.global_position)
		if distance <= detection_radius:
			has_triggered = true
			await do_jumpscare()

# Jumpscare function
func do_jumpscare() -> void:
	# Play jumpscare sound immediately
	audio_player.play()

	# Flash screen using Tween
	var tween = create_tween()
	tween.tween_property(flash_rect, "color", Color(.3, 0, 0, 1), flash_duration / 2)
	tween.tween_property(flash_rect, "color", Color(1, 1, 1, 0), flash_duration / 2).set_delay(flash_duration / 2)

	# Increment global jumpscare counter
	Global.activated_amalgams += 1
	print("Activated amalgams: ", Global.activated_amalgams)

	# Wait until flash ends
	await get_tree().create_timer(flash_duration).timeout

	# After 4 jumpscares, run your global command
	if Global.activated_amalgams == 4:
		Global.next_scene_path()  # <-- replace with your actual function

	# Optional: transition to a new scene after each jumpscare
	if Global.activated_amalgams >= 1:
		get_tree().change_scene_to_file(next_scene_path)
