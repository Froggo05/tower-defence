shader_type canvas_item;

uniform int horizontal_frames = 4; // How many frames are in your sheet
uniform float fps = 12.0;

void fragment() {
    // Determine the current frame index based on time
    float frame = floor(TIME * fps);
    float frame_index = mod(frame, float(horizontal_frames));
    
    // Scale down the UV width to fit exactly one frame
    vec2 frame_uv = UV;
    frame_uv.x = (UV.x + frame_index) / float(horizontal_frames);
    
    // Output the slice of the sprite sheet
    COLOR = texture(TEXTURE, frame_uv);
}