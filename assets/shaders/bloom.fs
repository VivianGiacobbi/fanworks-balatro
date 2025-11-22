#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec4 texture_details = vec4(0, 0, 71, 95);
extern MY_HIGHP_OR_MEDIUMP float bloom_size = 0.5;
extern MY_HIGHP_OR_MEDIUMP float bloom_intensity = 1;
extern MY_HIGHP_OR_MEDIUMP float bloom_threshold = 0.5;
extern MY_HIGHP_OR_MEDIUMP vec3 glow_colour = vec3(1, 1, 1);

vec4 custom_texelFetch(Image tex, ivec2 coord, int lod) {
    return Texel(tex, vec2(float(coord.x) / float(texture_details.b), float(coord.y) / float(texture_details.a)));
}

vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords) {

    vec4 pixel = Texel(tex, tex_coords);
    vec2 uv = vec2(tex_coords.x * texture_details.b, tex_coords.y * texture_details.a);

    if (pixel.a > bloom_threshold) {
        return pixel;
    }

    float sum = 0.0;
    for (int n = 0; n < 9; ++n) {
        uv.y = (tex_coords.y * texture_details.a) + (bloom_size * float(n - 4.5));
        float h_sum = 0.0;
        h_sum += custom_texelFetch(tex, ivec2(uv.x - (4.0 * bloom_size), uv.y), 0).a;
        h_sum += custom_texelFetch(tex, ivec2(uv.x - (3.0 * bloom_size), uv.y), 0).a;
        h_sum += custom_texelFetch(tex, ivec2(uv.x - (2.0 * bloom_size), uv.y), 0).a;
        h_sum += custom_texelFetch(tex, ivec2(uv.x - bloom_size, uv.y), 0).a;
        h_sum += custom_texelFetch(tex, ivec2(uv.x, uv.y), 0).a;
        h_sum += custom_texelFetch(tex, ivec2(uv.x + bloom_size, uv.y), 0).a;
        h_sum += custom_texelFetch(tex, ivec2(uv.x + (2.0 * bloom_size), uv.y), 0).a;
        h_sum += custom_texelFetch(tex, ivec2(uv.x + (3.0 * bloom_size), uv.y), 0).a;
        h_sum += custom_texelFetch(tex, ivec2(uv.x + (4.0 * bloom_size), uv.y), 0).a;
        sum += h_sum / 9.0;
    }

    return vec4(glow_colour, (sum / 9.0) * bloom_intensity);
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif