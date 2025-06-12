#pragma language glsl3

#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
    #define MY_HIGHP_OR_MEDIUMP highp
#else
    #define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
// (sprite_pos_x, sprite_pos_y, sprite_width, sprite_height) [not normalized]
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
// (width, height) for atlas texture [not normalized]
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

extern MY_HIGHP_OR_MEDIUMP float scale_mod = 1;
extern MY_HIGHP_OR_MEDIUMP float rotate_mod = 1;
extern MY_HIGHP_OR_MEDIUMP number output_scale = 1;

extern Image base_image;
// (sprite_pos_x, sprite_pos_y, sprite_width, sprite_height) [not normalized]
extern MY_HIGHP_OR_MEDIUMP vec4 base_texture_details = vec4(0, 0, 71, 95);
// (width, height) for atlas texture [not normalized]
extern MY_HIGHP_OR_MEDIUMP vec2 base_image_details = vec2(710, 1520);

extern MY_HIGHP_OR_MEDIUMP vec2 top_left = vec2(0.042, 0.284);
extern MY_HIGHP_OR_MEDIUMP vec2 top_right = vec2(0.746, 0.284);
extern MY_HIGHP_OR_MEDIUMP vec2 bottom_right = vec2(0.746, 1.0);
extern MY_HIGHP_OR_MEDIUMP vec2 bottom_left = vec2(0.042, 1.0);

varying MY_HIGHP_OR_MEDIUMP mat3 t_invert;

#define MASK_OFFSET vec2(0.4, 0.0) // mask frame is 0.4 units away from the soul frame (normalised)
#define BASE_OFFSET vec2(-0.2, 0.0) // base frame is -0.2 units away from the soul frame (normalised)

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

vec2 mult_mat_inv_point(mat3 mat_inv, vec2 point) {
	vec3 result = mat_inv * vec3(point.x, point.y, 1.0);
	return vec2(result.x / result.z, result.y / result.z);
}

vec4 blend_normal(vec4 base_color, vec4 blend) {
	return vec4(blend.rgb * blend.a + base_color.rgb * (1.0 - blend.a), min(1, base_color.a + blend.a));
}

// function defs for required functions later in the code
vec4 dissolve_mask(vec4 tex, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

    float t = time * 10.0 + 2003.;
    vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
    
    vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
    vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
    vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
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

vec4 mask_layer(vec4 layer, float mask) {
    return vec4(layer.rgb, min(layer.a, mask));
}

vec4 soul_move(Image tex, vec2 uv, vec2 uv_min, vec2 uv_max) {
    // roughly what the values are:
    // float scale_mod = 0.07 + 0.02*sin(1.8*stand_mask.y);
    // float rotate_mod = 0.0025*sin(1.219*stand_mask.y);

    vec2 uv_size = uv_max - uv_min;
    vec2 uv_centre = (uv_min + uv_max) * 0.5;

    vec2 centred_normalized_uv = (uv - uv_centre) / uv_size; // translate uv to centre and normalise

    centred_normalized_uv *= (1.0 - scale_mod); // apply scaling

    // apply rotation
    float cos_angle = cos(rotate_mod);
    float sin_angle = sin(rotate_mod);
    mat2 rotation_matrix = mat2(cos_angle, -sin_angle, 
                                sin_angle, cos_angle);
    centred_normalized_uv *= rotation_matrix;

    vec2 transformed_uv = centred_normalized_uv * uv_size + uv_centre; // translate uv back and un-normalise

    // clip to bounds
    float epsilon = 0.0001;
    if (transformed_uv.x < (uv_min.x - epsilon) || transformed_uv.x > (uv_max.x + epsilon) ||
        transformed_uv.y < (uv_min.y - epsilon) || transformed_uv.y > (uv_max.y + epsilon))
    {
        return vec4(0.0); // outside the bounds, return transparent
    }
    else
    {
        return Texel(tex, transformed_uv); // inside the bounds, sample the texture at the transformed coordinate
    }
}

vec4 draw_shadow(Image tex, vec2 uv,  vec2 uv_min, vec2 uv_max, vec2 screen_coords, float shadow_strength) {
    vec2 light_screen_pos = vec2(0.5, 2.0) * love_ScreenSize.xy; // light origin, seems to be top-middle off screen a bit (but need to invert y because shadow length is inverted for some reason)
    vec2 screen_offset = (screen_coords - light_screen_pos) * vec2(-1.0); // mirror shadow because Balatro shadows work weird
    vec2 uv_offset = screen_offset / love_ScreenSize.xy;
    vec2 shadow_uv_offset = uv_offset * scale_mod * 0.33; // controls shadow length 
    vec2 shadow_origin_uv = uv - shadow_uv_offset; // soul uv with shadow offset

    vec4 shadow_caster_color = soul_move(tex, shadow_origin_uv, uv_min, uv_max); // move shadow with the soul layer
    vec4 mask_at_origin = Texel(tex, shadow_origin_uv + MASK_OFFSET + shadow_uv_offset); // have to add back in the shadow_uv_offset to get the correct mask coords
    float effective_caster_alpha = mask_layer(shadow_caster_color, mask_at_origin.r).a; // masked shadow alpha

    float final_shadow_alpha = effective_caster_alpha * shadow_strength;

    return vec4(0.0, 0.0, 0.0, final_shadow_alpha); // black shadow
}

vec4 effect(vec4 colour, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    // COORDINATES FOR STAND TEXTURE
    vec2 centre = vec2(0.5, 0.5);
    vec2 scaled_texture_coords = (texture_coords - centre) / output_scale + centre; // scale the entire uv to counter edge clipping
    vec2 dissolve_uv = (((scaled_texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;

    vec2 soul_min = vec2(0.4, 0.0); // bottom left position of the soul frame relative to image origin (normalised)
    vec2 soul_max = vec2(0.6, 1.0); // top right position of the soul frame relative to image origin (normalised)

    vec4 soul = soul_move(tex, scaled_texture_coords, soul_min, soul_max); // texture coords already offset for soul layer (i.e. starts at 0.4)
    vec4 mask = Texel(tex, scaled_texture_coords + MASK_OFFSET); // mask colour
    vec4 base_color = Texel(tex, scaled_texture_coords + BASE_OFFSET); // base colour

    vec2 pUV = mult_mat_inv_point(t_invert, dissolve_uv);

    vec4 under_color = vec4(0.0);
	if (pUV.x <= 1.0 && pUV.y  <= 1.0 && pUV.x >= 0.0 && pUV.y >= 0.0) {
        vec2 scale = base_texture_details.ba/base_image_details.xy;
        vec2 base_uv = vec2(
            pUV.x * scale.x + base_texture_details.x * scale.x,
            pUV.y * scale.y + base_texture_details.y * scale.y
        );

        under_color = Texel(base_image, base_uv);
    }

    if (soul.a > 0) {
        soul = blend_normal(under_color, soul);
    }

    float shadow_strength = 0.33; 
    vec4 shadow_layer = draw_shadow(
        tex, 
        scaled_texture_coords, 
        soul_min,
        soul_max,
        screen_coords,
        shadow_strength
    );

    // prevent shadow from drawing outside the base card (i.e. where base alpha is 0)
    // this is because it would overlap with the default card shadow and make a darker double-shadow
    shadow_layer = vec4(shadow_layer.rgb, min(shadow_layer.a, base_color.a));

    // factor for mixing the shadow and soul layers 
    // we want it to ramp up quickly as the soul alpha gets higher, thus squaring the alpha
    // any soul alpha value above √2 - 1 will cause the shadow to not be drawn underneath
    float blend_alpha = min(pow(1. + soul.a, 2) - 1., 1.);
    vec3 soul_with_shadow = mix(shadow_layer.rgb, soul.rgb, blend_alpha);
    soul = vec4(soul_with_shadow, max(soul.a, shadow_layer.a));
    soul = mask_layer(soul, mask.r);
    
    // required for dissolve fx
    return dissolve_mask(soul*colour, dissolve_uv);;
}

// --- below are all required functions --- //

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
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