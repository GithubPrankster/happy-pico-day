shader_type spatial;
render_mode unshaded, cull_front, specular_disabled, shadows_disabled, ambient_light_disabled;

uniform sampler2D tex : hint_albedo;
uniform vec4 mixer : hint_color = vec4(1.0);

vec4 fromLinear(vec4 linearRGB)
{
    bvec4 cutoff = lessThan(linearRGB, vec4(0.0031308));
    vec4 higher = vec4(1.055)*pow(linearRGB, vec4(1.0/2.4)) - vec4(0.055);
    vec4 lower = linearRGB * vec4(12.92);

    return mix(higher, lower, cutoff);
}

void vertex()
{
	if(OUTPUT_IS_SRGB){
		COLOR = fromLinear(COLOR);
	}
}

void fragment()
{
	vec4 res = texture(tex, UV);
	ALBEDO = (res.rgb * COLOR.rgb) * mixer.rgb;
}