shader_type canvas_item;

uniform sampler2D my_texture : source_color;
uniform vec2 scroll_speed = vec2(0.5, 0.0);

void fragment() {
    vec2 uv_scroll = fract(UV + TIME * scroll_speed);
    vec4 tex_color = texture(my_texture, uv_scroll);
    COLOR = tex_color;
}
