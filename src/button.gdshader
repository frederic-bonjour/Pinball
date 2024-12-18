shader_type canvas_item;

uniform bool hover = false;
uniform vec3 hover_color: source_color = vec3(0.9);
uniform float stripe_attenuation: hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float stripe_slope: hint_range(0.0, 5.0, 0.1) = 3.;
uniform int stripe_count = 10;
uniform float speed = 1.;

void fragment() {
	// Keep drop shadow untouched
	if (hover && COLOR.r > 0. && COLOR.g > 0. && COLOR.b > 0.)
	{
		vec2 uv = UV * vec2(float(stripe_count), 1.);
		uv.x -= TIME * speed;
		COLOR.rgb = hover_color - mod(floor(uv.x + uv.y*stripe_slope), 2) * stripe_attenuation;
	}
	else
	{
		COLOR = COLOR;
	}
}
