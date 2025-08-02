shader_type canvas_item;

uniform vec2 scroll_speed = vec2(0.3, 0.3);
uniform float time_scale = 1.0;

void fragment() {
    vec2 uv = UV;
    uv += TIME * scroll_speed * time_scale;
    COLOR = texture(TEXTURE, fract(uv));
}