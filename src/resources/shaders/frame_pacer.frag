uniform vec2 size;
uniform float target_frame_time;
uniform float frame_times[60];

int COUNT = frame_times.length();

vec3 frame_graph(vec2 uv) {
    // Map UV x-coordinate to frame index
    float frame_index_f = uv.x * float(COUNT);
    int frame_index = int(clamp(frame_index_f, 0.0, float(COUNT - 1)));
    
    // Get frame time for this position
    float frame_time = frame_times[frame_index];
    float diff = (frame_time - target_frame_time) / target_frame_time;
    
    // start with 0.5 aka vertically centered, then add remaining difference
    float normalized_time = 0.5 + 0.5 * diff; 

    if (uv.y > normalized_time) {
        return vec3(0.1, 0.1, 0.1); // background
    }

    if (normalized_time > 0.7) {
        return vec3(1.0, 0.0, 0.0);
    }

    if (normalized_time > 0.6) {
        return vec3(1.0, 1.0, 0.0);
    }

    return vec3(0.0, 1.0, 0.0); 
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

    vec3 result = frame_graph(uv);

    return vec4(result, 0.8); // Semi-transparent overlay
}