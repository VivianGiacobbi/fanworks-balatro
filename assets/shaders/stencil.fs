#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

vec4 effect(vec4 color, Image texture, vec2 tc, vec2 screen_coords) {
    float alpha = Texel(texture, tc).a;
    if (alpha == 0.0) {
        discard;
    }
    return vec4(vec3(1.0), alpha);
}