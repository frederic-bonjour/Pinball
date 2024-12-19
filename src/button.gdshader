shader_type canvas_item;

group_uniforms Resting;
uniform vec3 rest_color: source_color = vec3(1.0);

group_uniforms Hover;
uniform bool hover = false;
uniform vec3 hover_color: source_color = vec3(0.9);
uniform float stripe_attenuation: hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float stripe_slope: hint_range(0.0, 5.0, 0.1) = 3.;
uniform int stripe_count = 10;
uniform float speed = 1.;

void fragment() {
	if (hover) {
		vec2 uv = UV * vec2(float(stripe_count), 1.);
		uv.x -= TIME * speed;
		COLOR.rgb *= hover_color - mod(floor(uv.x + uv.y*stripe_slope), 2) * stripe_attenuation;
	} else {
		COLOR.rgb *= rest_color;
	}
}
