shader_type canvas_item;

uniform vec2 player_pos;
uniform float radius = 150.0;

void fragment() {
    vec2 uv_pixels = SCREEN_UV * vec2(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y);
    float dist = distance(uv_pixels, player_pos);
    float alpha = smoothstep(radius, radius-10.0, dist);
    COLOR = vec4(0.0, 0.0, 0.0, alpha);
}
