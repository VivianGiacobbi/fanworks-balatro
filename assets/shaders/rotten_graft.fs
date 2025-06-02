#pragma language glsl3

#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 top_left = vec2(0.389, 0.629);
extern MY_HIGHP_OR_MEDIUMP vec2 top_right = vec2(0.617, 0.629);
extern MY_HIGHP_OR_MEDIUMP vec2 bottom_right = vec2(0.777, 0.777);
extern MY_HIGHP_OR_MEDIUMP vec2 bottom_left = vec2(0.329, 0.777);

extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

varying MY_HIGHP_OR_MEDIUMP mat3 t_invert;

extern Image mask_tex;
extern MY_HIGHP_OR_MEDIUMP vec4 mask_texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 mask_image_details;

mat3 get_perspective_trans(vec2[4] poly) { 
	float dx1 = poly[1].x - poly[2].x;
	float dx2 = poly[3].x - poly[2].x;
	float dx3 = poly[0].x - poly[1].x + poly[2].x - poly[3].x;
	float dy1 = poly[1].y - poly[2].y;
	float dy2 = poly[3].y - poly[2].y;
	float dy3 = poly[0].y - poly[1].y + poly[2].y - poly[3].y;
 
	float a13 = (dx3 * dy2 - dy3 * dx2) / (dx1 * dy2 - dy1 * dx2);
	float a23 = (dx1 * dy3 - dy1 * dx3) / (dx1 * dy2 - dy1 * dx2);
	float a11 = poly[1].x - poly[0].x + a13 * poly[1].x;
	float a21 = poly[3].x - poly[0].x + a23 * poly[3].x;
	float a31 = poly[0].x;
	float a12 = poly[1].y - poly[0].y + a13 * poly[1].y;
	float a22 = poly[3].y - poly[0].y + a23 * poly[3].y;
	float a32 = poly[0].y;
 
	mat3 transform_mat = mat3(
		vec3(a11, a12, a13),
		vec3(a21, a22, a23),
		vec3(a31, a32, 1)
	);
	
	return inverse(transform_mat);
}

vec4 overlay(vec4 base_color, vec4 blend){
	vec4 limit = step(0.5, base_color);
	return mix(2.0 * base_color * blend, 1.0 - 2.0 * (1.0 - base_color) * (1.0 - blend), limit);
}

vec2 mult_mat_inv_point(mat3 mat_inv, vec2 point) {
	vec3 result = mat_inv * vec3(point.x, point.y, 1.0);
	return vec2(result.x / result.z, result.y / result.z);
}

vec4 dissolve_mask(vec4 tex, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    MY_HIGHP_OR_MEDIUMP float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

	MY_HIGHP_OR_MEDIUMP float t = time * 10.0 + 2003.;
	MY_HIGHP_OR_MEDIUMP vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    MY_HIGHP_OR_MEDIUMP vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
	
	MY_HIGHP_OR_MEDIUMP vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	MY_HIGHP_OR_MEDIUMP vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	MY_HIGHP_OR_MEDIUMP vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    MY_HIGHP_OR_MEDIUMP float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    MY_HIGHP_OR_MEDIUMP vec2 borders = vec2(0.2, 0.8);

    MY_HIGHP_OR_MEDIUMP float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

vec4 effect(vec4 colour, Image tex, vec2 tex_coords, vec2 screen_coords)
{	
    MY_HIGHP_OR_MEDIUMP vec2 uv = (((tex_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;
	vec2 pUV = mult_mat_inv_point(t_invert, uv);
	
	vec4 ret_color = vec4(0.0);
	if (pUV.x <= 1.0 && pUV.y  <= 1.0 && pUV.x >= 0.0 && pUV.y >= 0.0) {
		vec2 scale = texture_details.ba/image_details.xy;
		vec2 fixed_uv = vec2(
			pUV.x * scale.x + texture_details.x * scale.x,
			pUV.y * scale.y + texture_details.y * scale.y
		);

		vec2 mask_scale = mask_texture_details.ba/mask_image_details.xy;
		vec2 mask_coords = vec2(
			pUV.x * mask_scale.x + mask_texture_details.x * mask_scale.x,
			pUV.y * mask_scale.y + (mask_texture_details.y + 1) * mask_scale.y
		);
		vec4 mask = Texel(mask_tex, mask_coords); 

		ret_color = Texel(tex, fixed_uv);
		ret_color.a = max(0, (ret_color.a - (1 - mask.r)) * 0.75);
	}

	return dissolve_mask(ret_color * colour, uv);
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    vec2 poly[4] = vec2[4](top_left, top_right, bottom_right, bottom_left);
	t_invert = get_perspective_trans(poly);

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