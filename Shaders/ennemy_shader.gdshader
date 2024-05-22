shader_type canvas_item;

// flash uniforms
uniform vec4 flash_color: source_color = vec4(1.0);
uniform float flash_modifier: hint_range(0.0, 1.0)=1;

// glitch uniforms
uniform float shake_power = 0.0;
uniform float shake_rate : hint_range( 0.0, 1.0 ) = 0.01;
uniform float shake_speed = 5.0;
uniform float shake_block_size = 30.5;
uniform float shake_color_rate : hint_range( 0.0, 1.0 ) = 0.0;

uniform int is_flash: hint_range(0, 1, 1) = 1;

float random(float seed){
    return fract( 543.2543 * sin(dot(vec2(seed, seed), vec2( 3525.46, -54.3415 ) ) ) );
}

void fragment() {
	
	if (is_flash == 1){
		vec4 color = texture(TEXTURE,UV);
		color.rgb = mix(color.rgb, flash_color.rgb,flash_modifier);
		COLOR = color;
	}
	else{
			float enable_shift = float(
	        random( trunc( TIME * shake_speed ) )
	    <    shake_rate
	    );

	    vec2 fixed_uv = UV;
	    fixed_uv.x += (
	        random(
	            ( trunc( SCREEN_UV.y * shake_block_size ) / shake_block_size )
	        +    TIME
	        ) - 0.5
	    ) * shake_power * enable_shift;

	    vec4 pixel_color = texture( TEXTURE, fixed_uv );
	    pixel_color.r = mix(
	        pixel_color.r
	    ,    texture( TEXTURE, fixed_uv + vec2( shake_color_rate, 0.0 ) ).r
	    ,    enable_shift
	    );
	    pixel_color.b = mix(
	        pixel_color.b
	    ,    texture( TEXTURE, fixed_uv + vec2( -shake_color_rate, 0.0 ) ).b
	    ,    enable_shift
	    );
	    COLOR = pixel_color;
		}
}

