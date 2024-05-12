shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float greyScaleIntensity: hint_range(0.0, 1.0) = 1.0;

void fragment() {
	// V1
	vec4 my_texture = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	float color_average = (my_texture.r + my_texture.g + my_texture.b) / 3.0 * greyScaleIntensity;
	COLOR = vec4(color_average, color_average, color_average, my_texture.a);
	
	// V2
	//vec3 greyScale = vec3(0.5, 0.5, 0.5);
	//COLOR = vec4(vec3(dot(my_texture.rgb, greyScale)), my_texture.a);
}