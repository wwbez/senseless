extends CanvasLayer

@onready var player = get_node("/root/MainScene/Player")
@onready var fog_shader = $ColorRect.material

func _process(delta):
	var camera = get_viewport().get_camera_2d()
	if camera and player:
		var screen_pos = camera.unproject_position(player.global_position)
		fog_shader.set_shader_parameter("player_pos", screen_pos)
