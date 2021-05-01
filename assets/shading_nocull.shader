shader_type spatial;
render_mode unshaded, specular_disabled, shadows_disabled, ambient_light_disabled;

uniform sampler2D tex : hint_albedo;
uniform vec4 mixer : hint_color = vec4(1.0);

vec4 toLinear(vec4 sRGB)
{
    bvec4 cutoff = lessThan(sRGB, vec4(0.04045));
    vec4 higher = pow((sRGB + vec4(0.055))/vec4(1.055), vec4(2.4));
    vec4 lower = sRGB/vec4(12.92);

    return mix(higher, lower, cutoff);
}

void vertex()
{
	if(!OUTPUT_IS_SRGB){
		COLOR = toLinear(COLOR);
	}
}

void fragment()
{
	vec4 res = texture(tex, UV);
	ALBEDO = (res.rgb * COLOR.rgb) * mixer.rgb;
}