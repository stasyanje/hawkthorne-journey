uniform vec2 size;
uniform float target_frame_time;
uniform float frame_times[60];
uniform int sample_count;

vec3 frame_graph(vec2 uv) {
    if (sample_count <= 0) {
        return vec3(0.2, 0.2, 0.2); // Gray background when no data
    }
    
    // Map UV x-coordinate to frame index
    float frame_index_f = uv.x * float(sample_count);
    int frame_index = int(clamp(frame_index_f, 0.0, float(sample_count - 1)));
    
    // Get frame time for this position
    float frame_time = frame_times[frame_index];
    
    // Normalize frame time (target = 0.5 height, double target = 1.0 height)
    float normalized_time = frame_time / (target_frame_time * 2.0);
    normalized_time = clamp(normalized_time, 0.0, 1.0);
    
    // Draw the bar graph
    if (uv.y <= normalized_time) {
        // Color based on performance
        if (frame_time <= target_frame_time) {
            return vec3(0.0, 1.0, 0.0); // Green for good performance
        } else if (frame_time <= target_frame_time * 1.5) {
            return vec3(1.0, 1.0, 0.0); // Yellow for moderate lag
        } else {
            return vec3(1.0, 0.0, 0.0); // Red for bad performance
        }
    }
    
    // Background
    return vec3(0.1, 0.1, 0.1);
}

vec3 draw_target_line(vec2 uv) {
    float target_y = 0.5; // Target line at 50% height
    float line_thickness = 0.005;
    
    if (abs(uv.y - target_y) < line_thickness) {
        return vec3(1.0, 1.0, 1.0); // White target line
    }
    
    return vec3(0.0, 0.0, 0.0); // No contribution
}

vec4 assert(vec4 result, bool condition) {
    return result;
}

bool assert_norm(vec2 uv) {
    return uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0;
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {    
    vec2 uv = vec2(
        pixel_coords.x / size.x,
        1.0 - pixel_coords.y / size.y  // Flip Y so bars grow upward
    );

    if (!assert_norm(uv)) {
        return vec4(1.0, 0.0, 0.0, 1.0); // Red for out of bounds
    }

    // Start with frame graph
    vec3 result = frame_graph(uv);
    
    // Add target line overlay
    vec3 target_line = draw_target_line(uv);
    result = mix(result, target_line, length(target_line));

    return vec4(result, 0.8); // Semi-transparent overlay
}