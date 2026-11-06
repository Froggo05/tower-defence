shader_type canvas_item;

//AI CODE ALERT: shaders are still so hard for me. ive really gotta take some maths classes
uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;
//Altering to add any colour flash
uniform vec3 flash_colour: source_color;

void fragment() {
    COLOR.rgb = mix(COLOR.rgb, flash_colour.rgb, flash_amount);
}