shader_type canvas_item; // Used for 2D nodes like TextureRect

// Uniforms allow you to change properties from the Godot Inspector

// Radius controls how big the circle is (0.0 to 0.5)
uniform float radius : hint_range(0.0, 10.0) = 5;
// Color of the circle
uniform vec4 circle_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // White
// Optional: Thickness of the border (0.0 for solid circle)
uniform float border_thickness : hint_range(0.0, 0.5) = 0.0; 
// Color of the border (only visible if border_thickness > 0)
uniform vec4 border_color : source_color = vec4(0.0, 0.0, 0.0, 1.0); // Black

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    
    // 1. Calculate the distance from the center (Simplified for reliability)
    // We shift the UV coordinates so the center of the node is (0, 0).
    vec2 corrected_uv = UV - center; 
    
    // NOTE: Aspect ratio correction removed to fix 'unknown identifier' error.
    // The circle will only be perfectly round if the TextureRect node is a perfect square.
    
    float dist = length(corrected_uv); // Distance from the center point
    
    // 2. Masking Logic Setup
    float smooth_edge = 0.005; // For a crisp, anti-aliased edge
    vec4 final_color = vec4(0.0); // Start fully transparent
    float alpha_mask = 0.0;
    
    float solid_mask = 0.0;  // Mask for the solid center
    float border_mask = 0.0; // Mask for the border ring
    
    if (border_thickness > 0.0) {
        // --- BORDER MODE (Ring) ---
        float inner_radius = radius - border_thickness;
        
        // 1. Mask for the solid inner part (1.0 inside, 0.0 outside)
        solid_mask = smoothstep(inner_radius, inner_radius - smooth_edge, dist);
        
        // 2. Mask for the full outer circle shape (1.0 inside, 0.0 outside)
        float outer_mask = smoothstep(radius, radius - smooth_edge, dist);
        
        // 3. Border area is the difference between the full shape and the solid inner part
        border_mask = outer_mask - solid_mask; 
        
        // The overall alpha is the total circle shape
        alpha_mask = outer_mask;
        
    } else {
        // --- SOLID CIRCLE MODE ---
        solid_mask = smoothstep(radius, radius - smooth_edge, dist);
        alpha_mask = solid_mask;
    }
    
    // 3. Combine the colors: Start transparent, layer border, then layer solid center
    final_color = mix(final_color, border_color, border_mask);
    final_color = mix(final_color, circle_color, solid_mask);

    // 4. Apply the overall alpha (transparency)
    final_color.a = alpha_mask;

    COLOR = final_color;
}