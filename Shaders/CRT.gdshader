shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

vec2 curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	uv *= 1.1;	
	uv.x *= 1.0 + pow((abs(uv.y) / 4.0), 2.0);
	uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
	uv  = (uv / 2.0) + 0.5;
	uv =  uv *0.92 + 0.04;
	return uv;
}
void fragment(  )
{
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 q = FRAGCOORD.xy / iResolution.xy;
    vec2 uv = q;
    uv = curve( uv );
    vec3 oricol = texture( screen_texture, vec2(q.x,q.y) ).xyz;
    vec3 col;
	float x =  sin(0.3*TIME+uv.y*21.0)*sin(0.7*TIME+uv.y*29.0)*sin(0.3+0.33*TIME+uv.y*31.0)*0.0017;

    col.r = texture(screen_texture,vec2(x+uv.x+0.001,uv.y+0.001)).x+0.05;
    col.g = texture(screen_texture,vec2(x+uv.x+0.000,uv.y-0.002)).y+0.05;
    col.b = texture(screen_texture,vec2(x+uv.x-0.002,uv.y+0.000)).z+0.05;
    col.r += 0.08*texture(screen_texture,0.75*vec2(x+0.025, -0.027)+vec2(uv.x+0.001,uv.y+0.001)).x;
    col.g += 0.05*texture(screen_texture,0.75*vec2(x+-0.022, -0.02)+vec2(uv.x+0.000,uv.y-0.002)).y;
    col.b += 0.08*texture(screen_texture,0.75*vec2(x+-0.02, -0.018)+vec2(uv.x-0.002,uv.y+0.000)).z;

    col = clamp(col*0.6+0.4*col*col*1.0,0.0,1.0);

    float vig = (0.0 + 1.0*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y));
	col *= vec3(pow(vig,0.3));

    col *= vec3(0.95,1.05,0.95);
	col *= 2.8;

	float scans = clamp(0.35+0.35*sin(3.5*TIME+uv.y*iResolution.y*1.5), 0.0, 1.0);
	
	float s = pow(scans,1.7);
	col = col*vec3( 0.4+0.7*s) ;

    col *= 1.0+0.01*sin(110.0*TIME);
	if (uv.x < 0.0 || uv.x > 1.0)
		col *= 0.0;
	if (uv.y < 0.0 || uv.y > 1.0)
		col *= 0.0;
	
	col*=1.0-0.65*vec3(clamp((mod(FRAGCOORD.x, 2.0)-1.0)*2.0,0.0,1.0));
	
    float comp = smoothstep( 0.1, 0.9, sin(TIME) );

    COLOR = vec4(col,1.0);
}



//shader_type canvas_item;
//
//uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
//uniform float scanline_count : hint_range(0, 1800) = 300.0;
//
//vec2 uv_curve(vec2 uv)
//{
	//uv = (uv - 0.5) * 2.0;
	//
	////You can modify the numbers and try different values
	//uv.x *= 1.0 + pow(abs(uv.y) / 3.0, 2.0);
	//uv.y *= 1.0 + pow(abs(uv.x) / 3.0, 2.0);
	//
	////The scale part (you can delete it when you want)
	//uv /= 1.2;
	//
	//uv = (uv/2.0) + 0.5;
	//return uv;
//}
//
//
//void fragment()
//{	
	////You can modify the *3.0, *-3.0 for a bigger or smaller 
	//float r = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x*1.0), 0.0).r;
	//float g = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x*3.0), 0.0).g;
	//float b = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x*-3.0), 0.0).b;
	//
	////If you dont want scanlines you can just delete this part
	//float s = sin(uv_curve(SCREEN_UV).y * scanline_count * PI * 2.0);
	//s = (s * 0.5 + 0.5) * 0.9 + 0.1;
	//vec4 scan_line = vec4(vec3(pow(s, 0.25)), 1.0);
	//
	//COLOR = vec4(r, g, b, 1.0) * scan_line;
//}