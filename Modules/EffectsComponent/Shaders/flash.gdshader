shader_type canvas_item;

uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;
uniform vec3 flash_colour: source_color;

void fragment() {
    COLOR.rgb = mix(COLOR.rgb, flash_colour.rgb, flash_amount);
}