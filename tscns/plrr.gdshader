shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec2 uv = UV - 0.5;
    float vignette = 1.0 - dot(uv, uv) * 2.0;
    vignette = clamp(vignette, 0.0, 1.0);
    COLOR = vec4(0.0, 0.0, 0.0, (1.0 - vignette) * strength);
}