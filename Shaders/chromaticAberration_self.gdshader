shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform vec2 r_displacement = vec2(0.0, 0.0);
uniform vec2 g_displacement = vec2(0.0, 0.0);
uniform vec2 b_displacement = vec2(0.0, 0.0);

void fragment()
{
	vec4 color = texture(TEXTURE, UV);
	
	float r = texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE*r_displacement), 0.0).r;
	float g = texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE*g_displacement), 0.0).g;
	float b = texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE*b_displacement), 0.0).b;
	
	COLOR = vec4(r, g, b, color.a);
}