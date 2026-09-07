shader_type canvas_item;

uniform float rect_size = 1000.0; 
uniform float pixel_size = 0.5; 

uniform vec2 light_direction = vec2(1.0, 0.0); 
uniform vec4 color_light : source_color = vec4(0.4, 0.8, 0.4, 1.0);
uniform vec4 color_dark : source_color = vec4(0.2, 0.4, 0.2, 1.0);

void fragment() {
    float grid_cells = rect_size / pixel_size;
    vec2 grid_uv = floor(UV * grid_cells) / grid_cells;
    vec2 center_dir = grid_uv - vec2(0.5);
    float dist = length(center_dir);
    
    if (dist > 0.5) {
        COLOR = vec4(0.0);
    } else {
        vec2 pos_2d = center_dir * 2.0; 
        
        float z = sqrt(max(0.0, 1.0 - pos_2d.x * pos_2d.x - pos_2d.y * pos_2d.y)); 
        vec3 normal = vec3(pos_2d.x, pos_2d.y, z);
        
        vec3 light_dir_3d = normalize(vec3(light_direction.x, light_direction.y, 0.5));
        float light_intensity = dot(normal, light_dir_3d);
        
        if (light_intensity > 0.0) {
            COLOR = color_light;
        } else {
            COLOR = color_dark;
        }
    }
}