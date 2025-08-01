uniform float time;
uniform float size[2];
uniform float intervals[2];

vec2 closest_intervals(float uv_x) {
    int max_index = intervals.length() - 1;
    int pivot = int(uv_x * max_index);

    ivec2 indices;

    if (pivot >= max_index) {
        indices = ivec2(max_index - 1, max_index);
    } else if (pivot <= 0) {
        indices = ivec2(0, 1);
    } else {
        indices = ivec2(pivot, pivot + 1);
    }
    
    return vec2(intervals[indices.x], intervals[indices.y]);
}

vec3 pacing_line(vec2 uv) {
    float thickness = 0.01;

    vec2 closest = closest_intervals(uv.x);

    int max_index = intervals.length() - 1; 
    float segment_x = uv.x ;

    float x = (uv.x - 0.5) * 2.0;
    float y = (uv.y - 0.5) * 2.0;
    
    float line = step(y, thickness) - step(y, -thickness);

    return vec3(0.0, line, 0.0);
}

vec4 assert(vec4 result, bool condition) {
    return result;
}

bool assert_norm(vec2 uv) {
    return uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0;
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {    
    vec2 uv = vec2(
        pixel_coords.x / size[0],
        pixel_coords.y / size[1]
    );

    if (assert_norm(uv) == false) {
        return vec4(1.0, 0.0, 0.0, 1.0);
    }

    vec3 result = vec3(0.2);

    result.rgb += pacing_line(uv);

    return vec4(result, 0.5);
}