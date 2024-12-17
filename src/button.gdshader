shader_type canvas_item;

uniform bool hover = false;

void fragment() {
	// Keep drop shadow untouched
	if (hover && COLOR.r>0. && COLOR.g>0. && COLOR.b>0.)
	{
		COLOR.rgb = 1. - vec3(UV.y * 0.8);
	} else {
		COLOR = COLOR;
	}
}
