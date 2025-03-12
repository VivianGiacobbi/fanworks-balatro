#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

#define PI 3.1415926538

extern MY_HIGHP_OR_MEDIUMP float time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;

extern MY_HIGHP_OR_MEDIUMP Image noise;
extern MY_HIGHP_OR_MEDIUMP vec4 color;
extern MY_HIGHP_OR_MEDIUMP float line_count = 0.5;
extern MY_HIGHP_OR_MEDIUMP float line_density = 0.5;
extern MY_HIGHP_OR_MEDIUMP float line_falloff = 0.25;
extern MY_HIGHP_OR_MEDIUMP float mask_size = 0.1;
extern MY_HIGHP_OR_MEDIUMP float mask_edge = 0.5;
extern MY_HIGHP_OR_MEDIUMP float speed = 10;

float inv_lerp(float from, float to, float value){
  return (value - from) / (to - from);
}

float rand(vec2 co)
{
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 polar_coords(vec2 uv, vec2 center, float zoom, float repeat)
{
	MY_HIGHP_OR_MEDIUMP vec2 dir = uv - center;
	MY_HIGHP_OR_MEDIUMP float radius = length(dir) * (1 + rand(uv));
	MY_HIGHP_OR_MEDIUMP float angle = atan(dir.y, dir.x) * 1.0/(PI * 2.0);
	return mod(vec2(radius * zoom, angle * repeat), 1.0);
}

vec2 rotate_uv(vec2 uv, vec2 pivot, float rotation) {
    MY_HIGHP_OR_MEDIUMP float cosa = cos(rotation);
    MY_HIGHP_OR_MEDIUMP float sina = sin(rotation);
    uv -= pivot;
    return vec2(
        cosa * uv.x - sina * uv.y,
        cosa * uv.y + sina * uv.x 
    ) + pivot;
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba - 0.5;
    vec2 polar_uv = polar_coords(rotate_uv(uv, vec2(0), floor(fract(time) * speed)), vec2(0), 0.01, line_count);
	vec3 lines = Texel(noise, polar_uv).rgb;
	
	float mask_value = length(uv);
	float mask = inv_lerp(mask_size, mask_edge, mask_value);
	float result = 1.0 - (mask * line_density);
	
	result = smoothstep(result, result + line_falloff, lines.r);
	
	return vec4(vec3(color.rgb), min(color.a, result));
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