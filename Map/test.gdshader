shader_type canvas_item;
render_mode unshaded;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


void fragment() {
	vec4 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgba;
	c.r = float(1) - c.r;
	c.g = float(1) - c.g;
	c.b = float(1) - c.b;
	//COLOR.rgba = c;
}

