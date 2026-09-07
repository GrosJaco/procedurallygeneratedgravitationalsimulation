shader_type canvas_item;

uniform float rect_size = 20000.0; 
uniform float pixel_size = 0.5;

uniform float star_radius = 0.35; 
uniform vec4 color_core : source_color = vec4(1.0, 1.0, 0.8, 1.0);
uniform vec4 color_halo : source_color = vec4(1.0, 0.6, 0.0, 1.0);

void fragment() {
    float grid_cells = rect_size / pixel_size;
    vec2 grid_uv = floor(UV * grid_cells) / grid_cells;
    vec2 center_dir = grid_uv - vec2(0.5);
    float dist = length(center_dir);

    float halo_limit = 0.48; 

    if (dist > star_radius) {
        if (dist < halo_limit) {
            float alpha = smoothstep(halo_limit, star_radius, dist);
            COLOR = vec4(color_halo.rgb, alpha * 0.8);
        } else {
            COLOR = vec4(0.0);
        }
    } else {
        float intensity = smoothstep(star_radius, 0.0, dist);
        COLOR = mix(color_halo, color_core, intensity);
    }
}