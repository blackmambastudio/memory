shader_type canvas_item;

void fragment(){
	vec4 background = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 tex = texture(TEXTURE, UV);
	
	COLOR = tex*background;
	
}