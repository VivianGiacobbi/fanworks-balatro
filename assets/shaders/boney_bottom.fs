#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

// (x = sprite_pos_x, y = sprite_pos_y, b = sprite_width, a = sprite_height) [not normalized]
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
// (x = width, y = height) for atlas texture [not normalized]
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern Image mask_tex;
extern MY_HIGHP_OR_MEDIUMP float mask_mod;

vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords) {
    MY_HIGHP_OR_MEDIUMP vec2 uv = (((tex_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;
    MY_HIGHP_OR_MEDIUMP float width_mod = texture_details.b / image_details.x;
    MY_HIGHP_OR_MEDIUMP float height_mod = texture_details.a / image_details.y;
    MY_HIGHP_OR_MEDIUMP float x_pos = (uv.x + texture_details.x) * width_mod;
    MY_HIGHP_OR_MEDIUMP float y_pos = (uv.y + texture_details.y) * height_mod;

    vec4 pixel = Texel(tex, vec2(x_pos, y_pos));
    vec4 mask = Texel(mask_tex, tex_coords);  
    return vec4(pixel.rgb, max(0, pixel.a - (1 - mask.r) - mask_mod));
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