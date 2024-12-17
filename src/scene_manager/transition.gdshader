shader_type canvas_item;

uniform float count = 16.0;
uniform float progress: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform bool invert = false;
uniform vec2 direction = vec2(0.0, 1.0);


float circle(vec2 p, float r) {
	float d = length(p);
	return smoothstep(r, r-0.02, d);
}


void fragment() {
	// Calculer le ratio de la texture
	//float aspect_ratio = TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x;
	float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	// Normaliser les coordonnées UV en fonction du ratio
	vec2 normalized_uv = vec2(SCREEN_UV.x * aspect_ratio, SCREEN_UV.y);
	// Centrer les coordonnées autour de (0.5, 0.5) pour faciliter le dessin
	vec2 uv = normalized_uv - vec2(0.5 * aspect_ratio, 0.5);

	uv *= count;

	// La répétition n'est pas la même sur l'axe Y que sur l'axe X
	// afin que les cercles d'une ligne puissent toucher ceux des lignes adjacentes.
	// En fait, les cercles sont tous espacés de la même distance,
	// qu'ils soient sur la même ligne ou sur une ligne adjacente.
	// 1.7320508076 est la racine carrée de 3
	vec2 repeat = vec2(1, 1.7320508076);
    vec2 half_repeat = repeat * .5;

	vec2 grid_a = mod(uv, repeat) - half_repeat;
	vec2 grid_b = mod(uv-half_repeat, repeat) - half_repeat;

	vec2 gv;
	if (length(grid_a) < length(grid_b)) {
		gv = grid_a;
	} else {
		gv = grid_b;
	}

	float radius = (invert ? 1. - progress : progress) * 3.;
	vec2 p = UV * direction;
	if (p.x < 0.) p.x = 1. + p.x;
	if (p.y < 0.) p.y = 1. + p.y;
	float m = circle(gv, radius * (p.x + p.y + 0.2));

	COLOR.a = m;
}
